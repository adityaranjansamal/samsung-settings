#!/bin/sh
#
# Samsung Lid Settings
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

    printf '%*s\n' $(((${#VERSION} + WIDTH + 8) / 2)) "Lid Settings"
    printf '\n'

    ###########################################################################
    # Menu
    ###########################################################################

    printf "  1. 󰌍  Show Lid Status\n"
    printf "  2. 󰌎  Change Lid Status\n"
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

        # case 1 starts here

###############################################################################
# Power-On Lid Open Firmware Attribute
###############################################################################

LID_DIR="/sys/class/firmware-attributes/samsung-galaxybook/attributes/power_on_lid_open"

if [ ! -d "$LID_DIR" ]; then

    clear

    printf "Error: Samsung lid firmware attribute directory was not found.\n"

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

    if [ -r "$LID_DIR/$FILE" ]; then
        sed -n '1p' "$LID_DIR/$FILE"
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

###############################################################################
# Lid Status Mapping
###############################################################################

case "$CURRENT_VALUE" in

    ###########################################################################
    # Enabled
    ###########################################################################

    1|enabled|enable|on|true)

        LID_ICON="󰤽"
        LID_COLOR=$GREEN

        LID_STATUS="Enabled"

        LID_DESCRIPTION="Power-on when lid is opened"

        LID_MEANING="Opening the laptop lid will power on the system"

        LID_BAR="██████████████████████████████"

        ;;

    ###########################################################################
    # Disabled
    ###########################################################################

    0|disabled|disable|off|false)

        LID_ICON="󰤼"
        LID_COLOR=$RED

        LID_STATUS="Disabled"

        LID_DESCRIPTION="Power-on when lid is opened"

        LID_MEANING="Opening the laptop lid will not power on the system"

        LID_BAR="░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"

        ;;

    ###########################################################################
    # Unknown
    ###########################################################################

    *)

        LID_ICON=""
        LID_COLOR=$GRAY

        LID_STATUS="Unknown"

        LID_DESCRIPTION="Power-on when lid is opened"

        LID_MEANING="Firmware returned an unknown value"

        LID_BAR="??????????????????????????????"

        ;;

esac
###############################################################################
# Display Lid Information
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
    $(((${#VERSION} + WIDTH + 10) / 2)) \
    "Current Lid Status"

printf "%s\n\n" "$RESET"

###############################################################################
# Current Lid Status
###############################################################################

printf "┌──────────────────────┬────────────────────┬──────────────────────────────────────┬────────────────────────────────────────────┐\n"

printf "│ Label                │ Value              │ Description                          │ Meaning                                    │\n"

printf "├──────────────────────┼────────────────────┼──────────────────────────────────────┼────────────────────────────────────────────┤\n"

printf "│ %s%-2s%s Lid Status      │ %s%-18s%s │ %-36s │ %-42s │\n" \
    "$LID_COLOR" \
    "$LID_ICON" \
    "$RESET" \
    "$LID_COLOR" \
    "$LID_STATUS" \
    "$RESET" \
    "$LID_DESCRIPTION" \
    "$LID_MEANING"

printf "└──────────────────────┴────────────────────┴──────────────────────────────────────┴────────────────────────────────────────────┘\n"

printf "\n"

###############################################################################
# Lid Status Visualization
###############################################################################

printf "%sCurrent Lid Status%s\n\n" \
    "$CYAN" \
    "$RESET"

printf "%s%s %s %s%s\n\n" \
    "$LID_COLOR" \
    "$LID_ICON" \
    "$LID_BAR" \
    "$LID_STATUS" \
    "$RESET"

###############################################################################
# Firmware Attribute Information
###############################################################################

printf "┌──────────────────────┬────────────────────┬──────────────────────────────────────┬────────────────────────────────────────────┐\n"

printf "│ Label                │ Value              │ Description                          │ Meaning                                    │\n"

printf "├──────────────────────┼────────────────────┼──────────────────────────────────────┼────────────────────────────────────────────┤\n"

printf "│ 󰤽 Current Value      │ %-18s │ Current firmware value              │ 1=Enabled, 0=Disabled                      │\n" \
    "$CURRENT_VALUE"

printf "│ 󰘳 Default Value      │ %-18s │ Factory default value               │ Default firmware configuration             │\n" \
    "$DEFAULT_VALUE"

printf "│ 󰈙 Display Name       │ %-18s │ Firmware attribute name             │ Human-readable attribute                   │\n" \
    "$DISPLAY_NAME"

printf "│ 󰗊 Language Code      │ %-18s │ Display language                    │ Attribute localization language            │\n" \
    "$DISPLAY_LANGUAGE"

printf "│ 󰈔 Possible Values    │ %-18s │ Supported values                    │ 0=Disabled, 1=Enabled                      │\n" \
    "$POSSIBLE_VALUES"

printf "│ 󰒓 Attribute Type     │ %-18s │ Firmware attribute type             │ Attribute data representation              │\n" \
    "$ATTRIBUTE_TYPE"

printf "└──────────────────────┴────────────────────┴──────────────────────────────────────┴────────────────────────────────────────────┘\n"

printf "\nPress ENTER to return..."

IFS= read -r

continue
;;
# case 1 ends here

       2)


       # case 2 starts here

###############################################################################
# Power-On Lid Open Firmware Attribute
###############################################################################

LID_DIR="/sys/class/firmware-attributes/samsung-galaxybook/attributes/power_on_lid_open"

CURRENT_FILE="$LID_DIR/current_value"
POSSIBLE_FILE="$LID_DIR/possible_values"

###############################################################################
# Verify Files
###############################################################################

if [ ! -r "$CURRENT_FILE" ]; then

    clear

    printf "Error: Unable to read the current Power-On Lid Open status.\n"

    printf "\nPress ENTER to return..."
    IFS= read -r

    continue

fi

if [ ! -r "$POSSIBLE_FILE" ]; then

    clear

    printf "Error: Unable to determine the supported Power-On Lid Open operations.\n"

    printf "\nPress ENTER to return..."
    IFS= read -r

    continue

fi

###############################################################################
# Read Current Status
###############################################################################

CURRENT_VALUE=$(sed -n '1p' "$CURRENT_FILE")

###############################################################################
# Validate Firmware Support
###############################################################################

SUPPORTED_VALUES=$(tr ';' ' ' < "$POSSIBLE_FILE")

ENABLE_SUPPORTED=0
DISABLE_SUPPORTED=0

for VALUE in $SUPPORTED_VALUES
do

    case "$VALUE" in

        1)

            ENABLE_SUPPORTED=1

            ;;

        0)

            DISABLE_SUPPORTED=1

            ;;

    esac

done

if [ "$ENABLE_SUPPORTED" -eq 0 ] && [ "$DISABLE_SUPPORTED" -eq 0 ]; then

    clear

    printf "This firmware does not expose supported Power-On Lid Open operations.\n"

    printf "\nPress ENTER to return..."

    IFS= read -r

    continue

fi

###############################################################################
# Current Status
###############################################################################

case "$CURRENT_VALUE" in

    1)

        STATUS_NAME="Power-On Lid Open ON"

        STATUS_ICON="󰤽"

        STATUS_COLOR=$GREEN

        STATUS_BAR="██████████████████████████████"

        ;;

    0)

        STATUS_NAME="Power-On Lid Open OFF"

        STATUS_ICON="󰤼"

        STATUS_COLOR=$RED

        STATUS_BAR="░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"

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
        $(((${#VERSION} + WIDTH + 12) / 2)) \
        "Change Power-On Lid Open"

    printf "%s\n\n" "$RESET"

    ###########################################################################
    # Current Status
    ###########################################################################

    printf "Current Power-On Lid Open Status\n\n"

    printf "%s%s %s %s%s\n\n" \
        "$STATUS_COLOR" \
        "$STATUS_ICON" \
        "$STATUS_BAR" \
        "$STATUS_NAME" \
        "$RESET"

    ###########################################################################
    # Menu
    ###########################################################################

    printf "┌────────┬──────────────────────────────────────┬────────────────────────────────────────────────────┐\n"

    printf "│ Option │ Action                               │ Result                                             │\n"

    printf "├────────┼──────────────────────────────────────┼────────────────────────────────────────────────────┤\n"

    printf "│ 1      │ Enable Power-On Lid Open             │ Sets current_value to 1                            │\n"

    printf "│ 2      │ Disable Power-On Lid Open            │ Sets current_value to 0                            │\n"

    printf "└────────┴──────────────────────────────────────┴────────────────────────────────────────────────────┘\n"

    printf "\n"

    printf "0. Return to Lid Menu\n"

    printf "\nSelect an option: "

    IFS= read -r CHOICE

    case "$CHOICE" in

        0)

            continue 2

            ;;

        1)

            NEW_VALUE=1

            break

            ;;

        2)

            NEW_VALUE=0

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

    1)

        OLD_STATUS="Power-On Lid Open ON"
        OLD_ICON="󰤽"
        OLD_COLOR=$GREEN

        ;;

    0)

        OLD_STATUS="Power-On Lid Open OFF"
        OLD_ICON="󰤼"
        OLD_COLOR=$RED

        ;;

    *)

        OLD_STATUS="Unknown"
        OLD_ICON=""
        OLD_COLOR=$GRAY

        ;;

