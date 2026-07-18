#!/bin/sh
#
# Samsung Battery Settings
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

    printf '%*s\n' $(((${#VERSION} + WIDTH + 6) / 2)) "Battery Settings"
    printf '\n'

    ###########################################################################
    # Menu
    ###########################################################################

    printf '  1.   Show Battery Information\n'
    printf '  2.   Change Battery Protection Threshold\n'
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



    # Global Declaration of custom methods and attributes
    # Debug 1


    ###############################################################################
# ANSI Colors
###############################################################################

RED=$(printf '\033[31m')
GREEN=$(printf '\033[32m')
YELLOW=$(printf '\033[33m')
BLUE=$(printf '\033[34m')
CYAN=$(printf '\033[36m')
RESET=$(printf '\033[0m')
###############################################################################
# Battery Health Bar
###############################################################################

draw_health_bar()
{
    WIDTH=30

    FILLED=$((BATTERY_HEALTH_INT * WIDTH / 100))
    EMPTY=$((WIDTH - FILLED))

    case "$HEALTH_BAR_COLOR" in
        GREEN)
            COLOR=$GREEN
            ;;
        YELLOW)
            COLOR=$YELLOW
            ;;
        *)
            COLOR=$RED
            ;;
    esac

    printf "%s[" "$COLOR"

    i=0
    while [ "$i" -lt "$FILLED" ]
    do
        printf "█"
        i=$((i + 1))
    done

    i=0
    while [ "$i" -lt "$EMPTY" ]
    do
        printf "░"
        i=$((i + 1))
    done

    printf "]%s %s\n" "$RESET" "$BATTERY_HEALTH"
}

draw_threshold_bar()
{
    THRESHOLD="$1"

    case "$THRESHOLD" in

        50)
            COLOR=$GREEN
            DESC="Maximum Protection"
            BAR="██████████████████████████████"
            ;;

        60)
            COLOR=$(printf '\033[92m')
            DESC="Laptop Desk Setup"
            BAR="█████████████████████████░░░░░"
            ;;

        70)
            COLOR=$YELLOW
            DESC="Medium Protection"
            BAR="█████████████████████░░░░░░░░"
            ;;

        80)
            COLOR=$(printf '\033[38;5;208m')
            DESC="Recommended Protection"
            BAR="█████████████████░░░░░░░░░░░"
            ;;

        90)
            COLOR=$(printf '\033[38;5;88m')
            DESC="Low Protection"
            BAR="███████████░░░░░░░░░░░░░░░░░"
            ;;

        100)
            COLOR=$RED
            DESC="Battery Protection Disabled"
            BAR="░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
            ;;

        *)
            COLOR=$GRAY
            DESC="Unknown"
            BAR="??????????????????????????????"
            ;;

    esac

    printf "%s%s%s  %s\n" \
        "$COLOR" \
        "$BAR" \
        "$RESET" \
        "$DESC"
}



    ###########################################################################
    # Read User Choice
    ###########################################################################

    printf '\nSelect an option: '
    IFS= read -r CHOICE

    case "$CHOICE" in

    # Case 1: Show Battery Information

        1)

###############################################################################
# Clear Screen
###############################################################################

clear

###############################################################################
# Locate Batteries
###############################################################################

POWER_SUPPLY_DIR="/sys/class/power_supply"

if [ ! -d "$POWER_SUPPLY_DIR" ]; then
    printf "Error: %s does not exist.\n" "$POWER_SUPPLY_DIR"
    printf "Battery information cannot be obtained.\n"

    printf "\nPress ENTER to return..."
    IFS= read -r
    continue
fi

BATTERIES=""

for ENTRY in "$POWER_SUPPLY_DIR"/BAT*
do

    if [ -d "$ENTRY" ]; then

        BATTERIES="$BATTERIES $(basename "$ENTRY")"

    fi

done

###############################################################################
# Count Batteries
###############################################################################

BATTERY_COUNT=0

for BAT in $BATTERIES
do
    BATTERY_COUNT=$((BATTERY_COUNT + 1))
done

###############################################################################
# No Battery Found
###############################################################################

if [ "$BATTERY_COUNT" -eq 0 ]; then

    printf "No battery was detected on this system.\n"
    printf "Unable to continue.\n"

    printf "\nPress ENTER to return..."
    IFS= read -r
    continue

fi

###############################################################################
# One Battery
###############################################################################

