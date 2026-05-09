#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PART_DIR="$ROOT_DIR/scad/parts"
OUT_DIR="$ROOT_DIR/exports/stl"

mkdir -p "$OUT_DIR"

if ! command -v openscad >/dev/null 2>&1; then
  echo "OpenSCAD is required to export STLs."
  echo "Install it, then run: scripts/export_stls.sh"
  exit 1
fi

parts=(
  lower_left
  lower_right
  lower_center_spine
  bottom_cover
  upper_lid_frame
  upper_lid_back
  lower_hinge_block_left
  lower_hinge_block_right
  upper_hinge_block_left
  upper_hinge_block_right
  tablet_bracket
  keyboard_plate_left
  keyboard_plate_right
  cable_cover_short
  cable_cover_long
  battery_strap
  fit_coupon
)

for part in "${parts[@]}"; do
  echo "Exporting ${part}.stl"
  openscad -o "$OUT_DIR/${part}.stl" "$PART_DIR/${part}.scad"
done

echo "Done. STLs are in exports/stl"
