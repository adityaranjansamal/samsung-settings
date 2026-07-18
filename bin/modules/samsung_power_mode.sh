#!/bin/sh
#
# Samsung Power Mode Settings
# Author : Aditya Ranjan Samal
#

###############################################################################
# Determine Project Directory
###############################################################################

PROJECT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

###############################################################################
# Read Version
###############################################################################

if [ -r "$PROJECT_DIR/VERSION" ]; then
    VERSION=$(sed -n '1p' "$PROJECT_DIR/VERSION")
else
    VERSION="Unknown"
fi

###############################################################################
# Read Current Year
###############################################################################

YEAR=$(date '+%Y' 2>/dev/null)

if [ -z "$YEAR" ]; then
    YEAR="Unknown"
fi

###############################################################################
# Determine Terminal Width
###############################################################################

if [ -n "${COLUMNS:-}" ]; then
    WIDTH=$COLUMNS
else
    WIDTH=$(stty size 2>/dev/null | awk '{print $2}')

    if [ -z "$WIDTH" ]; then
        WIDTH=80
    fi
fi

###############################################################################
# Main Loop
###############################################################################

while :
do

    clear

    ###########################################################################
    # Header
    ###########################################################################

    i=1
    while [ "$i" -le "$WIDTH" ]
    do
        printf '═'
        i=$((i + 1))
    done
    printf '\n'

    printf '%*s\n' $(((${#VERSION} + WIDTH + 6) / 2)) "SAMSUNG SETTINGS"
    printf '%*s\n' $(((${#VERSION} + WIDTH + 8) / 2)) "Version $VERSION"

    i=1
    while [ "$i" -le "$WIDTH" ]
    do
        printf '═'
        i=$((i + 1))
    done
    printf '\n\n'

    ###########################################################################
    # Sub Header
    ###########################################################################

    printf '%*s\n' $(((${#VERSION} + WIDTH + 12) / 2)) "Power Mode Settings"
    printf '\n'

    ###########################################################################
    # Menu
    ###########################################################################

    printf '  1. 󰓅  Show Current Power Mode\n'
    printf '  2. 󱐋  Change Power Mode\n'
    printf '\n'
    printf '  0.   Exit to Main Menu\n'

    printf '\n'

    ###########################################################################
    # Footer
    ###########################################################################

    i=1
    while [ "$i" -le "$WIDTH" ]
    do
        printf '═'
        i=$((i + 1))
    done
    printf '\n'

    FOOTER="© ADITYA RANJAN SAMAL $YEAR"

    printf '%*s\n' $(((${#FOOTER} + WIDTH) / 2)) "$FOOTER"

    i=1
    while [ "$i" -le "$WIDTH" ]
    do
        printf '═'
        i=$((i + 1))
    done
    printf '\n'


    # Debug 1

    ###############################################################################
# ANSI Colors
###############################################################################

RED=$(printf '\033[31m')
GREEN=$(printf '\033[32m')
YELLOW=$(printf '\033[33m')
BLUE=$(printf '\033[34m')
GRAY=$(printf '\033[90m')
RESET=$(printf '\033[0m')

###############################################################################
# Normalize Power Profile
###############################################################################

get_power_profile()
{
    PROFILE=$(printf "%s" "$1" | tr '[:upper:]' '[:lower:]')

    case "$PROFILE" in

        #######################################################################
        # Performance Profiles
        #######################################################################

        performance|turbo|gaming|sport|high-performance|high_performance)

            MODE_ICON="󰓅"
            MODE_COLOR=$RED
            MODE_NAME="Performance"

            MODE_DESCRIPTION="Current platform profile"

            MODE_MEANING="Maximum performance with higher power consumption"

            MODE_BAR="██████████████████████████████"

            ;;

        #######################################################################
        # Balanced Profiles
        #######################################################################

        balanced|balance|balanced-performance|balanced_performance|normal|default|auto|adaptive|optimized|optimised)

            MODE_ICON="󰾅"
            MODE_COLOR=$BLUE
            MODE_NAME="Balanced"

            MODE_DESCRIPTION="Current platform profile"

            MODE_MEANING="Balanced performance and battery life"

            MODE_BAR="██████████████████████████████"

            ;;

        #######################################################################
        # Power Saving Profiles
        #######################################################################

        powersave|power-save|power_save|quiet|silent|eco|cool|battery|battery-saver|battery_saver|low-power|low_power)

            MODE_ICON="󰌪"
            MODE_COLOR=$GREEN
            MODE_NAME="Power Saving"

            MODE_DESCRIPTION="Current platform profile"

            MODE_MEANING="Reduced power consumption for longer battery life"

            MODE_BAR="██████████████████████████████"

            ;;

        #######################################################################
        # Unknown
        #######################################################################

        *)

            MODE_ICON=""
            MODE_COLOR=$GRAY
            MODE_NAME="$CURRENT_PROFILE"

            MODE_DESCRIPTION="Current platform profile"

            MODE_MEANING="Unknown or vendor-specific platform profile"

            MODE_BAR="██████████████████████████████"

            ;;

    esac
}

    ###########################################################################
    # Read User Choice
    ###########################################################################

    printf '\nSelect an option: '
    IFS= read -r CHOICE

    case "$CHOICE" in

        1)

        # Case 1 Starts Here

###############################################################################
# Locate ACPI Platform Profile
###############################################################################

PLATFORM_PROFILE="/sys/firmware/acpi/platform_profile"

if [ ! -r "$PLATFORM_PROFILE" ]; then

    clear

    printf "Error: ACPI platform profile is not supported on this system.\n"
    printf "Unable to determine the current power mode.\n"

    printf "\nPress ENTER to return..."
    IFS= read -r

    continue

fi

###############################################################################
# Read Current Platform Profile
###############################################################################

CURRENT_PROFILE=$(sed -n '1p' "$PLATFORM_PROFILE")

if [ -z "$CURRENT_PROFILE" ]; then

    clear

    printf "Unable to determine the current platform profile.\n"

    printf "\nPress ENTER to return..."
    IFS= read -r

    continue

fi

# ANSII Code and Get Power Profile () were originally here. Globally declared for resuse.

###############################################################################
# Obtain Display Information
###############################################################################

get_power_profile "$CURRENT_PROFILE"
###############################################################################
# Display Power Mode Information
###############################################################################

clear

###############################################################################
# Header
###############################################################################

i=1
while [ "$i" -le "$WIDTH" ]
do
    printf '═'
    i=$((i + 1))
done
printf '\n'

printf '%*s\n' $(((${#VERSION} + WIDTH + 6) / 2)) "SAMSUNG SETTINGS"
printf '%*s\n' $(((${#VERSION} + WIDTH + 8) / 2)) "Version $VERSION"

i=1
while [ "$i" -le "$WIDTH" ]
do
    printf '═'
    i=$((i + 1))
done
printf '\n\n'

printf '%s' "$CYAN"

printf '%*s\n' \
    $(((${#VERSION} + WIDTH + 10) / 2)) \
    "Current Power Mode"

printf '%s\n\n' "$RESET"

###############################################################################
# Power Mode Table
###############################################################################

printf "┌──────────────────────┬────────────────────┬──────────────────────────────────────┬────────────────────────────────────────────┐\n"

printf "│ Label                │ Value              │ Description                          │ Meaning                                    │\n"

printf "├──────────────────────┼────────────────────┼──────────────────────────────────────┼────────────────────────────────────────────┤\n"

printf "│ %s%-2s%s Power Mode      │ %s%-18s%s │ %-36s │ %-42s │\n" \
    "$MODE_COLOR" \
    "$MODE_ICON" \
    "$RESET" \
    "$MODE_COLOR" \
    "$MODE_NAME" \
    "$RESET" \
    "$MODE_DESCRIPTION" \
    "$MODE_MEANING"

printf "└──────────────────────┴────────────────────┴──────────────────────────────────────┴────────────────────────────────────────────┘\n"

printf "\n"

###############################################################################
# Visual Representation
###############################################################################

printf "%sPower Profile Visualization%s\n\n" \
    "$CYAN" \
    "$RESET"

printf "%s%s %s %s%s\n\n" \
    "$MODE_COLOR" \
    "$MODE_ICON" \
    "$MODE_BAR" \
    "$MODE_NAME" \
    "$RESET"

###############################################################################
# Raw ACPI Value
###############################################################################

printf "┌──────────────────────┬────────────────────┬──────────────────────────────────────┬────────────────────────────────────────────┐\n"

printf "│ Label                │ Value              │ Description                          │ Meaning                                    │\n"

printf "├──────────────────────┼────────────────────┼──────────────────────────────────────┼────────────────────────────────────────────┤\n"

printf "│  ACPI Profile       │ %-18s │ Raw kernel platform profile          │ Value reported by ACPI firmware            │\n" \
    "$CURRENT_PROFILE"

printf "└──────────────────────┴────────────────────┴──────────────────────────────────────┴────────────────────────────────────────────┘\n"

printf "\nPress ENTER to return..."

IFS= read -r

continue
;;
# Case 1 ends here

        2)

        # Case 2 starts here

###############################################################################
# Locate ACPI Platform Profile
###############################################################################

PROFILE_FILE="/sys/firmware/acpi/platform_profile"
CHOICES_FILE="/sys/firmware/acpi/platform_profile_choices"

if [ ! -r "$PROFILE_FILE" ]; then

    clear

    printf "Error: platform_profile is unavailable.\n"

    printf "\nPress ENTER to return..."
    IFS= read -r

    continue

fi

if [ ! -r "$CHOICES_FILE" ]; then

    clear

    printf "Error: platform_profile_choices is unavailable.\n"

    printf "\nPress ENTER to return..."
    IFS= read -r

    continue

fi

###############################################################################
# Read Current Profile
###############################################################################

CURRENT_PROFILE=$(sed -n '1p' "$PROFILE_FILE")




###############################################################################
# Read Supported Profiles
###############################################################################

PROFILE_CHOICES=$(sed -n '1p' "$CHOICES_FILE")

if [ -z "$PROFILE_CHOICES" ]; then

    clear

    printf "No power modes were reported by the firmware.\n"

    printf "\nPress ENTER to return..."
    IFS= read -r

    continue

fi

###############################################################################
# Selection Loop
###############################################################################

while :
do

    clear

    ###########################################################################
    # Header
    ###########################################################################

    i=1
    while [ "$i" -le "$WIDTH" ]
    do
        printf '═'
        i=$((i + 1))
    done
    printf '\n'

    printf '%*s\n' $(((${#VERSION} + WIDTH + 6) / 2)) "SAMSUNG SETTINGS"
    printf '%*s\n' $(((${#VERSION} + WIDTH + 8) / 2)) "Version $VERSION"

    i=1
    while [ "$i" -le "$WIDTH" ]
    do
        printf '═'
        i=$((i + 1))
    done
    printf '\n\n'

    printf "%s" "$CYAN"

    printf '%*s\n' \
        $(((${#VERSION} + WIDTH + 10) / 2)) \
        "Change Power Mode"

    printf "%s\n\n" "$RESET"

    ###########################################################################
    # Current Mode
    ###########################################################################

    get_power_profile "$CURRENT_PROFILE"

    printf "Current Power Mode\n\n"

    printf "%s%s %s %s%s\n\n" \
        "$MODE_COLOR" \
        "$MODE_ICON" \
        "$MODE_BAR" \
        "$MODE_NAME" \
        "$RESET"

    ###########################################################################
    # Dynamic Menu
    ###########################################################################

    printf "┌────────┬────────────────────┬──────────────────────────────────────┐\n"
    printf "│ Option │ Power Mode         │ Description                          │\n"
    printf "├────────┼────────────────────┼──────────────────────────────────────┤\n"

    OPTION=1

    for PROFILE in $PROFILE_CHOICES
    do

        get_power_profile "$PROFILE"

        printf "│ %-6s │ %s%-2s %-13s%s │ %-36s │\n" \
            "$OPTION" \
            "$MODE_COLOR" \
            "$MODE_ICON" \
            "$MODE_NAME" \
            "$RESET" \
            "$MODE_MEANING"

        eval PROFILE_$OPTION=\"\$PROFILE\"

        OPTION=$((OPTION + 1))

    done

    printf "└────────┴────────────────────┴──────────────────────────────────────┘\n"

    printf "\n"

    printf "0. Return to Power Mode Menu\n"

    printf "\nSelect an option: "

    IFS= read -r CHOICE

    if [ "$CHOICE" = "0" ]; then

        continue 2

    fi

    NEW_PROFILE=$(eval printf '%s' \"\$PROFILE_$CHOICE\")

    if [ -z "$NEW_PROFILE" ]; then

        printf "\nInvalid option."

        printf "\n\nPress ENTER to try again..."

        IFS= read -r

        continue

    fi

    break

done
###############################################################################
# No Change Required
###############################################################################

if [ "$CURRENT_PROFILE" = "$NEW_PROFILE" ]; then

    clear

    get_power_profile "$CURRENT_PROFILE"

    printf "The system is already using:\n\n"

    printf "%s%s %s%s\n\n" \
        "$MODE_COLOR" \
        "$MODE_ICON" \
        "$MODE_NAME" \
        "$RESET"

    printf "No changes were made.\n"

    printf "\nPress ENTER to return to the Power Mode Menu..."
    IFS= read -r

    continue

fi

###############################################################################
# Request Administrator Privileges
###############################################################################

clear

get_power_profile "$CURRENT_PROFILE"
OLD_ICON="$MODE_ICON"
OLD_COLOR="$MODE_COLOR"
OLD_NAME="$MODE_NAME"

get_power_profile "$NEW_PROFILE"

printf "Current Power Mode\n\n"

printf "%s%s %s%s\n\n" \
    "$OLD_COLOR" \
    "$OLD_ICON" \
    "$OLD_NAME" \
    "$RESET"

printf "New Power Mode\n\n"

printf "%s%s %s%s\n\n" \
    "$MODE_COLOR" \
    "$MODE_ICON" \
    "$MODE_NAME" \
    "$RESET"

printf "Administrator (root/sudo) privileges are required.\n\n"

###############################################################################
# Apply New Power Mode
###############################################################################

if printf "%s" "$NEW_PROFILE" |
    sudo tee "$PROFILE_FILE" >/dev/null
then

    :

else

    printf "\nAuthentication failed or write operation failed.\n"

    printf "\nAdministrator (root/sudo) privileges are required."

    printf "\n\nPress ENTER to return..."
    IFS= read -r

    continue

fi

###############################################################################
# Verify
###############################################################################

VERIFY_PROFILE=$(sed -n '1p' "$PROFILE_FILE")

if [ "$VERIFY_PROFILE" != "$NEW_PROFILE" ]; then

    printf "\nVerification failed.\n"

    printf "Expected : %s\n" "$NEW_PROFILE"
    printf "Read Back: %s\n" "$VERIFY_PROFILE"

    printf "\nPress ENTER to return..."
    IFS= read -r

    continue

fi

###############################################################################
# Success Screen
###############################################################################

clear

get_power_profile "$CURRENT_PROFILE"

OLD_ICON="$MODE_ICON"
OLD_COLOR="$MODE_COLOR"
OLD_NAME="$MODE_NAME"

get_power_profile "$NEW_PROFILE"

NEW_ICON="$MODE_ICON"
NEW_COLOR="$MODE_COLOR"
NEW_NAME="$MODE_NAME"

i=1
while [ "$i" -le "$WIDTH" ]
do
    printf '═'
    i=$((i + 1))
done
printf '\n'

printf '%*s\n' $(((${#VERSION} + WIDTH + 6) / 2)) "SAMSUNG SETTINGS"
printf '%*s\n' $(((${#VERSION} + WIDTH + 8) / 2)) "Version $VERSION"

i=1
while [ "$i" -le "$WIDTH" ]
do
    printf '═'
    i=$((i + 1))
done
printf '\n\n'

printf "%s" "$CYAN"

printf '%*s\n' \
    $(((${#VERSION} + WIDTH + 23) / 2)) \
    "Power Mode Updated"

printf "%s\n\n" "$RESET"

printf "┌──────────────────────┬────────────────────┬──────────────────────────────────────┬────────────────────────────────────────────┐\n"

printf "│ Label                │ Value              │ Description                          │ Meaning                                    │\n"

printf "├──────────────────────┼────────────────────┼──────────────────────────────────────┼────────────────────────────────────────────┤\n"

printf "│  Status             │ Success            │ Operation Result                     │ Power mode updated successfully            │\n"

printf "│ %s%-2s%s Previous Mode    │ %-18s │ Previous power profile              │ Previously active mode                     │\n" \
    "$OLD_COLOR" "$OLD_ICON" "$RESET" "$OLD_NAME"

printf "│ %s%-2s%s Current Mode     │ %-18s │ Active power profile                │ Newly selected mode                        │\n" \
    "$NEW_COLOR" "$NEW_ICON" "$RESET" "$NEW_NAME"

printf "│  Verification       │ Successful         │ Read-back verification               │ New value confirmed                        │\n"

printf "└──────────────────────┴────────────────────┴──────────────────────────────────────┴────────────────────────────────────────────┘\n"

printf "\n"

###############################################################################
# Reboot Prompt
###############################################################################

while :
do

    printf "A system reboot is recommended for the new power mode\n"
    printf "to be fully applied.\n\n"

    printf "Would you like to reboot now? (Y/N): "

    IFS= read -r REBOOT

    case "$REBOOT" in

        [Yy])

            printf "\nRebooting system...\n"

            if sudo reboot
            then
                exit 0
            else

                printf "\nUnable to reboot the system."

                printf "\n\nPress ENTER to return..."
                IFS= read -r

                continue 2

            fi

            ;;

        [Nn]|"")

            printf "\nPlease remember to reboot your system later."

            printf "\nThe selected power mode may not be fully applied until then."

            printf "\n\nPress ENTER to return..."
            IFS= read -r

            continue 2

            ;;

        *)

            printf "\nInvalid option."

            printf "\nPlease enter Y or N.\n\n"

            ;;

    esac

done
;;
# End of Case 2

        0)
            exit 0
            ;;

        *)
            clear
            printf "Invalid menu selection.\n"
            printf "\nPress ENTER to return..."
            IFS= read -r
            ;;

    esac

done