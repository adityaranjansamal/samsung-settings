#!/bin/sh
#
# Samsung Camera Settings
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

    printf '%*s\n' $(((${#VERSION} + WIDTH + 10) / 2)) "Camera Settings"
    printf '\n'

    ###########################################################################
    # Menu
    ###########################################################################

    printf "  1. 󰄀  Show Camera Status\n"
    printf "  2. 󰄁  Change Camera Status\n"
    printf "\n"
    printf "  0.   Exit to Main Menu\n"

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


    # GLOBAL DECLARATION
    # Debug 1
    ###############################################################################
    # ANSI Colours
    ###############################################################################

    RED=$(printf '\033[31m')
    GREEN=$(printf '\033[32m')
    GRAY=$(printf '\033[90m')
    CYAN=$(printf '\033[36m')
    RESET=$(printf '\033[0m')

    ###########################################################################
    # Read User Choice
    ###########################################################################

    printf '\nSelect an option: '
    IFS= read -r CHOICE

    case "$CHOICE" in

        1)

        # Case 1 starts here

###############################################################################
# Camera Firmware Attribute Directory
###############################################################################

CAMERA_DIR="/sys/class/firmware-attributes/samsung-galaxybook/attributes/block_recording"

if [ ! -d "$CAMERA_DIR" ]; then

    clear

    printf "Error: Samsung camera firmware attribute directory was not found.\n"

    printf "\nPress ENTER to return..."
    IFS= read -r

    continue

fi

###############################################################################
# Read Helper
###############################################################################

read_attribute()
{
    FILE="$1"

    if [ -r "$CAMERA_DIR/$FILE" ]; then
        sed -n '1p' "$CAMERA_DIR/$FILE"
    else
        printf "N/A"
    fi
}

###############################################################################
# Read Firmware Attributes
###############################################################################

CURRENT_VALUE=$(read_attribute current_value)
DEFAULT_VALUE=$(read_attribute default_value)
DISPLAY_NAME=$(read_attribute display_name)
DISPLAY_LANGUAGE=$(read_attribute display_name_language_code)
POSSIBLE_VALUES=$(read_attribute possible_values)
ATTRIBUTE_TYPE=$(read_attribute type)

# ANSII COLORS WERE PREVIOUSLY DECLARED HERE. NOW GLOBALLY DECLARED FOR REUSABILITY

###############################################################################
# Camera Status Mapping
###############################################################################

case "$CURRENT_VALUE" in

    ###########################################################################
    # Camera Allowed
    ###########################################################################

    0|allowed|enable|enabled|on|true)

        CAMERA_ICON="󰄀"
        CAMERA_COLOUR=$GREEN
        CAMERA_STATUS="Allowed"

        CAMERA_DESCRIPTION="Current camera access state"

        CAMERA_MEANING="Camera is available to applications"

        CAMERA_BAR="██████████████████████████████"

        ;;

    ###########################################################################
    # Camera Blocked
    ###########################################################################

    1|blocked|disable|disabled|off|false)

        CAMERA_ICON="󰄁"
        CAMERA_COLOUR=$RED
        CAMERA_STATUS="Blocked"

        CAMERA_DESCRIPTION="Current camera access state"

        CAMERA_MEANING="Camera access is blocked by firmware"

        CAMERA_BAR="░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"

        ;;

    ###########################################################################
    # Unknown
    ###########################################################################

    *)

        CAMERA_ICON=""
        CAMERA_COLOUR=$GRAY
        CAMERA_STATUS="Unknown"

        CAMERA_DESCRIPTION="Current camera access state"

        CAMERA_MEANING="Firmware returned an unknown value"

        CAMERA_BAR="??????????????????????????????"

        ;;

esac
###############################################################################
# Display Camera Information
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

printf "%s" "$CYAN"

