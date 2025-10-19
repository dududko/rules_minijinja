"""Implementation of minijinja_template rule."""

def _minijinja_template_impl(ctx):
    """Implementation function for minijinja_template rule.

    Args:
        ctx: Rule context.

    Returns:
        DefaultInfo provider with generated files.
    """

    # Get the template file
    template = ctx.file.template

    # Get output file
    output = ctx.outputs.out

    # Collect all data files (context files)
    data_files = ctx.files.data

    # Get the minijinja-cli binary from the toolchain
    toolchain = ctx.toolchains["@rules_minijinja//minijinja:toolchain_type"]
    minijinja_info = toolchain.minijinjainfo

    # Create a shell script to run minijinja-cli and redirect output
    # We need this because minijinja-cli outputs to stdout
    script_content = "#!/usr/bin/env bash\nset -euo pipefail\n"

    # Build the minijinja-cli command
    cmd_parts = [minijinja_info.target_tool_path]

    # Add whitespace control flags to match jinja2 behavior
    # These match the Python implementation's trim_blocks and lstrip_blocks settings
    cmd_parts.append("--trim-blocks")
    cmd_parts.append("--lstrip-blocks")

    # Add template file
    cmd_parts.append(template.path)

    # Add data file if provided (minijinja-cli takes data file as second positional arg)
    # If multiple data files are provided, we'll need to merge them or use the first one
    # For now, let's use the first data file if available
    if data_files:
        if len(data_files) > 1:
            fail("minijinja-cli currently supports only one data file. Use substitutions for additional values or merge your data files.")
        cmd_parts.append(data_files[0].path)

    # Add substitutions as -D key=value pairs
    for key, value in ctx.attr.substitutions.items():
        cmd_parts.append("-D")
        cmd_parts.append("{}={}".format(key, value))

    # Redirect output to the output file
    cmd_parts.append(">")
    cmd_parts.append(output.path)

    script_content += " ".join(cmd_parts) + "\n"

    # Write the script to a file
    script_file = ctx.actions.declare_file(ctx.label.name + "_render.sh")
    ctx.actions.write(
        output = script_file,
        content = script_content,
        is_executable = True,
    )

    # Create list of all input files
    inputs = [template] + data_files + minijinja_info.tool_files

    # Run the script
    ctx.actions.run(
        inputs = inputs,
        outputs = [output],
        executable = script_file,
        mnemonic = "minijinjaTemplate",
        progress_message = "Rendering minijinja template %s" % template.short_path,
    )

    return [
        DefaultInfo(
            files = depset([output]),
            runfiles = ctx.runfiles(files = [output]),
        ),
    ]

minijinja_template = rule(
    implementation = _minijinja_template_impl,
    attrs = {
        "template": attr.label(
            doc = "The minijinja template file to render.",
            allow_single_file = True,
            mandatory = True,
        ),
        "out": attr.output(
            doc = "The output file to generate.",
            mandatory = True,
        ),
        "data": attr.label_list(
            doc = "Data file (JSON, YAML, TOML, etc.) to use as template context. Currently supports only one data file.",
            allow_files = [".json", ".yaml", ".yml", ".toml", ".json5"],
            default = [],
        ),
        "substitutions": attr.string_dict(
            doc = "Dictionary of key-value pairs to substitute in the template.",
            default = {},
        ),
    },
    toolchains = ["@rules_minijinja//minijinja:toolchain_type"],
    doc = """Renders a minijinja template file with provided context data using minijinja-cli.

    This rule takes a minijinja template and renders it using context from JSON/YAML/TOML
    files and/or direct string substitutions.

    Example:
        minijinja_template(
            name = "my_config",
            template = "config.yaml.j2",
            out = "config.yaml",
            data = ["context.json"],
            substitutions = {
                "version": "1.0.0",
                "author": "John Doe",
            },
        )
    """,
)
