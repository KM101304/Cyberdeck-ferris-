#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="$ROOT_DIR/exports/preview"
SCAD="$ROOT_DIR/scad/parts/assembly_preview.scad"

mkdir -p "$OUT_DIR"

if ! command -v openscad >/dev/null 2>&1; then
  echo "OpenSCAD is required to render previews."
  exit 1
fi

runner=(openscad)
if command -v xvfb-run >/dev/null 2>&1 && [ -z "${DISPLAY:-}" ]; then
  runner=(xvfb-run -a openscad)
fi

"${runner[@]}" -o "$OUT_DIR/fielddeck_open_iso.png" \
  --imgsize=1800,1200 \
  --camera=0,55,74,60,0,30,1050 \
  "$SCAD"

"${runner[@]}" -o "$OUT_DIR/fielddeck_keyboard_iso.png" \
  --imgsize=1800,1200 \
  --camera=0,55,74,60,0,210,1050 \
  "$SCAD"

"${runner[@]}" -o "$OUT_DIR/fielddeck_keyboard_top.png" \
  --imgsize=1800,1200 \
  --camera=0,85,190,0,0,180,950 \
  "$SCAD"

"${runner[@]}" -o "$OUT_DIR/fielddeck_open_front.png" \
  --imgsize=1800,1100 \
  --camera=0,75,70,62,0,18,1100 \
  "$SCAD"

"${runner[@]}" -o "$OUT_DIR/fielddeck_open_side.png" \
  --imgsize=1800,1000 \
  --camera=210,58,62,70,0,18,1250 \
  "$SCAD"

echo "Preview images written to $OUT_DIR"