if [ "$BATTERY_COUNT" -eq 1 ]; then

    for BAT in $BATTERIES
    do
        SELECTED_BATTERY="$BAT"
    done

###############################################################################
# Multiple Batteries
###############################################################################

else

    while :
    do

        clear

        printf "Multiple batteries were detected.\n\n"

        INDEX=1

        for BAT in $BATTERIES
        do
            printf "  %d. %s\n" "$INDEX" "$BAT"
            INDEX=$((INDEX + 1))
        done

        printf "\nChoose a battery: "

        IFS= read -r CHOICE

        INDEX=1

        SELECTED_BATTERY=""

        for BAT in $BATTERIES
        do

            if [ "$CHOICE" = "$INDEX" ]; then

                SELECTED_BATTERY="$BAT"

                break

            fi

            INDEX=$((INDEX + 1))

        done

        if [ -n "$SELECTED_BATTERY" ]; then

            break

        fi

        printf "\nInvalid selection."

        printf "\nPress ENTER to try again..."

        IFS= read -r

    done

fi

###############################################################################
# Battery Directory
###############################################################################

BATTERY_DIR="$POWER_SUPPLY_DIR/$SELECTED_BATTERY"
clear
###############################################################################
# Verify Battery Directory
###############################################################################

if [ ! -d "$BATTERY_DIR" ]; then

    printf "Error: Battery directory '%s' does not exist.\n" "$BATTERY_DIR"

    printf "\nPress ENTER to return..."
    IFS= read -r
    continue

fi

###############################################################################
# Read Battery Information
###############################################################################

read_value()
{
    FILE="$1"

    if [ -r "$BATTERY_DIR/$FILE" ]; then
        sed -n '1p' "$BATTERY_DIR/$FILE"
    else
        printf "N/A"
    fi
}

ALARM=$(read_value alarm)
CAPACITY=$(read_value capacity)
CAPACITY_LEVEL=$(read_value capacity_level)
CHARGE_LIMIT=$(read_value charge_control_end_threshold)
CHARGE_FULL=$(read_value charge_full)
CHARGE_FULL_DESIGN=$(read_value charge_full_design)
CHARGE_NOW=$(read_value charge_now)
CURRENT_NOW=$(read_value current_now)
CYCLE_COUNT=$(read_value cycle_count)
MANUFACTURER=$(read_value manufacturer)
MODEL_NAME=$(read_value model_name)
PRESENT=$(read_value present)
SERIAL_NUMBER=$(read_value serial_number)
STATUS=$(read_value status)
TECHNOLOGY=$(read_value technology)
TYPE=$(read_value type)
UEVENT=$(read_value uevent)
VOLTAGE_MIN_DESIGN=$(read_value voltage_min_design)
VOLTAGE_NOW=$(read_value voltage_now)
clear
###############################################################################
# Calculate Battery Health
###############################################################################

BATTERY_HEALTH="N/A"
BATTERY_HEALTH_INT=0
HEALTH_BAR_COLOR="GREEN"

case "$CHARGE_FULL" in
    ''|*[!0-9]*)
        ;;
    *)
        case "$CHARGE_FULL_DESIGN" in
            ''|0|*[!0-9]*)
                ;;
            *)
                BATTERY_HEALTH_INT=$((CHARGE_FULL * 100 / CHARGE_FULL_DESIGN))
                BATTERY_HEALTH="${BATTERY_HEALTH_INT}%"

                if [ "$BATTERY_HEALTH_INT" -ge 80 ]; then
                    HEALTH_BAR_COLOR="GREEN"

                elif [ "$BATTERY_HEALTH_INT" -ge 50 ]; then
                    HEALTH_BAR_COLOR="YELLOW"

                else
                    HEALTH_BAR_COLOR="RED"

                fi
                ;;
        esac
        ;;
esac


# ANSII Colors, draw_health_bar(), draw_threshold_bar() were originally here. Now globally declared for reusability.

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