esac

case "$NEW_VALUE" in

    1)

        NEW_STATUS="Power-On Lid Open ON"
        NEW_ICON="󰤽"
        NEW_COLOR=$GREEN

        ;;

    0)

        NEW_STATUS="Power-On Lid Open OFF"
        NEW_ICON="󰤼"
        NEW_COLOR=$RED

        ;;

    *)

        NEW_STATUS="Unknown"
        NEW_ICON=""
        NEW_COLOR=$GRAY

        ;;

esac

###############################################################################
# No Changes Required
###############################################################################

if [ "$CURRENT_VALUE" = "$NEW_VALUE" ]; then

    clear

    printf "Power-On Lid Open is already set to:\n\n"

    printf "%s%s %s%s\n\n" \
        "$OLD_COLOR" \
        "$OLD_ICON" \
        "$OLD_STATUS" \
        "$RESET"

    printf "No changes were made.\n"

    printf "\nPress ENTER to return to the Lid Menu..."

    IFS= read -r

    continue

fi

###############################################################################
# Administrator Privileges Required
###############################################################################

clear

printf "Current Power-On Lid Open Status\n\n"

printf "%s%s %s%s\n\n" \
    "$OLD_COLOR" \
    "$OLD_ICON" \
    "$OLD_STATUS" \
    "$RESET"

