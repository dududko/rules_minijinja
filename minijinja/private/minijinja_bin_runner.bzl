"""Executable rule to run minijinja-cli from the toolchain."""

def _minijinja_bin_runner_impl(ctx):
    """Implementation that exposes the minijinja-cli binary as executable.

    Args:
        ctx: Rule context.

    Returns:
        DefaultInfo provider with the executable binary.
    """
    toolchain = ctx.toolchains["//minijinja:toolchain_type"]
    minijinja_info = toolchain.minijinjainfo

    # Create a wrapper script that executes the toolchain binary
    # This is required because executable rules must create their own executable
    is_windows = ctx.target_platform_has_constraint(ctx.attr._windows_constraint[platform_common.ConstraintValueInfo])

    if is_windows:
        wrapper = ctx.actions.declare_file(ctx.label.name + ".bat")
        ctx.actions.write(
            output = wrapper,
            content = """@echo off
{binary} %*
""".format(binary = minijinja_info.executable.short_path),
            is_executable = True,
        )
    else:
        wrapper = ctx.actions.declare_file(ctx.label.name + ".sh")
        ctx.actions.write(
            output = wrapper,
            content = """#!/usr/bin/env bash
exec "{binary}" "$@"
""".format(binary = minijinja_info.executable.short_path),
            is_executable = True,
        )

    return [
        DefaultInfo(
            executable = wrapper,
            runfiles = ctx.runfiles(files = minijinja_info.tool_files + [wrapper]),
        ),
    ]

minijinja_bin_runner = rule(
    implementation = _minijinja_bin_runner_impl,
    executable = True,
    toolchains = ["//minijinja:toolchain_type"],
    attrs = {
        "_windows_constraint": attr.label(default = "@platforms//os:windows"),
    },
    doc = """Exposes the minijinja-cli binary from the toolchain as an executable target.

    This allows users to run minijinja-cli directly:
        bazel run @rules_minijinja//minijinja -- --print-config
        bazel run @rules_minijinja//minijinja -- template.j2 -D name=World

    Similar to @io_bazel_rules_go//go.
    """,
)
