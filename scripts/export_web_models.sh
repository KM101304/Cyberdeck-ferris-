#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PART_DIR="$ROOT_DIR/scad/parts"
OUT_DIR="$ROOT_DIR/docs/assets/models"

mkdir -p "$OUT_DIR"

if ! command -v openscad >/dev/null 2>&1; then
  echo "OpenSCAD is required to export web models."
  exit 1
fi

parts=(
  web_shell:fielddeck_shell
  web_tablet:fielddeck_tablet
  web_keycaps:fielddeck_keycaps
  web_components:fielddeck_components
)

for item in "${parts[@]}"; do
  src="${item%%:*}"
  out="${item##*:}"
  echo "Exporting ${out}.stl"
  openscad -o "$OUT_DIR/${out}.stl" "$PART_DIR/${src}.scad"
done

echo "Web model STLs are in docs/assets/models"