printf "Requested Power-On Lid Open Status\n\n"

printf "%s%s %s%s\n\n" \
    "$NEW_COLOR" \
    "$NEW_ICON" \
    "$NEW_STATUS" \
    "$RESET"

printf "Administrator (root/sudo) privileges are required.\n\n"

###############################################################################
# Apply New Setting
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

    1)

        CURRENT_STATUS="Power-On Lid Open ON"
        CURRENT_ICON="󰤽"
        CURRENT_COLOR=$GREEN
        CURRENT_BAR="██████████████████████████████"

        ;;

    0)

        CURRENT_STATUS="Power-On Lid Open OFF"
        CURRENT_ICON="󰤼"
        CURRENT_COLOR=$RED
        CURRENT_BAR="░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"

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
    $(((${#VERSION} + WIDTH + 30) / 2)) \
    "Power-On Lid Open Updated"

printf "%s\n\n" "$RESET"

###############################################################################
# Current Status Visualization
###############################################################################

printf "Current Power-On Lid Open Status\n\n"

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

printf "│ Status               │ Success            │ Operation Result                     │ Power-On Lid Open updated successfully     │\n"

printf "│ Previous Status      │ %-18s │ Previous lid-open state             │ State before modification                  │\n" \
    "$OLD_STATUS"

printf "│ Current Status       │ %-18s │ Active lid-open state               │ Newly applied firmware state               │\n" \
    "$CURRENT_STATUS"

printf "│ Verification         │ Successful         │ Read-back verification               │ Firmware value verified                    │\n"

printf "└──────────────────────┴────────────────────┴──────────────────────────────────────┴────────────────────────────────────────────┘\n"

printf "\n"

printf "Power-On Lid Open has been updated successfully.\n"





# printf "\nPress ENTER to continue..."

# IFS= read -r
# ###############################################################################
# # Return to Lid Menu
# ###############################################################################

# continue

# ;;

# ###############################################################################
# # End of Option 2
# ###############################################################################



###############################################################################
# Reboot Prompt
###############################################################################

while :
do

    printf "A system reboot is recommended for the lid mode\n"
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

            printf "\nThe selected lid mode may not be fully applied until then."

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






# case 2 ends here

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
