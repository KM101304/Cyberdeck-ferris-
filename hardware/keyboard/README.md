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