printf '%*s\n' \
    $(((${#VERSION} + WIDTH + 12) / 2)) \
    "Current Camera Status"

printf "%s\n\n" "$RESET"

###############################################################################
# Current Camera Status
###############################################################################

printf "┌──────────────────────┬────────────────────┬──────────────────────────────────────┬────────────────────────────────────────────┐\n"

printf "│ Label                │ Value              │ Description                          │ Meaning                                    │\n"

printf "├──────────────────────┼────────────────────┼──────────────────────────────────────┼────────────────────────────────────────────┤\n"

printf "│ %s%-2s%s Camera Status   │ %s%-18s%s │ %-36s │ %-42s │\n" \
    "$CAMERA_COLOR" \
    "$CAMERA_ICON" \
    "$RESET" \
    "$CAMERA_COLOR" \
    "$CAMERA_STATUS" \
    "$RESET" \
    "$CAMERA_DESCRIPTION" \
    "$CAMERA_MEANING"

printf "└──────────────────────┴────────────────────┴──────────────────────────────────────┴────────────────────────────────────────────┘\n"

printf "\n"

###############################################################################
# Camera Status Visualization
###############################################################################

printf "%sCamera Status Visualization%s\n\n" \
    "$CYAN" \
    "$RESET"

printf "%s%s %s %s%s\n\n" \
    "$CAMERA_COLOR" \
    "$CAMERA_ICON" \
    "$CAMERA_BAR" \
    "$CAMERA_STATUS" \
    "$RESET"

###############################################################################
# Camera Attribute Information
###############################################################################

printf "┌──────────────────────┬────────────────────┬──────────────────────────────────────┬────────────────────────────────────────────┐\n"

printf "│ Label                │ Value              │ Description                          │ Meaning                                    │\n"

printf "├──────────────────────┼────────────────────┼──────────────────────────────────────┼────────────────────────────────────────────┤\n"

printf "│ 󰄀 Current Value      │ %-18s │ Current firmware value              │ 0=Allowed, 1=Blocked                       │\n" \
    "$CURRENT_VALUE"

printf "│ 󰘳 Default Value      │ %-18s │ Factory default value               │ Default firmware configuration             │\n" \
    "$DEFAULT_VALUE"

printf "│ 󰈙 Display Name       │ %-18s │ Firmware attribute name             │ Human-readable attribute                   │\n" \
    "$DISPLAY_NAME"

printf "│ 󰗊 Language Code      │ %-18s │ Display language                    │ Attribute localization language            │\n" \
    "$DISPLAY_LANGUAGE"

printf "│ 󰈔 Possible Values    │ %-18s │ Supported values                    │ Accepted firmware values                   │\n" \
    "$POSSIBLE_VALUES"

printf "│ 󰒓 Attribute Type     │ %-18s │ Firmware attribute type             │ Attribute data representation              │\n" \
    "$ATTRIBUTE_TYPE"

printf "└──────────────────────┴────────────────────┴──────────────────────────────────────┴────────────────────────────────────────────┘\n"

printf "\nPress ENTER to return..."

IFS= read -r

continue
;;
# Case 1 ends here

       2)

       # Case 2 starts here

###############################################################################
# Camera Firmware Attribute
###############################################################################

CAMERA_DIR="/sys/class/firmware-attributes/samsung-galaxybook/attributes/block_recording"

CURRENT_FILE="$CAMERA_DIR/current_value"
POSSIBLE_FILE="$CAMERA_DIR/possible_values"

###############################################################################
# Verify Files
###############################################################################

if [ ! -r "$CURRENT_FILE" ]; then

    clear

    printf "Error: Unable to read the current camera status.\n"

    printf "\nPress ENTER to return..."
    IFS= read -r

    continue

fi

if [ ! -r "$POSSIBLE_FILE" ]; then

    clear

    printf "Error: Unable to determine the supported camera operations.\n"

    printf "\nPress ENTER to return..."
    IFS= read -r

    continue

fi

###############################################################################
# Read Current Status
###############################################################################

CURRENT_VALUE=$(sed -n '1p' "$CURRENT_FILE")

###############################################################################
# Validate Firmware Supports Camera Control
###############################################################################

# SUPPORTED_VALUES=$(tr ',\t' '  ' < "$POSSIBLE_FILE") originally written bug 1
SUPPORTED_VALUES=$(tr ';' ' ' < "$POSSIBLE_FILE")

ALLOW_SUPPORTED=0
BLOCK_SUPPORTED=0

for VALUE in $SUPPORTED_VALUES
do

    case "$VALUE" in

        0)

            ALLOW_SUPPORTED=1

            ;;

        1)

            BLOCK_SUPPORTED=1

            ;;

    esac

done

if [ "$ALLOW_SUPPORTED" -eq 0 ] && [ "$BLOCK_SUPPORTED" -eq 0 ]; then

    clear

    printf "This firmware does not expose supported camera operations.\n"

    printf "\nPress ENTER to return..."

    IFS= read -r

    continue

fi

###############################################################################
# Current Camera Status
###############################################################################

case "$CURRENT_VALUE" in

    0)

        STATUS_NAME="Camera Allowed"
        STATUS_ICON="󰄀"
        STATUS_COLOR=$GREEN
        STATUS_BAR="██████████████████████████████"

        ;;

    1)

        STATUS_NAME="Camera Blocked"
        STATUS_ICON="󰄁"
        STATUS_COLOR=$RED
        STATUS_BAR="██████████████████████████████"

        ;;

    *)

        STATUS_NAME="Unknown"
        STATUS_ICON=""
        STATUS_COLOR=$GRAY
        STATUS_BAR="??????????????????????????????"

        ;;

esac

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
        "Change Camera Status"

    printf "%s\n\n" "$RESET"

    ###########################################################################
    # Current Status
    ###########################################################################

    printf "Current Camera Status\n\n"

    printf "%s%s %s %s%s\n\n" \
        "$STATUS_COLOR" \
        "$STATUS_ICON" \
        "$STATUS_BAR" \
        "$STATUS_NAME" \
        "$RESET"

    ###########################################################################
    # Menu
    ###########################################################################

    printf "┌────────┬──────────────────────────────┬────────────────────────────────────────────┐\n"
    printf "│ Option │ Action                       │ Result                                     │\n"
    printf "├────────┼──────────────────────────────┼────────────────────────────────────────────┤\n"

    printf "│ 1      │ Allow Camera                 │ Sets current_value to 0                    │\n"
    printf "│ 2      │ Block Camera                 │ Sets current_value to 1                    │\n"

    printf "└────────┴──────────────────────────────┴────────────────────────────────────────────┘\n"

    printf "\n"

    printf "0. Return to Camera Menu\n"

    printf "\nSelect an option: "

    IFS= read -r CHOICE

    case "$CHOICE" in

        0)

            continue 2

            ;;

        1)

            NEW_VALUE=0

            break

            ;;

        2)

            NEW_VALUE=1

            break

            ;;

        *)

            printf "\nInvalid option."

            printf "\n\nPress ENTER to try again..."

            IFS= read -r

            ;;

    esac

done
###############################################################################
# Previous / Requested Status
###############################################################################

case "$CURRENT_VALUE" in

    0)
        OLD_STATUS="Camera Allowed"
        OLD_ICON="󰄀"
        OLD_COLOR=$GREEN
        ;;

    1)
        OLD_STATUS="Camera Blocked"
        OLD_ICON="󰄁"
        OLD_COLOR=$RED
        ;;

    *)
        OLD_STATUS="Unknown"
        OLD_ICON=""
        OLD_COLOR=$GRAY
        ;;

esac

case "$NEW_VALUE" in

    0)
        NEW_STATUS="Camera Allowed"
        NEW_ICON="󰄀"
        NEW_COLOR=$GREEN
        ;;

    1)
        NEW_STATUS="Camera Blocked"
        NEW_ICON="󰄁"
        NEW_COLOR=$RED
        ;;

    *)
        NEW_STATUS="Unknown"
        NEW_ICON=""
        NEW_COLOR=$GRAY
        ;;

esac

###############################################################################
# No Change Required
###############################################################################

if [ "$CURRENT_VALUE" = "$NEW_VALUE" ]; then

    clear

    printf "Camera status is already set to:\n\n"

    printf "%s%s %s%s\n\n" \
        "$OLD_COLOR" \
        "$OLD_ICON" \
        "$OLD_STATUS" \
        "$RESET"

    printf "No changes were made.\n"

    printf "\nPress ENTER to return to the Camera Menu..."

    IFS= read -r

    continue

