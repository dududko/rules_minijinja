# Bazel rules for minijinja

Bazel rules for rendering [minijinja](https://github.com/mitsuhiko/minijinja) templates. Minijinja is a powerful and minimal template engine for Rust, compatible with Jinja2 syntax.

## Installation

### Using Bzlmod (Bazel 6+)

Add to your `MODULE.bazel`:

```starlark
bazel_dep(name = "rules_minijinja", version = "<version>")
```

To use a commit rather than a release, you can use archive_override:

```starlark
bazel_dep(name = "rules_minijinja", version = "")

archive_override(
    module_name = "rules_minijinja",
    urls = "https://github.com/dududko/rules_minijinja/archive/<commit>.tar.gz",
    strip_prefix = "rules_minijinja-<commit>",
    # integrity = "sha256-...",  # optional
)
```

### Using WORKSPACE

Workspace mode is not supported.

> See the [release notes](https://github.com/dududko/rules_minijinja/releases) for version-specific installation instructions and sha256 checksums.

## Usage

### Basic Example

```starlark
load("@rules_minijinja//minijinja:defs.bzl", "minijinja_template")

minijinja_template(
    name = "greeting",
    template = "greeting.txt.j2",
    out = "greeting.txt",
    substitutions = {
        "name": "World",
        "language": "English",
    },
)
```

### With Data Files

```starlark
minijinja_template(
    name = "config",
    template = "config.yaml.j2",
    out = "config.yaml",
    data = ["context.json"],
    substitutions = {
        "version": "1.0.0",
    },
)
```

### Advanced: Code Generation

See the [color palette example](e2e/color_palette) for a complete demonstration of using minijinja templates to generate Python code from YAML specifications.

## Documentation

- [Examples](minijinja/examples/) - Usage examples
- [E2E Tests](e2e/) - End-to-end test cases demonstrating various use cases

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.