printf '%*s\n' $(((${#VERSION} + WIDTH + 17) / 2)) "Battery Information"
printf '\n'

###############################################################################
# Important Information
###############################################################################

printf "┌──────────────────────┬────────────────────┬──────────────────────────────────────┬────────────────────────────────────────────┐\n"
printf "│ Label                │ Value              │ Description                          │ Meaning                                    │\n"
printf "├──────────────────────┼────────────────────┼──────────────────────────────────────┼────────────────────────────────────────────┤\n"

printf "│  Capacity           │ %-18s │ Current battery charge               │ Percentage of charge remaining             │\n" "${CAPACITY}%%"

printf "│  Charge Limit       │ %-18s │ Battery protection threshold         │ Charging stops at this percentage          │\n" "${CHARGE_LIMIT}%%"

printf "│  Battery Health     │ %-18s │ Estimated battery health             │ Capacity compared to factory specification │\n" "$BATTERY_HEALTH"

printf "└──────────────────────┴────────────────────┴──────────────────────────────────────┴────────────────────────────────────────────┘\n"

printf "\nBattery Health\n"
draw_health_bar
printf "\n"

###############################################################################
# Battery Information Table
###############################################################################

printf "┌──────────────────────┬────────────────────┬──────────────────────────────────────┬────────────────────────────────────────────┐\n"
printf "│ Label                │ Value              │ Description                          │ Meaning                                    │\n"
printf "├──────────────────────┼────────────────────┼──────────────────────────────────────┼────────────────────────────────────────────┤\n"

printf "│  Battery            │ %-18s │ Detected battery                     │ Battery selected for this session          │\n" "$SELECTED_BATTERY"

printf "│  Manufacturer       │ %-18s │ Battery manufacturer                 │ Company that manufactured the battery      │\n" "$MANUFACTURER"

printf "│  Model Name         │ %-18s │ Battery model                        │ Model reported by the battery              │\n" "$MODEL_NAME"

printf "│  Serial Number      │ %-18s │ Battery serial number                │ Unique battery identifier                  │\n" "$SERIAL_NUMBER"

printf "│  Technology         │ %-18s │ Battery chemistry                    │ Cell technology used                       │\n" "$TECHNOLOGY"

printf "│  Status             │ %-18s │ Current charging state               │ Charging, Discharging, Full, etc.          │\n" "$STATUS"

printf "│  Capacity Level     │ %-18s │ Kernel capacity level                │ Critical, Low, Normal, High, Full          │\n" "$CAPACITY_LEVEL"

printf "│  Present            │ %-18s │ Battery detected                     │ 1 = Present, 0 = Not Present               │\n" "$PRESENT"

printf "│  Charge Full        │ %-18s │ Current full capacity                │ Maximum charge battery currently holds     │\n" "$CHARGE_FULL"

printf "│  Design Capacity    │ %-18s │ Factory designed capacity            │ Original battery capacity                  │\n" "$CHARGE_FULL_DESIGN"

printf "│  Charge Now         │ %-18s │ Current stored charge                │ Remaining battery charge                   │\n" "$CHARGE_NOW"

printf "│  Current Now        │ %-18s │ Instantaneous current                │ Current flowing through battery            │\n" "$CURRENT_NOW"

printf "│  Voltage Now        │ %-18s │ Current voltage                      │ Battery output voltage                     │\n" "$VOLTAGE_NOW"

printf "│  Design Voltage     │ %-18s │ Factory design voltage               │ Nominal design voltage                     │\n" "$VOLTAGE_MIN_DESIGN"

printf "│  Cycle Count        │ %-18s │ Charge cycles                        │ Number of complete charge cycles           │\n" "$CYCLE_COUNT"

printf "│  Alarm              │ %-18s │ Alarm threshold                      │ Kernel battery alarm value                 │\n" "$ALARM"

printf "│  Type               │ %-18s │ Power supply type                    │ Usually 'Battery'                          │\n" "$TYPE"

printf "└──────────────────────┴────────────────────┴──────────────────────────────────────┴────────────────────────────────────────────┘\n"

printf "\nPress ENTER to return..."
IFS= read -r

continue
;;

# Case 1 Ends Here

        2)

        # Case 2 Starts Here

###############################################################################
# ANSI Colors
###############################################################################

    RED=$(printf '\033[31m')
    GREEN=$(printf '\033[32m')
    YELLOW=$(printf '\033[33m')
    BLUE=$(printf '\033[34m')
    MAGENTA=$(printf '\033[35m')
    CYAN=$(printf '\033[36m')
    WHITE=$(printf '\033[37m')
    GRAY=$(printf '\033[90m')
    RESET=$(printf '\033[0m')

###############################################################################
# Locate Battery Again
###############################################################################

POWER_SUPPLY_DIR="/sys/class/power_supply"

BATTERIES=""

for ENTRY in "$POWER_SUPPLY_DIR"/BAT*
do
    [ -d "$ENTRY" ] && BATTERIES="$BATTERIES $(basename "$ENTRY")"
done

BATTERY_COUNT=0

for BAT in $BATTERIES
do
    BATTERY_COUNT=$((BATTERY_COUNT + 1))
done

if [ "$BATTERY_COUNT" -eq 0 ]; then

    clear

    printf "No battery was detected on this system.\n"

    printf "\nPress ENTER to return..."
    IFS= read -r

    continue

fi

if [ "$BATTERY_COUNT" -eq 1 ]; then

    for BAT in $BATTERIES
    do
        SELECTED_BATTERY="$BAT"
    done

else

    while :
    do

        clear

        printf "Multiple batteries detected.\n\n"

        INDEX=1

        for BAT in $BATTERIES
        do
            printf "  %d. %s\n" "$INDEX" "$BAT"
            INDEX=$((INDEX + 1))
        done

        printf "\nChoose a battery: "

        IFS= read -r CHOICE

        INDEX=1

        SELECTED_BATTERY=""

        for BAT in $BATTERIES
        do

            if [ "$CHOICE" = "$INDEX" ]; then

                SELECTED_BATTERY="$BAT"

                break

            fi

            INDEX=$((INDEX + 1))

        done

        [ -n "$SELECTED_BATTERY" ] && break

    done

fi

BATTERY_DIR="$POWER_SUPPLY_DIR/$SELECTED_BATTERY"

###############################################################################
# Read Current Threshold
###############################################################################

CURRENT_THRESHOLD=$(cat "$BATTERY_DIR/charge_control_end_threshold" 2>/dev/null)

if [ -z "$CURRENT_THRESHOLD" ]; then

    clear

    printf "Unable to determine the current battery protection threshold.\n"

    printf "\nPress ENTER to return..."
    IFS= read -r

    continue

fi

###############################################################################
# Threshold Selection Loop
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

    printf '%*s\n' $(((${#VERSION} + WIDTH + 12) / 2)) "Battery Protection Threshold"

    printf "\n"

    #   printf "Current Threshold : %s%%\n\n" "$CURRENT_THRESHOLD"
    printf "┌──────────────────────────────────────────────────────────────────────────────────────────────┐\n"
    printf "│ Current Battery Protection Threshold                                                       │\n"
    printf "├──────────────────────────────────────────────────────────────────────────────────────────────┤\n"

    printf "│ Threshold : %-3s%%                                                                   │\n" \
        "$CURRENT_THRESHOLD"

    printf "│ Protection Level : "
    draw_threshold_bar "$CURRENT_THRESHOLD"

    printf "└──────────────────────────────────────────────────────────────────────────────────────────────┘\n\n"

    printf "┌────────┬──────────────┬──────────────────────────────┬──────────────────────────────────────┐\n"
    printf "│ Option │ Threshold    │ Description                  │ Protection Level                     │\n"
    printf "├────────┼──────────────┼──────────────────────────────┼──────────────────────────────────────┤\n"

    printf "│ 1      │ 50%%          │ Maximum Protection           │ ${GREEN}██████████████████████████████${RESET} │\n"

    printf "│ 2      │ 60%%          │ Laptop Desk Setup            │ \033[92m█████████████████████████░░░░░${RESET} │\n"

    printf "│ 3      │ 70%%          │ Medium Protection            │ ${YELLOW}█████████████████████░░░░░░░░${RESET} │\n"

    printf "│ 4      │ 80%%          │ Recommended Protection       │ \033[38;5;208m█████████████████░░░░░░░░░░░${RESET} │\n"

    printf "│ 5      │ 90%%          │ Low Protection               │ \033[38;5;88m███████████░░░░░░░░░░░░░░░░░${RESET} │\n"

    printf "│ 6      │ 100%% / Off   │ Battery Protection Disabled  │ ${RED}░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░${RESET} │\n"

    printf "├────────┴──────────────┴──────────────────────────────┴──────────────────────────────────────┤\n"

    printf "│ 0      │ Return to Battery Menu                                                  │\n"

    printf "└──────────────────────────────────────────────────────────────────────────────────────┘\n"

    printf "\n"

    printf "0. Return to Battery Menu\n"

    printf "\nSelect an option: "

    IFS= read -r CHOICE

    case "$CHOICE" in

        1)
            NEW_THRESHOLD=50
            break
            ;;

        2)
            NEW_THRESHOLD=60
            break
            ;;

        3)
            NEW_THRESHOLD=70
            break
            ;;

        4)
            NEW_THRESHOLD=80
            break
            ;;

        5)
            NEW_THRESHOLD=90
            break
            ;;

        6)
            NEW_THRESHOLD=100
            break
            ;;

        0)
            continue 2
            ;;

        *)

            printf "\nInvalid option."

            printf "\n\nPress ENTER to try again..."

            IFS= read -r
            ;;

    esac

