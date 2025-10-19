<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Public API for rules_minijinja.

This module exports all public rules and functions for generating code
from minijinja templates.


<a id="minijinja_template"></a>

## minijinja_template

<pre>
minijinja_template(<a href="#minijinja_template-name">name</a>, <a href="#minijinja_template-data">data</a>, <a href="#minijinja_template-out">out</a>, <a href="#minijinja_template-substitutions">substitutions</a>, <a href="#minijinja_template-template">template</a>)
</pre>

Renders a minijinja template file with provided context data using minijinja-cli.

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
    

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="minijinja_template-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="minijinja_template-data"></a>data |  Data file (JSON, YAML, TOML, etc.) to use as template context. Currently supports only one data file.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional | <code>[]</code> |
| <a id="minijinja_template-out"></a>out |  The output file to generate.   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |
| <a id="minijinja_template-substitutions"></a>substitutions |  Dictionary of key-value pairs to substitute in the template.   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional | <code>{}</code> |
| <a id="minijinja_template-template"></a>template |  The minijinja template file to render.   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |


