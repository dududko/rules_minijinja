"""Simple color palette application.

This application demonstrates using generated color types in static code.
"""
from colors import Color
from palette import Palette, PaletteType


class ColorMixer:
    """Simple color mixer using predefined colors."""

    def __init__(self):
        """Initialize the color mixer."""
        self.current_color = Color.WHITE

    def set_color(self, color: Color) -> None:
        """Set the current color."""
        self.current_color = color

    def get_color_info(self) -> dict:
        """Get information about the current color."""
        return {
            "name": self.current_color.name,
            "hex": self.current_color.to_hex(),
            "rgb": self.current_color.to_rgb(),
            "description": self.current_color.description,
        }

    def mix_rgb_average(self, color1: Color, color2: Color) -> tuple:
        """Mix two colors by averaging their RGB values."""
        rgb1 = color1.to_rgb()
        rgb2 = color2.to_rgb()
        return (
            (rgb1[0] + rgb2[0]) // 2,
            (rgb1[1] + rgb2[1]) // 2,
            (rgb1[2] + rgb2[2]) // 2,
        )


class PaletteViewer:
    """Viewer for color palettes."""

    def __init__(self, palette_type: PaletteType):
        """Initialize with a palette type."""
        self.palette = Palette(palette_type)

    def get_palette_summary(self) -> str:
        """Get a text summary of the palette."""
        lines = [
            f"Palette: {self.palette.name}",
            f"Description: {self.palette.description}",
            f"Colors ({len(self.palette.colors)}):",
        ]
        for color in self.palette.colors:
            lines.append(f"  - {color.name}: {color.to_hex()} {color.to_rgb()}")
        return "\n".join(lines)

    def get_all_hex_codes(self) -> list:
        """Get all hex codes in the palette."""
        return self.palette.get_hex_values()

    def contains_color(self, color: Color) -> bool:
        """Check if palette contains a specific color."""
        return color in self.palette.colors


def demonstrate_colors():
    """Demonstrate basic color functionality."""
    print("=== Color Demonstration ===\n")

    # Show all available colors
    print("Available colors:")
    for color in Color:
        print(f"  {color.name}: {color.to_hex()} -> {color.to_rgb()}")

    # Use the color mixer
    print("\n=== Color Mixer ===")
    mixer = ColorMixer()
    mixer.set_color(Color.RED)
    print(f"Current color: {mixer.get_color_info()}")

    # Mix two colors
    mixed = mixer.mix_rgb_average(Color.RED, Color.BLUE)
    print(f"\nMixing RED + BLUE = RGB{mixed}")

    mixed = mixer.mix_rgb_average(Color.YELLOW, Color.CYAN)
    print(f"Mixing YELLOW + CYAN = RGB{mixed}")


def demonstrate_palettes():
    """Demonstrate palette functionality."""
    print("\n\n=== Palette Demonstration ===\n")

    # Show all palettes
    for palette_type in PaletteType:
        viewer = PaletteViewer(palette_type)
        print(viewer.get_palette_summary())
        print()

    # Check if colors are in palettes
    print("=== Color Membership ===")
    primary = PaletteViewer(PaletteType.PRIMARY)
    print(f"PRIMARY contains RED: {primary.contains_color(Color.RED)}")
    print(f"PRIMARY contains YELLOW: {primary.contains_color(Color.YELLOW)}")

    secondary = PaletteViewer(PaletteType.SECONDARY)
    print(f"SECONDARY contains YELLOW: {secondary.contains_color(Color.YELLOW)}")
    print(f"SECONDARY contains RED: {secondary.contains_color(Color.RED)}")


if __name__ == "__main__":
    demonstrate_colors()
    demonstrate_palettes()