done
###############################################################################
# No Change Required
###############################################################################

if [ "$CURRENT_THRESHOLD" = "$NEW_THRESHOLD" ]; then

    clear

    printf "Battery percentage threshold is already set to %s%%.\n" \
        "$CURRENT_THRESHOLD"

    printf "No changes were made.\n"

    printf "\nPress ENTER to return to the Battery Menu..."
    IFS= read -r

    continue

fi

###############################################################################
# Request Administrator Privileges
###############################################################################

clear

printf "The battery protection threshold will be changed from %s%% to %s%%.\n\n" \
    "$CURRENT_THRESHOLD" \
    "$NEW_THRESHOLD"

printf "Administrator (root/sudo) privileges are required.\n\n"

sudo -v

SUDO_STATUS=$?

if [ "$SUDO_STATUS" -ne 0 ]; then

    printf "\nAuthentication failed.\n"
    printf "Administrator (root/sudo) privileges are required.\n"

    printf "\nPress ENTER to return to the Battery Menu..."
    IFS= read -r

    continue

fi

###############################################################################
# Apply Threshold
###############################################################################

printf "\nApplying new battery protection threshold...\n"

if printf "%s" "$NEW_THRESHOLD" |
    sudo tee "$BATTERY_DIR/charge_control_end_threshold" >/dev/null
