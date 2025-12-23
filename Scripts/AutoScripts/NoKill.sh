#!/data/data/com.termux/files/usr/bin/bash
A1=com.termux

printf '\033[33mACCEPT PERMISSIONS WHEN PROMPTED\033[0m\n'
printf '\033[33mConcede los Permisos\033[0m\n'
sleep 3
printf 'n\n'|termux-setup-storage
sleep 5
termux-wake-lock

if ! command -v adb >/dev/null 2>&1;then
printf '\033[33mInstalando ADB...\033[0m\n'
apt update -y && yes | apt upgrade
pkg install -y android-tools
fi

if su -c "id" >/dev/null 2>&1;then
printf '\033[32mROOT\033[0m\n'

su <<'EOF'
A1=com.termux

/system/bin/device_config set_sync_disabled_for_tests persistent
/system/bin/device_config put activity_manager max_phantom_processes 2147483647
/system/bin/device_config put runtime_native_boot use_freezer false
/system/bin/settings put global settings_enable_monitor_phantom_procs false
/system/bin/am set-inactive $A1 false
/system/bin/cmd deviceidle whitelist +$A1
/system/bin/cmd power set-mode 0
/system/bin/dumpsys deviceidle disable

/system/bin/cmd appops set --uid $A1 RUN_IN_BACKGROUND allow
/system/bin/cmd appops set --uid $A1 RUN_ANY_IN_BACKGROUND allow
/system/bin/cmd appops set --uid $A1 SYSTEM_EXEMPT_FROM_ACTIVITY_BG_START_RESTRICTION allow
/system/bin/cmd appops set --uid $A1 SYSTEM_EXEMPT_FROM_HIBERNATION allow
/system/bin/cmd appops set --uid $A1 SYSTEM_EXEMPT_FROM_POWER_RESTRICTIONS allow
/system/bin/cmd appops set --uid $A1 SYSTEM_EXEMPT_FROM_SUSPENSION allow
/system/bin/cmd appops set --uid $A1 WAKE_LOCK allow
/system/bin/cmd appops set --uid $A1 REQUEST_IGNORE_BATTERY_OPTIMIZATIONS allow
/system/bin/cmd appops set --uid $A1 ACTIVATE_PLATFORM_VPN allow
/system/bin/cmd appops set --uid $A1 INTERACT_ACROSS_PROFILES allow
/system/bin/cmd appops set --uid $A1 SCHEDULE_EXACT_ALARM allow
/system/bin/cmd appops set --uid $A1 START_FOREGROUND allow

P1=$(pidof $A1)
[ -n "$P1" ]&&echo -1000>/proc/$P1/oom_score_adj
EOF

else
printf '\033[33mPair in ADB Wireless\033[0m\n'
printf '\033[33mVincula desde ADB WiFi\033[0m\n'

sleep 5

am start -a android.settings.APPLICATION_DEVELOPMENT_SETTINGS
am start -a android.settings.WIRELESS_DEBUGGING_SETTINGS
read -p "PORT_PAIR: " P1
adb pair 127.0.0.1:$P1
read -p "PORT_ADB: " P2
adb connect 127.0.0.1:$P2
adb devices

adb shell "/system/bin/device_config set_sync_disabled_for_tests persistent"
adb shell "/system/bin/device_config put activity_manager max_phantom_processes 2147483647"
adb shell "/system/bin/device_config put runtime_native_boot use_freezer false"
adb shell "/system/bin/settings put global settings_enable_monitor_phantom_procs false"
adb shell "/system/bin/am set-inactive $A1 false"
adb shell "/system/bin/cmd deviceidle whitelist +$A1"
adb shell "/system/bin/cmd power set-mode 0"
adb shell "/system/bin/dumpsys deviceidle disable"

adb shell "/system/bin/cmd appops set --uid $A1 RUN_IN_BACKGROUND allow"
adb shell "/system/bin/cmd appops set --uid $A1 RUN_ANY_IN_BACKGROUND allow"
adb shell "/system/bin/cmd appops set --uid $A1 SYSTEM_EXEMPT_FROM_ACTIVITY_BG_START_RESTRICTION allow"
adb shell "/system/bin/cmd appops set --uid $A1 SYSTEM_EXEMPT_FROM_HIBERNATION allow"
adb shell "/system/bin/cmd appops set --uid $A1 SYSTEM_EXEMPT_FROM_POWER_RESTRICTIONS allow"
adb shell "/system/bin/cmd appops set --uid $A1 SYSTEM_EXEMPT_FROM_SUSPENSION allow"
adb shell "/system/bin/cmd appops set --uid $A1 WAKE_LOCK allow"
adb shell "/system/bin/cmd appops set --uid $A1 REQUEST_IGNORE_BATTERY_OPTIMIZATIONS allow"
adb shell "/system/bin/cmd appops set --uid $A1 ACTIVATE_PLATFORM_VPN allow"
adb shell "/system/bin/cmd appops set --uid $A1 INTERACT_ACROSS_PROFILES allow"
adb shell "/system/bin/cmd appops set --uid $A1 SCHEDULE_EXACT_ALARM allow"
adb shell "/system/bin/cmd appops set --uid $A1 START_FOREGROUND allow"

adb kill-server
fi