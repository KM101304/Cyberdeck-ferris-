# Keyboard PCB Package

This project uses the open-source Sweep v2.2 low-profile Choc PCB as the production keyboard PCB.

The upstream hardware source is vendored here:

```text
hardware/keyboard/Sweep/
```

Key files:

```text
hardware/keyboard/Sweep/Sweep v2.2/sweepv2.kicad_pcb
hardware/keyboard/Sweep/Sweep v2.2/sweepv2_plate.kicad_pcb
hardware/keyboard/Sweep/Sweep v2.2/sweepv2.2_gerber.zip
```

The Gerber ZIP is ready to upload to a PCB manufacturer. The cyberdeck shell uses its own recessed trays and mounting bosses, so the original Sweep case/plate geometry should be treated as a PCB reference rather than the final enclosure.

FieldDeck-specific wiring, placement, and mechanical integration files are in:

```text
hardware/keyboard/fielddeck_sweep_compat/
```

Use Pro Micro-footprint USB-C RP2040 controllers for the FieldDeck build. The earlier XIAO controller concept is no longer recommended because it is a poor fit for the direct-pin Sweep v2.2 architecture.
