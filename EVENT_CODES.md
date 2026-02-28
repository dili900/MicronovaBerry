# Event Codes Reference

This file documents BRY event codes used by the Micronova scripts.

## Micronova.be

- C001: Cache update ignored, read frame with invalid RAM address
- C002: Cache update ignored, read frame with invalid EEPROM address
- C003: Cache update ignored, write frame with invalid RAM address
- C004: Cache update ignored, write frame with invalid EEPROM address
- T001: Communication timeout, request flag reset after retry threshold
- V001: Validation failed for power range
- V002: Validation failed for water temperature range
- V003: Validation failed for ambient temperature range
- L001: Command skipped, power already at upper limit
- L002: Command skipped, power already at lower limit
- L003: Command skipped, water temperature already at upper limit
- L004: Command skipped, water temperature already at lower limit
- L005: Command skipped, ambient temperature already at upper limit
- L006: Command skipped, ambient temperature already at lower limit
- L007: Command skipped, power ON requested while stove is already ON
- L008: Command skipped, power OFF requested while stove is already OFF

## MicronovaGUI.be

- G001: Invalid time input parsing/conversion
- G002: Exception in Stove timer control handler
- G003: Exception in Stove settings control handler

## Notes

- Log format is standardized as:
  - BRY: evt=<CODE> <message>
- Latest baseline files are intentionally not modified.