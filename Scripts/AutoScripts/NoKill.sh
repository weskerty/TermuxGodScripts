#!/data/data/com.termux/files/usr/bin/bash
A1=com.termux
T="👉✅ Concede los Permisos"
T1="ACCEPT PERMISSIONS WHEN PROMPTED"

clear
printf "\033[33m%s\033[0m \033[31m%s\033[0m\n" "$T1" "$T"
sleep 1
clear
printf "\033[31m%s\033[0m \033[33m%s\033[0m\n" "$T1" "$T"
sleep 1
clear
printf "\033[33m%s\033[0m \033[31m%s\033[0m\n" "$T1" "$T"
sleep 1
clear
printf "\033[31m%s\033[0m \033[33m%s\033[0m\n" "$T1" "$T"





printf 'n\n'|termux-setup-storage >/dev/null 2>&1

sleep 5
termux-wake-lock

if su -c "id" >/dev/null 2>&1;then

R=1
printf '\033[32mROOT\033[0m\n'
else
R=0
if ! command -v adb >/dev/null 2>&1;then
printf '\033[33mInstall ADB...\033[0m\n'
apt update -y && yes | apt upgrade
pkg install -y android-tools
fi
T2="Pair in ADB Wireless Config on Split Screen"
printf "\033[33m%s\033[0m" "$T2"
sleep 1
printf "\r\033[31m%s\033[0m" "$T2"
sleep 1
printf "\r\033[33m%s\033[0m\n" "$T2"
sleep 5


am start -a android.settings.APPLICATION_DEVELOPMENT_SETTINGS >/dev/null 2>&1
am start -a android.settings.WIRELESS_DEBUGGING_SETTINGS >/dev/null 2>&1

while :; do
    printf '\033[33mPORT_PAIR:\033[0m '
    read P1
    printf '\033[33mPAIRING CODE:\033[0m '
    read CODE
    adb pair 127.0.0.1:$P1 $CODE 2>&1 | grep -q "Successfully" && break
    printf '\033[31mFAILED, RETRY\033[0m\n'
done

while :; do
    printf '\033[33mPORT_ADB:\033[0m '
    read P2
    adb connect 127.0.0.1:$P2 >/dev/null 2>&1
    if adb devices | grep -q '[[:space:]]device$'; then
        break
    fi
    printf '\033[31mNO DEVICE, RETRY\033[0m\n'
    adb disconnect >/dev/null 2>&1
done
fi
printf '\n\033[32m[1] ✅Enable Patch\033[0m\n'
printf '\033[31m[2] 📴Disable Patch\033[0m\n'
read -t 5 -p "Select (1/2): " SEL || SEL=1


if [ "$SEL" = "2" ];then
printf '\n\033[31m[*] To Off...\033[0m\n'

if [ $R -eq 1 ];then
su <<'EOF'
/system/bin/device_config put activity_manager max_phantom_processes 32
/system/bin/device_config put runtime_native_boot use_freezer true
/system/bin/settings put global settings_enable_monitor_phantom_procs true
/system/bin/dumpsys deviceidle enable
EOF
else
adb shell "/system/bin/device_config put activity_manager max_phantom_processes 32"
adb shell "/system/bin/device_config put runtime_native_boot use_freezer true"
adb shell "/system/bin/settings put global settings_enable_monitor_phantom_procs true"
adb shell "/system/bin/dumpsys deviceidle enable"
adb kill-server
fi

printf '\033[32m[✓] Off\033[0m\n'
exit 0
fi

printf '\n\033[32m[*] Working...\033[0m\n'

if [ $R -eq 1 ];then
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


fi

printf '\033[32m[✓] OK\033[0m\n'