fi

###############################################################################
# Administrator Privileges Required
###############################################################################

clear

printf "Current Camera Status\n\n"

printf "%s%s %s%s\n\n" \
    "$OLD_COLOR" \
    "$OLD_ICON" \
    "$OLD_STATUS" \
    "$RESET"

printf "Requested Camera Status\n\n"

printf "%s%s %s%s\n\n" \
    "$NEW_COLOR" \
    "$NEW_ICON" \
    "$NEW_STATUS" \
    "$RESET"

printf "Administrator (root/sudo) privileges are required.\n\n"

###############################################################################
# Apply New Camera Status
###############################################################################

if printf "%s" "$NEW_VALUE" |
    sudo tee "$CURRENT_FILE" >/dev/null
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
# Verification
###############################################################################

VERIFY_VALUE=$(sed -n '1p' "$CURRENT_FILE")

if [ "$VERIFY_VALUE" != "$NEW_VALUE" ]; then

    printf "\nVerification failed.\n"

    printf "Expected : %s\n" "$NEW_VALUE"
    printf "Read Back: %s\n" "$VERIFY_VALUE"

    printf "\nPress ENTER to return..."

    IFS= read -r

    continue

fi
###############################################################################
# Success Screen
###############################################################################

clear

###############################################################################
# Refresh Current Value
###############################################################################

CURRENT_VALUE=$(sed -n '1p' "$CURRENT_FILE")

case "$CURRENT_VALUE" in

    0)

        CURRENT_STATUS="Camera Allowed"
        CURRENT_ICON="󰄀"
        CURRENT_COLOR=$GREEN
        CURRENT_BAR="██████████████████████████████"

        ;;

    1)

        CURRENT_STATUS="Camera Blocked"
        CURRENT_ICON="󰄁"
        CURRENT_COLOR=$RED
        CURRENT_BAR="██████████████████████████████"

        ;;

    *)

        CURRENT_STATUS="Unknown"
        CURRENT_ICON=""
        CURRENT_COLOR=$GRAY
        CURRENT_BAR="??????????????????????????????"

        ;;

esac

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

printf "%s" "$CYAN"

printf '%*s\n' \
    $(((${#VERSION} + WIDTH + 24) / 2)) \
    "Camera Status Updated"

printf "%s\n\n" "$RESET"

###############################################################################
# Current Status Visualization
###############################################################################

printf "Current Camera Status\n\n"

printf "%s%s %s %s%s\n\n" \
    "$CURRENT_COLOR" \
    "$CURRENT_ICON" \
    "$CURRENT_BAR" \
    "$CURRENT_STATUS" \
    "$RESET"

###############################################################################
# Success Table
###############################################################################

printf "┌──────────────────────┬────────────────────┬──────────────────────────────────────┬────────────────────────────────────────────┐\n"

printf "│ Label                │ Value              │ Description                          │ Meaning                                    │\n"

printf "├──────────────────────┼────────────────────┼──────────────────────────────────────┼────────────────────────────────────────────┤\n"

printf "│ Status               │ Success            │ Operation Result                     │ Camera status updated successfully         │\n"

printf "│ Previous Status      │ %-18s │ Previous camera status              │ Camera state before modification           │\n" \
    "$OLD_STATUS"

printf "│ Current Status       │ %-18s │ Active camera status                │ Newly applied camera state                 │\n" \
    "$CURRENT_STATUS"

printf "│ Verification         │ Successful         │ Read-back verification               │ Firmware value verified                    │\n"

printf "└──────────────────────┴────────────────────┴──────────────────────────────────────┴────────────────────────────────────────────┘\n"

printf "\n"

printf "The requested camera status has been applied successfully.\n"

printf "\nPress ENTER to continue..."

IFS= read -r
###############################################################################
# Return to Camera Menu
###############################################################################

continue

;;

###############################################################################
# End of Option 2
###############################################################################
# Case 2 ends here

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