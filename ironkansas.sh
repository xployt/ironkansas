#!/system/bin/sh
# Anti-spyware script for Moto G 2025 (kansas) – removes IronSource/AppCloud packages
# Run without root in a terminal emulator or via adb shell.

# Define paths (full paths for safety in environments like Termux)
PM="/system/bin/pm"
AM="/system/bin/am"
GREP="/system/bin/grep"
ECHO="/system/bin/echo"

# Check if we are on Android (pm must exist)
if [ ! -f "$PM" ]; then
    $ECHO "Error: pm command not found. This script must be run on an Android device."
    exit 1
fi

# List of known IronSource/AppCloud and related carrier spyware packages
PACKAGES="
com.ironsrc.aura.tmo
com.aura.jet.att
com.aura.oobe.dish
com.ironsrc.aura
com.ironsrc.appcloud
com.ironsrc.services
com.aura.oem
com.ironsrc.aura.att
com.ironsrc.aura.vzw
com.ironsrc.aura.sprint
com.ironsrc.aura.uscc
com.ironsrc.aura.metro
com.ironsrc.aura.bst
com.ironsrc.aura.cricket
com.ironsrc.aura.google
com.ironsrc.aura.android
"

$ECHO "Scanning for spyware packages..."
for PKG in $PACKAGES; do
    # Check if package is installed for user 0
    if $PM list packages --user 0 | $GREP -q "^package:$PKG$"; then
        $ECHO "Found: $PKG"
        # Stop the app forcefully
        $ECHO "   Stopping $PKG..."
        $AM force-stop $PKG > /dev/null 2>&1
        # Attempt to uninstall for current user
        $ECHO "   Uninstalling for user 0..."
        UNINSTALL_OUTPUT=$($PM uninstall --user 0 $PKG 2>&1)
        UNINSTALL_EXIT=$?
        if [ $UNINSTALL_EXIT -eq 0 ]; then
            $ECHO "   SUCCESS: $PKG uninstalled."
        else
            $ECHO "   FAILED to uninstall: $UNINSTALL_OUTPUT"
            # If uninstall fails (e.g., system app), try to disable it
            $ECHO "   Attempting to disable $PKG instead..."
            DISABLE_OUTPUT=$($PM disable $PKG 2>&1)
            if [ $? -eq 0 ]; then
                $ECHO "   SUCCESS: $PKG disabled."
            else
                $ECHO "   FAILED to disable: $DISABLE_OUTPUT"
            fi
        fi
    else
        $ECHO "Not installed: $PKG"
    fi
done

$ECHO "Done."
