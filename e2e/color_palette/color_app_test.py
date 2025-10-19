"""Tests for the color palette application."""
import unittest
from colors import Color
from palette import Palette, PaletteType
from color_app import ColorMixer, PaletteViewer


class TestColor(unittest.TestCase):
    """Test generated Color enum."""

    def test_color_hex_values(self):
        """Test that colors have correct hex values."""
        self.assertEqual(Color.RED.to_hex(), "#FF0000")
        self.assertEqual(Color.GREEN.to_hex(), "#00FF00")
        self.assertEqual(Color.BLUE.to_hex(), "#0000FF")
        self.assertEqual(Color.WHITE.to_hex(), "#FFFFFF")
        self.assertEqual(Color.BLACK.to_hex(), "#000000")

    def test_color_rgb_values(self):
        """Test that colors have correct RGB values."""
        self.assertEqual(Color.RED.to_rgb(), (255, 0, 0))
        self.assertEqual(Color.GREEN.to_rgb(), (0, 255, 0))
        self.assertEqual(Color.BLUE.to_rgb(), (0, 0, 255))
        self.assertEqual(Color.YELLOW.to_rgb(), (255, 255, 0))
        self.assertEqual(Color.CYAN.to_rgb(), (0, 255, 255))
        self.assertEqual(Color.MAGENTA.to_rgb(), (255, 0, 255))

    def test_color_descriptions(self):
        """Test that colors have descriptions."""
        self.assertIn("red", Color.RED.description.lower())
        self.assertIn("green", Color.GREEN.description.lower())
        self.assertIn("blue", Color.BLUE.description.lower())

    def test_all_colors_exist(self):
        """Test that all expected colors exist."""
        expected_colors = {"RED", "GREEN", "BLUE", "YELLOW", "CYAN", "MAGENTA", "WHITE", "BLACK"}
        actual_colors = {color.name for color in Color}
        self.assertEqual(expected_colors, actual_colors)


class TestPalette(unittest.TestCase):
    """Test generated Palette class."""

    def test_palette_types_exist(self):
        """Test that all palette types exist."""
        expected_palettes = {"PRIMARY", "SECONDARY", "GRAYSCALE"}
        actual_palettes = {pt.name for pt in PaletteType}
        self.assertEqual(expected_palettes, actual_palettes)

    def test_primary_palette_colors(self):
        """Test PRIMARY palette has correct colors."""
        palette = Palette(PaletteType.PRIMARY)
        colors = palette.colors
        self.assertEqual(len(colors), 3)
        self.assertIn(Color.RED, colors)
        self.assertIn(Color.GREEN, colors)
        self.assertIn(Color.BLUE, colors)

    def test_secondary_palette_colors(self):
        """Test SECONDARY palette has correct colors."""
        palette = Palette(PaletteType.SECONDARY)
        colors = palette.colors
        self.assertEqual(len(colors), 3)
        self.assertIn(Color.YELLOW, colors)
        self.assertIn(Color.CYAN, colors)
        self.assertIn(Color.MAGENTA, colors)

    def test_grayscale_palette_colors(self):
        """Test GRAYSCALE palette has correct colors."""
        palette = Palette(PaletteType.GRAYSCALE)
        colors = palette.colors
        self.assertEqual(len(colors), 2)
        self.assertIn(Color.WHITE, colors)
        self.assertIn(Color.BLACK, colors)

    def test_palette_hex_values(self):
        """Test getting hex values from palette."""
        palette = Palette(PaletteType.PRIMARY)
        hex_values = palette.get_hex_values()
        self.assertEqual(len(hex_values), 3)
        self.assertIn("#FF0000", hex_values)
        self.assertIn("#00FF00", hex_values)
        self.assertIn("#0000FF", hex_values)

    def test_palette_rgb_values(self):
        """Test getting RGB values from palette."""
        palette = Palette(PaletteType.PRIMARY)
        rgb_values = palette.get_rgb_values()
        self.assertEqual(len(rgb_values), 3)
        self.assertIn((255, 0, 0), rgb_values)
        self.assertIn((0, 255, 0), rgb_values)
        self.assertIn((0, 0, 255), rgb_values)


class TestColorMixer(unittest.TestCase):
    """Test ColorMixer application class."""

    def test_set_and_get_color(self):
        """Test setting and getting current color."""
        mixer = ColorMixer()
        mixer.set_color(Color.RED)
        info = mixer.get_color_info()
        self.assertEqual(info["name"], "RED")
        self.assertEqual(info["hex"], "#FF0000")
        self.assertEqual(info["rgb"], (255, 0, 0))

    def test_mix_colors(self):
        """Test mixing two colors."""
        mixer = ColorMixer()
        # Mix RED and BLUE -> should get purple-ish
        mixed = mixer.mix_rgb_average(Color.RED, Color.BLUE)
        self.assertEqual(mixed, (127, 0, 127))

        # Mix WHITE and BLACK -> should get gray
        mixed = mixer.mix_rgb_average(Color.WHITE, Color.BLACK)
        self.assertEqual(mixed, (127, 127, 127))

        # Mix RED and WHITE -> should get pink-ish
        mixed = mixer.mix_rgb_average(Color.RED, Color.WHITE)
        self.assertEqual(mixed, (255, 127, 127))


class TestPaletteViewer(unittest.TestCase):
    """Test PaletteViewer application class."""

    def test_palette_summary(self):
        """Test getting palette summary."""
        viewer = PaletteViewer(PaletteType.PRIMARY)
        summary = viewer.get_palette_summary()
        self.assertIn("PRIMARY", summary)
        self.assertIn("RED", summary)
        self.assertIn("GREEN", summary)
        self.assertIn("BLUE", summary)

    def test_get_hex_codes(self):
        """Test getting all hex codes."""
        viewer = PaletteViewer(PaletteType.SECONDARY)
        hex_codes = viewer.get_all_hex_codes()
        self.assertEqual(len(hex_codes), 3)
        self.assertIn("#FFFF00", hex_codes)
        self.assertIn("#00FFFF", hex_codes)
        self.assertIn("#FF00FF", hex_codes)

    def test_contains_color(self):
        """Test checking if palette contains color."""
        viewer = PaletteViewer(PaletteType.PRIMARY)
        self.assertTrue(viewer.contains_color(Color.RED))
        self.assertTrue(viewer.contains_color(Color.GREEN))
        self.assertTrue(viewer.contains_color(Color.BLUE))
        self.assertFalse(viewer.contains_color(Color.YELLOW))
        self.assertFalse(viewer.contains_color(Color.CYAN))


if __name__ == "__main__":
    unittest.main()
