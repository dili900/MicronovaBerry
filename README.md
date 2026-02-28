# Micronova Tasmota Scripts

Micronova pellet stove integration scripts for Tasmota (Berry).

## Repository layout

- `Micronova.be` - main stable script.
- `MicronovaLatest.be` - latest script version.
- `MicronovaGUI.be` / `MicronovaGUILatest.be` - GUI variants.
- `EVENT_CODES.md` - event code reference used in logs.
- `WebUI.tas` - optional web UI script assets.
- `index.html` - GitHub Pages landing page.

## Publish on GitHub Pages

1. Push this folder as a GitHub repository.
2. In GitHub, open **Settings > Pages**.
3. Under **Build and deployment**, set:
   - **Source**: Deploy from a branch
   - **Branch**: `main`
   - **Folder**: `/ (root)`
4. Save and wait for deployment.
5. Your site URL will be shown in the Pages settings.

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