then

    :

else

    printf "\nFailed to write the new threshold.\n"

    printf "\nPress ENTER to return to the Battery Menu..."
    IFS= read -r

    continue

fi

###############################################################################
# Verify Threshold
###############################################################################

VERIFY_THRESHOLD=$(cat \
    "$BATTERY_DIR/charge_control_end_threshold" \
    2>/dev/null)

if [ "$VERIFY_THRESHOLD" != "$NEW_THRESHOLD" ]; then

    printf "\nVerification failed.\n"

    printf "Expected : %s%%\n" "$NEW_THRESHOLD"
    printf "Read Back: %s%%\n" "$VERIFY_THRESHOLD"

    printf "\nPress ENTER to return to the Battery Menu..."
    IFS= read -r

    continue

fi

###############################################################################
# Success Screen
###############################################################################

clear

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

printf '%*s\n' $(((${#VERSION} + WIDTH + 12) / 2)) "Battery Protection Threshold"

printf "\n"

printf "┌──────────────────────────┬────────────────────┬──────────────────────────────────────┬────────────────────────────────────────────┐\n"
printf "│ Label                    │ Value              │ Description                          │ Meaning                                    │\n"
printf "├──────────────────────────┼────────────────────┼──────────────────────────────────────┼────────────────────────────────────────────┤\n"

printf "│  Status                 │ Success            │ Operation result                     │ Threshold updated successfully             │\n"

printf "│  Previous Threshold     │ %-18s │ Previous protection threshold       │ Old battery charge limit                   │\n" \
    "${CURRENT_THRESHOLD}%%"

printf "│  Current Threshold      │ %-18s │ Applied protection threshold        │ New battery charge limit                   │\n" \
    "${NEW_THRESHOLD}%%"

printf "│  Verification           │ Successful         │ Read-back verification               │ New value confirmed                        │\n"

printf "└──────────────────────────┴────────────────────┴──────────────────────────────────────┴────────────────────────────────────────────┘\n"

printf "\n"

###############################################################################
# Reboot Prompt
###############################################################################

while :
do

    printf "A system reboot is required before the new battery protection\n"
    printf "threshold takes effect.\n\n"

    printf "Would you like to reboot now? (Y/N): "

    IFS= read -r REBOOT

    case "$REBOOT" in

        [Yy])

            printf "\nRebooting system...\n"

            if sudo reboot; then
                exit 0
            else

                printf "\nFailed to initiate reboot.\n"

                printf "\nPress ENTER to return to the Battery Menu..."
                IFS= read -r

                continue 2

            fi
            ;;

        [Nn]|"")

            printf "\nPlease remember to reboot your system later\n"
            printf "for the new battery protection threshold to take effect.\n"

            printf "\nPress ENTER to return to the Battery Menu..."
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

# Case 2 Ends Here

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