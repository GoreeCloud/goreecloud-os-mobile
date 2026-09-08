#!/usr/bin/env python3
from pathlib import Path
import sys
import cairosvg
from PIL import Image

NAMES = [
    "goreecloud_living_glaze",
    "goreecloud_graphite",
    "goreecloud_pearl",
    "goreecloud_mesh",
]


def main() -> int:
    if len(sys.argv) != 3:
        print("usage: render_wallpapers.py <svg-dir> <drawable-dir>")
        return 2
    svg_dir = Path(sys.argv[1])
    drawable_dir = Path(sys.argv[2])
    drawable_dir.mkdir(parents=True, exist_ok=True)

    for name in NAMES:
        source = svg_dir / f"{name}.svg"
        target = drawable_dir / f"{name}.png"
        thumb = drawable_dir / f"{name}_small.png"
        if not source.is_file():
            raise FileNotFoundError(source)

        cairosvg.svg2png(
            url=str(source),
            write_to=str(target),
            output_width=1440,
            output_height=3200,
        )
        with Image.open(target) as image:
            image.thumbnail((360, 800), Image.Resampling.LANCZOS)
            image.save(thumb, optimize=True)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
