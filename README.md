
      
      %%The script can be run in Termux or via adb shell directly. But they want to execute on the device, so we'll assume they have a terminal app like Termux or can run via adb shell.%%
checks for (Ironsource apps)** and disables them via "pm uninstall --user 0 <package>"

**com.ironsrc.aura.tmo
com.aura.jet.att
com.ironsrc.aura
com.ironsrc.appcloud
com.ironsrc.services
com.aura.oem     
....etc, let me know if there any are other packages not included.


uasge sh ironkansas.sh
