# Changelog

All notable changes to the **ltmnight-sddm-theme** will be documented here.

## v1.2.1 - The "Polishing" Release
*Released: 2026-01-30*

This release focuses on asset optimization, branding consistency, and improved out-of-the-box reliability.

### Improved
- **Stability**: Using the static PNG as the default background for a trouble-free launch.
- **Assets**:
  - Optimized the main preview image down to **978KB**.
  - Added smooth, high-quality WebM video previews.
- **Branding**: Simplified the official badges for a cleaner, more minimal look.
- **Packaging**: Better README for the offline archive and updated the Arch Linux package.
- **Support**: Added a QR code/address for Bitcoin (BTC).

---

## v1.2.0 - The "Visual" Update
*Released: 2026-01-29*

This release introduces a stunning, fully animated shader background.

### Added
- **Animated LTMNight Shader**: A high-performance shader background created using **GLSL** and compiled with **Qt Shader Tools (`qsb`)**.
- **AUR Package**: Official `ltmnight-sddm-theme` package.
- **KDE Store**: Now available for direct installation via KDE System Settings.

### Improved
- **Installer**: Added support for selecting the new animated shader background.
- **Documentation**: Added shader preview and configuration steps.

---

## v1.1.0 - The "Polish" Update
*Released: 2026-01-27*

This release focuses on visual consistency, asset optimization, and robust scaling across all screen sizes.

### Fixed
- **Tiny Icons**: Resolved an issue where Session, Keyboard, and Layout icons were rendered too small on some screens. Fixed by explicitly removing default button padding and harmonizing icon scales to `1.125x`.
- **Virtual Keyboard**:
    - Fixed flickering issues.
    - Added dynamic "Show/Hide" icon states for better visual feedback.

### Optimized
- **SVG Standardization**: All SVG assets (`Session`, `User`, `Globe`, `Keyboard`, `Power`) have been normalized to a standard **24x24** internal grid. This ensures consistent rendering behavior and eliminates "fuzzy" scaling.
- **Asset Cleaning**: Removed unused metadata, XML headers, and dirty transforms from all icons.

### Improved
- **Installer**: `setup.sh` (formerly `install.sh`) now offers an interactive menu to choose between **Static Image** and **Live Video** backgrounds.

---

## v1.0.0 - Initial Release
*Released: 2026-01-20*

The first stable release of the LTMNight SDDM theme.

### Highlights
- Modern, premium login screen with LTMNight aesthetics.
- Dynamic hostname header that displays your machine name.
- Bold clock with glow effects and locale-aware date formatting.
- Clean top bar with virtual keyboard toggle and keyboard layout selector.
- Session selector centered at the bottom.
- Virtual keyboard with three modes: Disabled, Manual, and Touch.
- Consistent SVG iconography throughout the UI.
- Fully responsive design that scales with font size.
- Improved dropdown contrast for better readability.

### Internationalization
- Right-to-left (RTL) layout support for Arabic, Persian, and Urdu.
- Built-in translations for 15 languages.
- Auto-detects system locale for translations and date formatting.

### Technical
- **Interactive Installer**: CLI installer (`setup.sh`) with menu selection.
- One-line installation script with distro detection.
- Compatible with SDDM 0.21+ and Qt 6.10+.
- Follows Qt 6 best practices for layouts and sizing.
