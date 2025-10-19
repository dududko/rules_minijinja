"""Public API for rules_minijinja.

This module exports all public rules and functions for generating code
from minijinja templates.
"""

load("//minijinja/private:minijinja_template.bzl", _minijinja_template = "minijinja_template")

# Export the public API
minijinja_template = _minijinja_template
