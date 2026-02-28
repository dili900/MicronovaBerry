# Micronova Tasmota Scripts

Micronova pellet stove integration scripts for Tasmota (Berry).

## Repository layout

- `Micronova.be` - main stable script.
- `MicronovaGUI.be` - GUI Script.
- `EVENT_CODES.md` - event code reference used in logs.
- `index.html` - GitHub Pages landing page.

## Usage notes

- Main runtime commands include:
  - `StovePower`
  - `TargetWaterTemp`
  - `TargetAmbientTemp`
  - `TargetPower`
  - `StoveWriteEEPROM`
  - `StoveWriteRAM`
  - `StoveReadEEPROM`
  - `StoveReadRAM`
- Always validate EEPROM writes against your stove model limits.

## Safety disclaimer

Changing stove EEPROM values can affect operation and safety. Use tested values only and keep a backup of known-good settings.

