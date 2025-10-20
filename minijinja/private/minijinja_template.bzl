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

    # Build the command arguments using ctx.actions.args()
    # This is more efficient and handles quoting/paths automatically
    args = ctx.actions.args()

    # Add whitespace control flags to match jinja2 behavior
    args.add("--trim-blocks")
    args.add("--lstrip-blocks")

    # Add output file flag (minijinja-cli supports -o/--output)
    args.add("--output", output)

    # Add template file
    args.add(template)

    # Add data file if provided (minijinja-cli takes data file as second positional arg)
    if data_files:
        if len(data_files) > 1:
            fail("minijinja-cli currently supports only one data file. Use substitutions for additional values or merge your data files.")
        args.add(data_files[0])

    # Add substitutions as -D key=value pairs
    for key, value in ctx.attr.substitutions.items():
        args.add("-D")
        args.add("{}={}".format(key, value))

    # Create list of all input files
    inputs = [template] + data_files + minijinja_info.tool_files

    # Run minijinja-cli directly using ctx.actions.run
    # This is preferred over run_shell as it's more efficient and portable
    ctx.actions.run(
        inputs = inputs,
        outputs = [output],
        executable = minijinja_info.executable,
        arguments = [args],
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
