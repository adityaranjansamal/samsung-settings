# Samsung Settings

A modern terminal-based utility for configuring Samsung Galaxy Book
firmware settings on Linux.

Samsung Settings provides a clean, interactive interface for managing
firmware features exposed by the **samsung-galaxybook** kernel module.
It is designed to be lightweight, POSIX-compliant, and easy to use while
maintaining a consistent user experience across all modules.

------------------------------------------------------------------------

## Features

-   Fully terminal-based interface
-   POSIX-compliant shell implementation
-   Consistent user interface across all modules
-   Color-coded status indicators
-   Nerd Font icons
-   Firmware value verification after every change
-   Safe error handling and validation
-   Verbose user feedback
-   Root privilege checks only when required

------------------------------------------------------------------------

## Modules

### 🔋 Battery

-   Display complete battery information
-   Battery health calculation
-   Battery charge limit management
-   Battery protection threshold configuration

### ⚡ Power Mode

-   Display current platform power profile
-   Change firmware power profile
-   Automatic profile verification

### 📷 Camera

-   Display camera firmware status
-   Enable camera
-   Block camera
-   Firmware verification after changes

### 💻 Lid

-   Display Power-On Lid Open status
-   Enable Power-On Lid Open
-   Disable Power-On Lid Open
-   Firmware verification after changes

------------------------------------------------------------------------

# Requirements

## Mandatory

-   Linux Only
-   POSIX-compatible shell
-   sudo
-   Nerd Font (for icons)
-   samsung-galaxybook kernel module - only for supported Galaxy Book Models. Don't install on other systems.

## Recommended

-   git

------------------------------------------------------------------------

# Installation

Clone the repository:

``` bash
git clone https://github.com/adityaranjansamal/samsung-settings.git
```

Enter the project directory:

``` bash
cd samsung-settings/bin
```

Make the scripts executable:

``` bash
chmod +x samsung-settings-linux
chmod +x modules/*.sh
```

Run Samsung Settings:

``` bash
./samsung-settings-linux
```

------------------------------------------------------------------------

# Directory Structure

``` text
bin/
├── samsung-settings-linux
├── VERSION
├── AUTHORS
├── DISCLAIMER
├── MODELS
├── README.md
└── modules
    ├── samsung_battery.sh
    ├── samsung_camera_control.sh
    ├── samsung_lid_control.sh
    └── samsung_power_mode.sh
```

------------------------------------------------------------------------

# Supported Models

Samsung Settings supports all models listed in the `MODELS` file
included in this repository.

------------------------------------------------------------------------

# Screenshots

## Main Menu

<img width="1920" height="1080" alt="main_menu" src="https://github.com/user-attachments/assets/53ef16f4-5b5f-497e-86a9-06229307bd60" />


## Battery Module

<img width="1920" height="1080" alt="battery_info" src="https://github.com/user-attachments/assets/20f15422-706e-430d-974e-0c3dd3a718c7" />


## Camera Module

<img width="1920" height="1080" alt="camera_info" src="https://github.com/user-attachments/assets/c659aa3a-6a8b-4ef9-b342-045247e54bb2" />


## Power Mode Module

<img width="1920" height="1080" alt="power_mode_info" src="https://github.com/user-attachments/assets/bcdfa4cc-a6ae-4659-8d85-19524279cd0a" />


## Lid Module

<img width="1920" height="1080" alt="lid_info" src="https://github.com/user-attachments/assets/d3dd3d0f-61bd-4609-865e-140d7d127961" />


These are the 1st pages of each module. Obiviously in the actual script there are multiple options and menus to achieve specifc task which will be shown in the complete walkthrough video.


------------------------------------------------------------------------

# Video Demonstrations

## Complete Walkthrough

*Coming soon.*

## Battery Module

*Coming soon.*

## Camera Module

*Coming soon.*

## Power Mode Module

*Coming soon.*

## Lid Module

*Coming soon.*

------------------------------------------------------------------------

# How It Works

Samsung Settings communicates directly with Linux firmware attribute
interfaces exposed by the **samsung-galaxybook** kernel module.

Every configuration change is:

1.  Validated.
2.  Applied using administrator privileges.
3.  Read back from the firmware.
4.  Verified before reporting success.

This ensures the displayed state always reflects the actual firmware
state.

------------------------------------------------------------------------

# Credits

## Developer

**Aditya Ranjan Samal**

## Kernel Module

Special thanks to **Joshua Grisham**, creator and maintainer of the
**samsung-galaxybook** kernel module, which makes these firmware
controls available.

------------------------------------------------------------------------

# Disclaimer

Samsung Settings is an independent open-source project.

It is **not affiliated with, endorsed by, sponsored by, or associated
with Samsung Electronics Co., Ltd.**

Samsung and Galaxy Book are trademarks of their respective owners.

Use this software at your own risk. While every effort has been made to
safely validate and verify firmware operations, the author is not
responsible for any data loss, hardware damage, firmware issues, or
other consequences arising from the use or misuse of this software.

------------------------------------------------------------------------

# Contributing

Bug reports, feature requests, and pull requests are welcome.

Please ensure contributions maintain:

-   POSIX shell compatibility
-   Consistent UI design
-   Proper error handling
-   Clear user feedback

------------------------------------------------------------------------

# License

This project is licensed under the MIT License.

See the `LICENSE` file for details.

------------------------------------------------------------------------

# Author

© Aditya Ranjan Samal
