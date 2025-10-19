# Color Palette Example

A simple example demonstrating minijinja template-based code generation for Python with static code using generated types.

## Overview

This example generates Python color enums and palette classes from YAML specifications, then uses them in static application code.

## Structure

### Generated Code (from YAML)

1. **colors.py** - Color enumeration
   - Generated from [colors_spec.yaml](colors_spec.yaml) using [colors_enum.py.j2](colors_enum.py.j2)
   - Contains 8 colors: RED, GREEN, BLUE, YELLOW, CYAN, MAGENTA, WHITE, BLACK
   - Each color has hex code, RGB values, and description
   - Methods: `to_hex()`, `to_rgb()`, `description` property

2. **palette.py** - Palette class
   - Generated from [palette_spec.yaml](palette_spec.yaml) using [palette_class.py.j2](palette_class.py.j2)
   - Contains 3 palette types: PRIMARY, SECONDARY, GRAYSCALE
   - Each palette groups related colors
   - Methods: `get_hex_values()`, `get_rgb_values()`, color access

### Static Code (uses generated types)

3. **color_app.py** - Application code
   - `ColorMixer` class: Color manipulation and mixing
   - `PaletteViewer` class: Palette inspection and queries
   - Demo functions showing usage

4. **color_app_test.py** - Tests
   - Tests for generated Color enum
   - Tests for generated Palette class
   - Tests for static application classes

## Usage

### Run the demo application
```bash
bazel run //examples/color_palette:color_app_demo
```

### Run the tests
```bash
bazel test //examples/color_palette:color_app_test
```

### View generated code
```bash
# After building, generated files are available at:
cat bazel-bin/examples/color_palette/colors.py
cat bazel-bin/examples/color_palette/palette.py
```

## How It Works

1. **Template rendering**: minijinja templates read YAML specs and generate Python code
2. **Type generation**: Creates strongly-typed Color enum and Palette class
3. **Static code**: Application code imports and uses the generated types
4. **Testing**: Tests verify both generated and static code work correctly

## Key Features

- Simple color definitions in YAML
- Type-safe color enums with metadata
- Palette grouping system
- Color mixing utilities
- Comprehensive test coverage
- No manual code generation required
