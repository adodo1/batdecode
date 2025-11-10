@echo on&@endlocal&@rem cls
rem cls
@echo on&color f
set versioncode=21.2
set versiondate=2025.10.31
set versiondiscription=正式版
set author=大侠阿木（daxiaamu.com）
set UpdateApiUrl=https://api.optool.daxiaamu.com/optool/pctool_update.json
set install_driver_url=https://optool.daxiaamu.com/install_adb_drivers?src=pctool
set rootapi=https://api.optool.daxiaamu.com/root1.php
set premium_root_api=https://api.optool.daxiaamu.com/root.json
set premium_root_json_file=daxiaamu\temp\premium_root.json
set dumpspeedapi=https://api.optool.daxiaamu.com/optool/dumpspeed.php
set fastboot=daxiaamu\adb2\fastboot
set cecho=daxiaamu\cecho.exe
set curl=daxiaamu\curl.exe
set iconv=daxiaamu\iconv\iconv.exe
set rootmethod=
set methoddesc=
set rootfileurl=
set rootfilemd5=
set hashchh=
set deviceinfo=
set currentdir=%~dp0
title 大侠阿木一加全能工具箱 %versioncode% %versiondiscription% ——By %author%
rem MODE CON: COLS=72 LINES=43
if exist "%PROGRAMFILES(X86)%" (
set CHOICE=daxiaamu\choice64.exe
set curl=daxiaamu\curl\64\curl.exe
set aria2=daxiaamu\aria2c\64\aria2c.exe
set jq=daxiaamu\jq\jq-win64.exe
set sysinfo=64
) else (
if "%PROCESSOR_ARCHITECTURE%" == "x86" (
set CHOICE=daxiaamu\choice32.exe
set curl=daxiaamu\curl\32\curl.exe
set aria2=daxiaamu\aria2c\32\aria2c.exe
set jq=daxiaamu\jq\jq-windows-i386.exe
set sysinfo=32
) else (
set CHOICE=daxiaamu\choice64.exe
set curl=daxiaamu\curl\64\curl.exe
set aria2=daxiaamu\aria2c\64\aria2c.exe
set jq=daxiaamu\jq\jq-win64.exe
set sysinfo=64
)
)
@net config workstation |(find /i "windows 7")
set iswin7=%errorlevel%
if %iswin7%==0 (
set adb=daxiaamu\adb\adb -d
) else (
set adb=daxiaamu\adb2\adb -d
)
ver| findstr "\<5.1.2600\>" >nul
if %ERRORLEVEL%==0 (
@echo.
@echo 本工具箱不能在WinXP系统下使用，请更换更高版本系统，推荐Windows10或Windows 11系统
@echo.
%cecho% {00}{0A}或者在稍后弹出的网页中联系本工具作者远程操作{#}{\n}
call :Countdown "5" "打开网页"
call :OpenUrl "https://optool.daxiaamu.com/remote_rescue?src=root"
@echo.
@echo 按任意键退出
pause >nul
exit
)
rem cls
call:showdaxiaamu
@echo.
@echo                            努力启动中……
@echo.
call:checknewversion
@echo.
@echo                          正在检测电脑环境
call:checkconsole
call:clearadb
rem cls
goto start
:start
rem MODE CON: COLS=72 LINES=43
call:main
call:chose
rem cls
goto start
:install_driver
@echo on
rem cls
call:showdaxiaamu
@echo.
@echo 请按打开的网页中的教程安装驱动，然后才能使用工具箱后续功能
call :Countdown "3" "打开网页"
call :OpenUrl "%install_driver_url%"
@echo.
@echo 按任意键回到主界面
pause >nul
goto complete
:unlock_bootloader
rem cls
set unlockorrelock=unlock
@echo.
@echo 解锁会清空所有数据，包括内置存储，请你进行以下确认
@echo.
@echo      1)已经备份数据到电脑或云端或其他手机中
@echo.
@echo      2)已经在系统设置——开发者选项中打开“OEM解锁”
@echo.
@echo 请认真阅读上面内容
call:reconfirm
rem cls
@echo.
@echo 请根据你的实际情况进行选择
@echo.
@echo      1)我的设备不需要深度测试
@echo.
@echo      2)我的设备已经通过深度测试审核
@echo.
@echo      3)我的设备需要深度测试但是还没有申请
@echo.
@echo.     4)我的设备需要深度测试，我申请了，但尚未审核通过
@echo.
@echo.     5)我不知道我的设备是否需要深度测试
@echo.
%CHOICE% /c 12345 /n /M 请输入数字序号
set menuoption=%errorlevel%
if %menuoption%==1 goto ready4unlockrelock
if %menuoption%==2 goto unlock_bootloader_deeptest
if %menuoption%==3 (
@echo.
@echo 请您先申请深度测试并等待通过，稍后弹出的网页中有详细说明
@echo.
call :Countdown "5" "即将弹出网页"
call :OpenUrl "https://optool.daxiaamu.com/deeptest"
@echo.
@echo 现在请按任意键回到主界面
pause >nul
goto complete
)
if %menuoption%==4 (
@echo.
@echo 请您先等待通过，稍后弹出的网页中有详细说明
@echo.
call :Countdown "5" "即将弹出网页"
call :OpenUrl "https://optool.daxiaamu.com/deeptest"
@echo.
@echo 现在请按任意键回到主界面
pause >nul
goto complete
)
if %menuoption%==5 (
@echo.
@echo 请您先申请深度测试并等待通过，稍后弹出的网页中有详细说明
@echo.
call :Countdown "5" "即将弹出网页"
call :OpenUrl "https://optool.daxiaamu.com/deeptest"
@echo.
@echo 现在请按任意键回到主界面
pause >nul
goto complete
)
:unlock_bootloader_deeptest
rem cls
call:clearadb
@echo.
@echo 请在手机上的深度测试APP中点击【开始深度测试】，然后按任意键继续
pause >nul
call:regetbootloader
@echo 已连接Fastboot模式
goto %unlockorrelock%
:relock_bootloader
rem cls
set unlockorrelock=relock
@echo.
@echo 上锁会清空所有数据，包括内置存储和你自己装的软件
@echo.
@echo 请确认
@echo.
@echo      1)已经备份数据到电脑或云端或其他手机中
@echo.
@echo      2)当前官方系统分区未进行任何改动
@echo.
@echo      3)如果看不懂上面这句，请务必先本地升级或平刷一遍全量包，再使用本功能
@echo.
@echo 请认真阅读上面这段话
@echo.
@echo 完全照做是绝对安全的，不照做的后果可能是灾难性的
@echo.
%CHOICE% /c yn /n /M 确认继续请输入Y，取消操作请输入N：
if %errorlevel%==2 (
@echo.
@echo 你取消了操作，如果需要远程协助可以通过稍后弹出的网页联系作者
call :Countdown "5" "打开网页"
call :OpenUrl "https://optool.daxiaamu.com/remote_rescue?src=root"
@echo.
@echo 按任意键回到主界面
pause >nul
goto complete
)
call:reconfirm
@echo.
@echo 输入正确
goto ready4unlockrelock
:ready4unlockrelock
@echo on
rem cls
call:clearadb
@echo.
@echo 正在检测当前手机状态...
call:regetdevice
@echo.
@echo 当前为开机状态，将进入Fastboot模式后操作
call:rebootbootloader
call:regetbootloader
@echo 已连接Fastboot模式
goto %unlockorrelock%
:unlock
@echo on
rem cls
@echo.
@echo 正在解锁bootloader
@%fastboot% oem device-info 2>&1 | findstr /C:"Device unlocked: true" >nul 2>nul
if %errorlevel%==0 (
@%fastboot% reboot >nul
@echo.
@echo 你已经解锁了，无需重复解锁，工具箱本次没有进行任何操作
@echo.
@echo 按任意键结束
pause >nul
goto complete
)
@%fastboot% oem unlock >nul 2>nul
if %errorlevel% NEQ 0 goto unlock2
@echo.
@echo 现在还差最后一步：请在手机上用音量键选中UNLOCK THE BOOTLOADER选项，然后按电源键确认即可
@echo.
@echo 按任意键结束
pause >nul
goto complete
:unlock2
rem cls
@%fastboot% flashing unlock >nul 2>nul
if %errorlevel% NEQ 0 (
@%fastboot% reboot >nul
@echo.
@echo 解锁失败，请在开发者选项中打开“OEM”解锁
@echo.
%cecho% {00} {0C}或者在稍后弹出的网页中联系本工具作者远程操作{#}{\n}
call :Countdown "5" "打开网页"
call :OpenUrl "https://optool.daxiaamu.com/remote_rescue?src=root"
@echo.
@echo 按任意键结束
pause >nul
goto complete
)
@echo.
@echo 现在还差最后一步：请在手机上用音量键选中UNLOCK THE BOOTLOADER选项，然后按电源键确认即可
@echo.
@echo 按任意键结束
pause >nul
goto complete
:relock
@echo on
rem cls
@echo.
@echo 正在上锁bootloader
@%fastboot% oem device-info 2>&1 | findstr /C:"Device unlocked: false" >nul 2>nul
if %errorlevel%==0  (
@%fastboot% reboot >nul
@echo.
@echo 你已经上锁了，无需重复上锁，工具箱本次没有进行任何操作
@echo.
@echo 按任意键结束
pause >nul
goto complete
)
@%fastboot% oem lock >nul 2>nul
if %errorlevel% NEQ 0 goto relock2
@echo.
@echo 现在还差最后一步：请在手机上用音量键选中LOCK THE BOOTLOADER选项，然后按电源键确认即可
@echo.
@echo 按任意键结束
pause >nul
goto complete
:relock2
rem cls
@%fastboot% flashing lock >nul 2>nul
if %errorlevel% NEQ 0 (
@%fastboot% reboot >nul
@echo.
@echo 命令执行失败
@echo.
@echo 可能的原因：1）手机已经上锁 2）未知原因
@echo.
%cecho% {00} {0C}或者在稍后弹出的网页中联系本工具作者远程操作{#}{\n}
call :Countdown "5" "打开网页"
call :OpenUrl "https://optool.daxiaamu.com/remote_rescue?src=root"
@echo.
@echo 按任意键结束
pause >nul
goto complete
)
@echo.
@echo 现在还差最后一步：请在手机上用音量键选中LOCK THE BOOTLOADER选项，然后按电源键确认即可
@echo.
@echo 按任意键结束
pause >nul
goto complete
:rootbynet
@echo on
rem cls
@echo.
@echo 由于Android系统分区变化，本功能早已停止维护，无法支持较新的机型或系统
@echo.
@echo 但是无须担心↓
@echo.
@echo 兼容更多机型和系统的ROOT方式，已在专家ROOT模式中提供
@echo.
@echo 继续请输入Y，当然你可以退出（输入X）后使用专家ROOT模式
@echo.
%CHOICE% /c yx /n /M 请输入y或x：
set menuoption=%errorlevel%
if %menuoption%==2 goto complete
rem cls
@echo.
@echo 【警告1】
@echo.
@echo 如果你曾安装过magisk模块，这些模块将在root后被启用
@echo.
@echo 如果你这些模块和当前系统不兼容，则可能导致不开机
@echo.
@echo 强烈建议你先恢复出厂设置后再继续root
@echo.
@echo 【警告2】
@echo.
@echo 部分机型Root后会出现的问题，工具箱帮助中心均有解答
@echo.
@echo 确认继续请按y，退出ROOT流程请按X
@echo.
%CHOICE% /c yx /n /M 请输入y或x：
set menuoption=%errorlevel%
if %menuoption%==2 goto complete
rem cls
@echo.
@echo 即将开始ROOT流程
call :Countdown "5" "自动继续操作"
call :regetdevice
call:chkshell
%cecho% {0A}PASS{#}{\n}
@echo 正在获取设备信息
set productname=
set sdk=
set iscolor=
set str=
set color1=
set color2=
for /f "delims=" %%i in ('@%adb% shell getprop ro.product.device') do set productname=%%i
for /f "delims=" %%i in ('@%adb% shell getprop ro.build.version.sdk') do set sdk=%%i
@%adb% shell "str=$(getprop ro.build.version.opporom) && [ ${#str} -gt 1 ] && echo true || echo false" | findstr /C:"true" >nul 2>nul
if %errorlevel%==0 (
set color1=1
) else (
set color1=0
)
@%adb% shell "str=$(getprop ro.build.version.oplusrom) && [ ${#str} -gt 1 ] && echo true || echo false" | findstr /C:"true" >nul 2>nul
if %errorlevel%==0 (
set color2=1
) else (
set color2=0
)
if %color1%%color2%==00 (
set iscolor=unknown
) else (
set iscolor=color
)
set deviceinfo=%productname%%iscolor%%sdk%
%cecho% {0A}PASS{#}{\n}
@echo 正在连接服务器
for /f "tokens=1 delims=," %%i in ('%curl% -0 -s %rootapi%?deviceinfo^=%deviceinfo%') do set rootmethod=%%i
for /f "tokens=2 delims=," %%i in ('%curl% -0 -s %rootapi%?deviceinfo^=%deviceinfo%') do set methoddesc=%%i
for /f "tokens=3 delims=," %%i in ('%curl% -0 -s %rootapi%?deviceinfo^=%deviceinfo%') do set rootfileurl=%%i
for /f "tokens=4 delims=," %%i in ('%curl% -0 -s %rootapi%?deviceinfo^=%deviceinfo%') do set rootfilemd5=%%i
if defined rootmethod (
goto rootbynet_stp2
) else (
@echo.
%cecho% {0E}WARN{0F}无法连接服务器，请检查网络或服务器状态{#}{\n}
@echo.
@echo 你也可以主界面输入Y联系作者远程协助
@echo.
@echo 现在按任意键回到主界面
pause >nul
goto complete
)
:rootbynet_stp2
if %rootmethod%==1 (
%cecho% {0A}PASS{#}{\n}
@echo 正在从云端获取适用于【%methoddesc%】的ROOT方案
goto quickroot
) else if %rootmethod%==2 (
%cecho% {0A}PASS{#}{\n}
@echo 将执行适用于【%methoddesc%】的ROOT方案
goto rootwithbootimg
) else if %rootmethod%==3 (
%cecho% {0A}PASS{#}{\n}
@echo 将执行适用于【%methoddesc%】的ROOT方案
goto rootwithinitbootimg
) else if %rootmethod%==0 (
%cecho% {0C}WARN{0F}本工具箱因有风险不支持此机型或系统{#}{\n}
@echo
goto complete
) else (
@echo.
%cecho% {0E}WARN{0F}服务器未查询到匹配的ROOT方案{#}{\n}
@echo.
@echo 你可以主界面输入Y联系作者远程协助
@echo.
@echo 现在按任意键回到主界面
pause >nul
goto complete
)
:quickroot
del /Q daxiaamu\temp\root.img >nul 2>nul
set downloadinfo=
@%aria2% -d daxiaamu\temp -o root.img %rootfileurl% -x8 -s8 --allow-overwrite=true --summary-interval=0 -Vtrue --checksum=md5=%rootfilemd5% --check-certificate=false --console-log-level=error --disable-ipv6
set downloadinfo=%errorlevel%
if %downloadinfo%==0 (
%cecho% {0A}PASS{#}{\n}
goto quickroot2
) else (
@echo.
%cecho% {0C}ERROR{0F}下载失败,请检查您的网络并确保网络稳定{#}{\n}
@echo.
@echo 按任意回到主界面
pause >nul
goto complete
)
:quickroot2
@echo 正在安装Magisk APP，手机端如有提示，请按提示继续操作
@%adb% uninstall com.topjohnwu.magisk >nul
timeout /T 2 /NOBREAK >nul
@%adb% shell mkdir -p /data/local/tmp >nul
@%adb% push daxiaamu\magisk.apk /data/local/tmp/magisk.apk >nul
@%adb% shell <daxiaamu\installmagisk.sh >nul
timeout /T 2 /NOBREAK >nul
%cecho% {0A}PASS{#}{\n}
@echo Magisk APP安装完成，正在进入Fastboot模式
call:rebootbootloader
call:regetbootloader
%cecho% {0A}PASS{#}{\n}
@echo 已进入Fastboot模式，正在检测解锁状态
call:chkunlock
%cecho% {0A}PASS{#}{\n}
@echo 手机Bootloader已解锁，正在执行root命令
@%fastboot% boot daxiaamu\temp\root.img >nul 2>nul
@echo.
@echo 大约30秒至1分钟左右，手机会自动重启开机，期间请勿触碰手机
@echo.
@echo 最后一步，这需要你按照弹出的网页中的教程，在手机上操作
call :Countdown "5" "打开网页"
call :OpenUrl "https://optool.daxiaamu.com/magisk_installing?src=root"
@echo.
@%cecho% {00}{0A}工具箱主界面输入Q进群交流{#}{\n}
@echo.
@echo 按任意键结束
pause >nul
goto complete
:installmagiskmgr
@%adb% push daxiaamu\magisk.apk /data/local/tmp/magisk.apk >nul
@%adb% shell <daxiaamu\installmagisk.sh >nul
@%adb% install daxiaamu\magisk.apk >nul 2>nul
@%adb% shell pm list packages com.topjohnwu.magisk | findstr /C:"com.topjohnwu.magisk" >nul 2>nul
if %errorlevel%==0 goto :eof
@echo.
%cecho% {0E}WARN{0F}安装失败，正在重试{#}{\n}
@echo.
@echo 请注意观察手机提示，安装magisk app
@%adb% am force-stop com.android.packageinstaller >nul 2>nul
timeout /T 1 /NOBREAK >nul
goto :installmagiskmgr
:help
@echo on
rem cls
call:showdaxiaamu
call :OpenUrl "https://optool.daxiaamu.com/wiki_pctool?src=box"
call :Countdown "6" "回到主界面"
rem cls
goto start
:qgroup
@echo on
rem cls
call:showdaxiaamu
call :OpenUrl "https://optool.daxiaamu.com/join_group?src=box"
call :Countdown "6" "回到主界面"
rem cls
goto start
:hezi
@echo on
rem cls
call:showdaxiaamu
call :OpenUrl "https://optool.daxiaamu.com/oplusbox?src=box"
call :Countdown "6" "回到主界面"
rem cls
goto start
:exit
@echo on
rem cls
@echo.
call:showdaxiaamu
@echo.
@echo 感谢使用，工具箱主界面输入Q进群交流
call:clean
call:clearadb
taskkill /f /t /im choice32.exe >nul 2>nul
taskkill /f /t /im cecho.exe >nul 2>nul
taskkill /f /t /im choice64.exe >nul 2>nul
taskkill /f /t /im romunpack.exe >nul 2>nul
call :Countdown "5" "程序会自动关闭"
exit
:quicktoedl
@echo on
rem cls
call:devices
if %status%==0 call:nodevice
if %status%==1 (
call:systemedl
)
if %status%==2 (
call:systemedl
)
if %status%==3 (
@echo.
@echo 大部分设备都不支持从fastboot进入EDL（高通9008线刷/MTK深刷模式），建议从开机状态使用本功能
@echo.
@echo 如果你已经无法开机，可以在工具箱主界面输入Y联系作者远程协助
@echo.
@echo 正在尝试重启设备到EDL模式
@%fastboot% reboot emergency >nul
)
@echo.
@echo 操作完成
@echo.
@echo 如需退出高通线刷模式，根据不同的机型，你可以
@echo.
@echo 1）一直按住音量上和电源键；2）一直按住电源键（老机型）
@echo.
@echo 按任意键回到主界面
pause >nul
goto complete
:systemedl
@echo.
@echo 正在重启设备到EDL（高通9008线刷/MTK深刷模式）
@%adb% shell reboot edl >nul
set menuoption=%errorlevel%
if %menuoption% NEQ 0 (
@%adb% reboot edl>nul 2>nul
goto :eof
)
goto :eof
:quicktosystem
@echo on
rem cls
call:devices
if %status%==1 (
call:systemreboot
goto complete
)
if %status%==2 (
call:systemreboot
goto complete
)
if %status%==3 goto fastbootreboot
if %status%==0 call:nodevice
:quicktorecovery
@echo on
rem cls
call:devices
if %status%==1 (
@echo.
@echo 当前为开机状态
call:rebootrecovery
goto complete
)
if %status%==2 (
@echo.
@echo 当前为Recovery模式
call:rebootrecovery
goto complete
)
if %status%==3 (
@echo.
@echo 当前为Fastboot模式
@echo.
@echo 正在尝试进入Recovery模式，部分机型可能不支持这样直接进入Recovery
@echo.
@echo 你也可以在Fastboot模式下按音量键切换到Recovery mode，然后按电源键手动进入
%fastboot% reboot recovery >nul
@echo.
@echo 按任意键回到主界面
pause >nul
goto complete
)
if %status%==0 call:nodevice
:quicktofastboot
@echo on
rem cls
call:devices
if %status%==1 (
@echo.
@echo 当前为开机状态，正在进入Fastboot
call:rebootbootloader
goto complete
)
if %status%==2 (
@echo.
@echo 当前为Recovery模式，正在进入Fastboot
call:rebootbootloader
goto complete
)
if %status%==3 (
@echo.
@echo 当前为Fastboot模式，正在重新进入Fastboot
goto fastbootrebootbootloader
)
if %status%==0 call:nodevice
:main
%cecho% {0F}          ***************************************************          {#}{\n}
%cecho% {0F}          {0B}             大侠阿木一加全能工具箱                  {#}{\n}
if %versionoutdated%==1 (
%cecho% {0F}          {0C}         【当前不是最新版，请及时更新！】{#}{\n}
)
%cecho% {0F}           {0F}%versioncode%%versiondiscription%{0B} ^| {0F}%versiondate%{0B} ^| {0F}%author%{#}{\n}
%cecho% {0F}          ***************************************************          {#}{\n}
@echo.
%cecho% {00}     {0E}主要功能{#}{\n}
@echo.
%cecho% {0F}         {0A}0，官网：【教程】【注意事项】【异常处理】{#}
if %versionoutdated%==1 (
%cecho% {0A}【下载新版本】{#}
)
%cecho% {\n}
@echo.
%cecho% {0F}         1，安装驱动（首次使用需要执行）{#}{\n}
@echo.
%cecho% {0F}         2，一键解锁Bootloader（Root前必须执行）{#}{\n}
@echo.
%cecho% {0F}         3，超级一键Root Magisk{0A}{#}{\n}
@echo.
%cecho% {0F}         4，A/B槽切换（慎重，手机变砖时可试）{0A}{#}{\n}
@echo.
%cecho% {0F}         5，禁用/恢复系统更新（支持欧加真，免Root）{0A}{#}{\n}
@echo.
%cecho% {0F}         6，任意应用双开（无需Root）{0A}{#}{\n}
@echo.
%cecho% {0F}         7，安装Play市场（解决手机端直接安装失败的问题）{0A}{#}{\n}
@echo.
%cecho% {0F}         8，** 一键上锁Bootloader **（慎重）{0A}{#}{\n}
@echo.
%cecho% {0F}         9，OPLUS盒子APP（手机端必备）{0A}{#}{\n}
@echo.
%cecho% {0F}         {0A}P，专家ROOT模式{#}{\n}
@echo.
%cecho% {0F}         T，批量安装APK和模块{0A}{#}{\n}
@echo.
%cecho% {00}     {0E}快捷重启{#}{\n
@echo.
%cecho% {0F}         U，重启  V，Recovery  W，Fastboot R，EDL{#}{\n}
@echo.
%cecho% {00}     {0E}其它功能{#}{\n
@echo.
%cecho% {00}         {0E}Q，QQ频道   Y，远程刷机救砖   X，退出   A，ADB控制台{#}{\n}
@echo.
%cecho% {0F}***********************************************************************{#}{\n}
goto :eof
:checknewversion
@echo.
@echo                           正在检查更新
for /f "delims=" %%a in ('%curl% -s %UpdateApiUrl% ^| %jq% -r .version') do set version=%%a
if "%version%" gtr "%versioncode%" (
call:hasnewver
rem cls
set versionoutdated=1
goto start
)
set versionoutdated=0
goto :eof
:hasnewver
for /f "delims=" %%a in ('%curl% -s %UpdateApiUrl% ^| %jq% -r .release_date') do set release_date=%%a
for /f "delims=" %%a in ('%curl% -s %UpdateApiUrl% ^| %jq% -r .downpage_url') do set downpage_url=%%a
for /f "delims=" %%a in ('%curl% -s %UpdateApiUrl% ^| %jq% -r .downfile_url') do set downfile_url=%%a
for /f "delims=" %%a in ('%curl% -s %UpdateApiUrl% ^| %jq% -r .file_md5') do set file_md5=%%a
@echo.
%cecho% {0A}发现新版本%version%（%release_date%）{#}{\n}
@echo.
%cecho% {0A}更新内容{#}{\n}
@echo.
for /f "delims=" %%a in ('%curl% -s %UpdateApiUrl% ^| %jq% -r .changelog ^| %iconv% -f UTF-8 -t GBK' )  do (
%cecho% {0A}%%a{#}{\n}
)
@echo.
@echo 1，自动更新；2，打开网页手动下载；3，不更新（不推荐）
@echo.
%CHOICE% /c 123 /n /M 请输入选项：
set UserChoice=%errorlevel%
if %UserChoice%==1 (
@echo.
@echo 请稍候，正在自动下载更新
call :getnewfile
) else if %UserChoice%==2 (
@echo.
@echo 请手动下载新版本
call :OpenUrl %downpage_url%
call :Countdown "5" "程序会自动关闭"
exit
)
@echo.
@echo 你选择了不更新，使用旧版可能会遇到潜在问题，请谨慎使用
@echo.
@echo 按任意键继续
pause >nul
goto:eof
:getnewfile
set downloadinfo=
@%aria2% -d %currentdir% -o 一加全能工具箱%version%.exe %downfile_url% -x8 -s8 --allow-overwrite=true --summary-interval=0 -Vtrue --checksum=md5=%file_md5% --check-certificate=false --console-log-level=error --disable-ipv6
set downloadinfo=%errorlevel%
if %downloadinfo%==0 (
@echo.
%cecho% {0A}下载完成{#}{\n}
call :Countdown "5" "自动启动一加全能工具箱%version%"
start %currentdir%\一加全能工具箱%version%.exe && exit
)
@echo.
@echo 下载失败
del /q %currentdir%\一加全能工具箱%version%.exe
@echo.
@echo 请手动下载新版本
call :OpenUrl %downpage_url%
call :Countdown "5" "程序会自动关闭"
exit
:chose
%CHOICE% /c 0123456789UVWRQYPTAX /n /M 请输入功能对应数字或字母:
set UserChoice=%errorlevel%
if %UserChoice%==1 goto help
if %UserChoice%==2 goto install_driver
if %UserChoice%==3 goto unlock_bootloader
if %UserChoice%==4 goto rootbynet
if %UserChoice%==5 goto switchslot
if %UserChoice%==6 goto disableupgrade
if %UserChoice%==7 goto parallel
if %UserChoice%==8 goto play
if %UserChoice%==9 goto relock_bootloader
if %UserChoice%==10 goto hezi
if %UserChoice%==11 goto quicktosystem
if %UserChoice%==12 goto quicktorecovery
if %UserChoice%==13 goto quicktofastboot
if %UserChoice%==14 goto quicktoedl
if %UserChoice%==15 goto qgroup
if %UserChoice%==16 goto yuancheng
if %UserChoice%==17 goto premium_root
if %UserChoice%==18 goto superadb
if %UserChoice%==19 goto superadb
if %UserChoice%==20 goto exit
goto :eof
:rootwithbootimg
@echo.
%cecho% {0F}***********************************************************************{#}{\n}
@echo.
@echo 1. 接下来的ROOT过程，需要你准备一个ROM包（通常是指全量升级包）
@echo.
@echo 2. 理论上，你下载的包需要和你手机当前系统完全一致（或者理解为同一个系统包）
@echo.
@echo 3. 以下版本号提取自你的手机，供你下载ROM包时参考
@echo.
for /f "delims=" %%i in ('@%adb% shell getprop ro.build.display.id') do set a=%%i
@%cecho% ro.build.display.id：【{00}{0A}%a%{#}】{\n}
for /f "delims=" %%i in ('@%adb% shell getprop ro.rom.version') do set a=%%i
@%cecho% ro.rom.version：【{00}{0A}%a%{#}】{\n}
@echo.
@echo 4. 如果ROM和当前系统不一致，则将无法ROOT成功或更严重的后果
@echo.
@echo 5. 一加机型rom地址：op.daxiaamu.com，小米机型rom地址：xiaomirom.com、mifirm.net，当然你也可以自己找
@echo.
@echo 6. 如果你无法找到需要的文件，也可以工具箱主界面输入Y联系作者来ROOT
call:choosezip
if not exist daxiaamu\temp\boot.img (
call:dumpfailed
@echo.
@echo 你可以主界面输入Y联系作者远程协助
call:clean
@echo.
@echo 也可以按任意键重试
pause >nul
rem cls
goto rootwithbootimg
)
call:dumpspeed %starttime%
%cecho% {0A}PASS{#}{\n}
@echo 提取boot.img成功！正在重新连接设备
%adb% wait-for-device
call:chkshell
%cecho% {0A}PASS{#}{\n}
@echo 正在对boot.img进行Patch
@%adb% shell rm -rf /data/local/tmp/* >nul 2>nul
@%adb% push daxiaamu\magisk.apk /data/local/tmp/magisk.apk >nul 2>nul
@%adb% shell mkdir /data/local/tmp/magisk >nul 2>nul
@%adb% shell unzip -o /data/local/tmp/magisk.apk -d /data/local/tmp/magisk >nul 2>nul
@%adb% shell mv /data/local/tmp/magisk/lib/arm64-v8a/libbusybox.so /data/local/tmp/magisk/assets/busybox >nul 2>nul
@%adb% shell mv /data/local/tmp/magisk/lib/arm64-v8a/libmagisk64.so /data/local/tmp/magisk/assets/magisk64 >nul 2>nul
@%adb% shell mv /data/local/tmp/magisk/lib/armeabi-v7a/libmagisk32.so /data/local/tmp/magisk/assets/magisk32 >nul 2>nul
@%adb% shell mv /data/local/tmp/magisk/lib/arm64-v8a/libmagiskboot.so /data/local/tmp/magisk/assets/magiskboot >nul 2>nul
@%adb% shell mv /data/local/tmp/magisk/lib/arm64-v8a/libmagiskinit.so /data/local/tmp/magisk/assets/magiskinit >nul 2>nul
@%adb% shell mv /data/local/tmp/magisk/lib/arm64-v8a/libmagiskpolicy.so /data/local/tmp/magisk/assets/magiskpolicy >nul 2>nul
@%adb% shell chmod 777 -R /data/local/tmp/magisk/ >nul 2>nul
@%adb% push daxiaamu\temp\boot.img /data/local/tmp/boot.img >nul 2>nul
del /Q daxiaamu\temp\boot.img
@%adb% shell getprop ro.crypto.state |findstr /C:"encrypted"  >nul 2>nul
if %errorlevel%==0 (
@%adb% shell echo "KEEPVERITY=true>/data/local/tmp/root.sh" >nul 2>nul
@%adb% shell echo "KEEPFORCEENCRYPT=true>>/data/local/tmp/root.sh" >nul 2>nul
@%adb% shell echo "export KEEPVERITY>>/data/local/tmp/root.sh" >nul 2>nul
@%adb% shell echo "export KEEPFORCEENCRYPT>>/data/local/tmp/root.sh" >nul 2>nul
@%adb% shell echo "/data/local/tmp/magisk/assets/boot_patch.sh /data/local/tmp/boot.img>>/data/local/tmp/root.sh"  >nul 2>nul
@%adb% shell chmod 755 /data/local/tmp/root.sh  >nul 2>nul
@%adb% shell sh /data/local/tmp/root.sh >nul 2>nul
) else (
%adb% shell /data/local/tmp/magisk/assets/boot_patch.sh /data/local/tmp/boot.img >nul 2>nul
)
%adb% pull /data/local/tmp/magisk/assets/new-boot.img daxiaamu\temp\boot.img >nul 2>nul
@%adb% shell rm -rf /data/local/tmp/*  >nul 2>nul
if not exist daxiaamu\temp\boot.img (
@echo.
@echo boot.img文件patch失败！
@echo.
@echo 你可以主界面输入Y联系作者远程协助
call:clean
@echo.
@echo 也可以按任意键重试
pause >nul
rem cls
goto rootwithbootimg
)
%cecho% {0A}PASS{#}{\n}
@echo boot.img文件Patch完成，正在安装Magisk APP，请注意手机端提示
call:installmagiskmgr
timeout /T 2 /NOBREAK >nul
%cecho% {0A}PASS{#}{\n}
@echo Magisk APP安装完成，正在进入Fastboot模式
call:rebootbootloader
call:regetbootloader
%cecho% {0A}PASS{#}{\n}
@echo 已进入fastboot模式，正在检测解锁状态
call:chkunlock
%cecho% {0A}PASS{#}{\n}
@echo 手机bootloader已解锁，正在刷入SuperBoot
@%fastboot% flash boot daxiaamu\temp\boot.img >nul 2>nul
@%fastboot% reboot >nul 2>nul
%cecho% {0A}PASS{#}{\n}
@echo 手机会自动重启开机，期间请勿触碰手机
%cecho% {0A}PASS{#}{\n}
@echo 最后一步，这需要你按照弹出的网页中的教程，在手机上操作
timeout /T 5 /NOBREAK >nul
start https://optool.daxiaamu.com/magisk_installing?src=root
@echo.
@%cecho% {00}{0A}工具箱主界面输入Q进群交流{#}{\n}
@echo.
@echo 按任意键结束
pause >nul
goto complete
:rootwithinitbootimg
@echo.
@echo 1. 接下来的ROOT过程，需要你准备一个ROM包（通常是指全量升级包）
@echo.
@echo 2. 理论上，你下载的包需要和你手机当前系统完全一致（或者理解为同一个系统包）
@echo.
@echo 3. 以下版本号提取自你的手机，供你下载ROM包时参考
@echo.
for /f "delims=" %%i in ('@%adb% shell getprop ro.build.display.id') do set a=%%i
@%cecho% ro.build.display.id：【{00}{0A}%a%{#}】{\n}
for /f "delims=" %%i in ('@%adb% shell getprop ro.rom.version') do set a=%%i
@%cecho% ro.rom.version：【{00}{0A}%a%{#}】{\n}
@echo.
@echo 4. 如果ROM和当前系统不一致，则将无法ROOT成功或更严重的后果
@echo.
@echo 5. 一加机型rom地址：op.daxiaamu.com，小米机型rom地址：xiaomirom.com、mifirm.net，当然你也可以自己找
@echo.
@echo 6. 如果你无法找到需要的文件，也可以工具箱主界面输入Y联系作者来ROOT
call:choosezip
if not exist daxiaamu\temp\init_boot.img (
call:dumpfailed
@echo.
@echo 你可以主界面输入Y联系作者远程协助
call:clean
@echo.
@echo 也可以按任意键重试
pause >nul
rem cls
goto rootwithinitbootimg
)
call:dumpspeed %starttime%
%cecho% {0A}PASS{#}{\n}
@echo 正在连接设备，首次连接时手机上可能会出现弹窗，请注意打钩点允许
%adb% wait-for-device
call:chkshell
%cecho% {0A}PASS{#}{\n}
@echo 正在对init_boot.img进行Patch
@%adb% shell rm -rf /data/local/tmp/* >nul 2>nul
@%adb% push daxiaamu\magisk.apk /data/local/tmp/magisk.apk >nul 2>nul
@%adb% shell mkdir /data/local/tmp/magisk >nul 2>nul
@%adb% shell unzip -o /data/local/tmp/magisk.apk -d /data/local/tmp/magisk >nul 2>nul
@%adb% shell mv /data/local/tmp/magisk/lib/arm64-v8a/libbusybox.so /data/local/tmp/magisk/assets/busybox >nul 2>nul
@%adb% shell mv /data/local/tmp/magisk/lib/arm64-v8a/libmagisk64.so /data/local/tmp/magisk/assets/magisk64 >nul 2>nul
@%adb% shell mv /data/local/tmp/magisk/lib/armeabi-v7a/libmagisk32.so /data/local/tmp/magisk/assets/magisk32 >nul 2>nul
@%adb% shell mv /data/local/tmp/magisk/lib/arm64-v8a/libmagiskboot.so /data/local/tmp/magisk/assets/magiskboot >nul 2>nul
@%adb% shell mv /data/local/tmp/magisk/lib/arm64-v8a/libmagiskinit.so /data/local/tmp/magisk/assets/magiskinit >nul 2>nul
@%adb% shell mv /data/local/tmp/magisk/lib/arm64-v8a/libmagiskpolicy.so /data/local/tmp/magisk/assets/magiskpolicy >nul 2>nul
@%adb% shell chmod 755 -R /data/local/tmp/magisk/ >nul 2>nul
@%adb% push daxiaamu\temp\init_boot.img /data/local/tmp/init_boot.img >nul 2>nul
del /Q daxiaamu\temp\init_boot.img
@%adb% shell sh /data/local/tmp/magisk/assets/boot_patch.sh /data/local/tmp/init_boot.img>nul 2>nul
@%adb% pull /data/local/tmp/magisk/assets/new-boot.img daxiaamu\temp\init_boot.img >nul 2>nul
@%adb% shell rm -rf /data/local/tmp/* >nul 2>nul
if not exist daxiaamu\temp\init_boot.img (
@echo.
%cecho% {0C}ERROR{0F}init_boot.img文件Patch失败！{#}{\n}
@echo.
@echo 你可以主界面输入Y联系作者远程协助
call:clean
@echo.
@echo 也可以按任意键重试
pause >nul
rem cls
goto rootwithinitbootimg
)
%cecho% {0A}PASS{#}{\n}
@echo init_boot.img文件Patch完成，正在安装Magisk APP，请注意手机端提示
call:installmagiskmgr
timeout /T 2 /NOBREAK >nul
%cecho% {0A}PASS{#}{\n}
@echo Magisk APP安装完成，正在进入Fastboot模式
call:rebootbootloader
call:regetbootloader
%cecho% {0A}PASS{#}{\n}
@echo 已进入fastboot模式，正在检测解锁状态
call:chkunlock
%cecho% {0A}PASS{#}{\n}
@echo 手机bootloader已解锁，正在刷入SuperBoot
@%fastboot% flash init_boot daxiaamu\temp\init_boot.img >nul 2>nul
@%fastboot% reboot >nul 2>nul
%cecho% {0A}PASS{#}{\n}
@echo 手机会自动重启开机，期间请勿触碰手机
%cecho% {0A}PASS{#}{\n}
@echo 最后一步，这需要你按照弹出的网页中的教程，在手机上操作
timeout /T 5 /NOBREAK >nul
start https://optool.daxiaamu.com/magisk_installing?src=root
@echo.
@%cecho% {00}{0A}工具箱主界面输入Q进群交流{#}{\n}
@echo.
@echo 按任意键结束
pause >nul
goto complete
:premium_root
rem cls
@echo.
@echo 注意事项：
@echo.
@echo    1. 本功能为通用一键Root，限专家用户使用
@echo.
@echo    2. 由于不强制校验机型和系统，因此本功能适用于更多机型，但同时也会因为某些错误情况下刷入后导致异常甚至变砖
@echo.
@echo    3. 因此要使用本功能，请遵循一个原则：【要么你确定能用，要么责任自负】
@echo.
@echo    4. 当然本功能作者会通过严格设计的ROOT流程和充分的测试来尽力确保功能正常运行，保证不会主观上故意创造或遗留bug
@echo.
@echo    5. 如果你对以上说明感到无措或疑惑，请不要使用本功能，建议你主界面输入Y联系作者远程协助
@echo.
%CHOICE% /c yx /n /M 输入y继续，如果需要退出本功能，请输入X：
set menuoption=%errorlevel%
if %menuoption%==2 (
rem cls
@echo.
@echo 你选择了退出ROOT流程
goto complete
)
@echo.
@echo 正在联网获取ROOT方案列表
@echo.
@%curl% -fsSL "%premium_root_api%" -o "%premium_root_json_file%"  >nul 2>nul
if errorlevel 1 (
%cecho% {0C}ERROR{0F}下载失败，请检查您的网络，按任意键重试{#}{\n}
pause >nul
goto premium_root
)
for /f "delims==" %%v in ('set item[ 2^>nul') do set "%%v="
setlocal enabledelayedexpansion
rem cls
@echo.
@echo 【可选ROOT方案】
set i=0
for /f "tokens=1,* delims=:" %%a in ('%jq% -r "to_entries[] | .key + \":\" + .value.version" "%premium_root_json_file%"') do (
set /a i+=1
set "item[!i!]=%%a"
@echo.
%cecho% [!i!] {0A}%%a {0F}[%%b]{#}{\n}
)
:retry
echo.
set /p "choice=请输入数字并回车 (1-%i%): "
echo.
if not defined item[%choice%] (
echo 错误：无效输入！请重新输入
goto retry
)
rem cls
echo 你选择了: !item[%choice%]!
set "method=!item[%choice%]!
for /f "delims=" %%A in ('%jq% -r ".\"%method%\".apk_url" "%premium_root_json_file%"') do set "apk_url=%%A"
for /f "delims=" %%A in ('%jq% -r ".\"%method%\".apk_md5" "%premium_root_json_file%"') do set "apk_md5=%%A"
for /f "delims=" %%A in ('%jq% -r ".\"%method%\".script_url" "%premium_root_json_file%"') do set "script_url=%%A"
for /f "delims=" %%A in ('%jq% -r ".\"%method%\".script_md5" "%premium_root_json_file%"') do set "script_md5=%%A"
for /f "delims=" %%A in ('%jq% -r ".\"%method%\".version" "%premium_root_json_file%"') do set "root_version=%%A"
for /f "delims=" %%A in ('%jq% -r ".\"%method%\".afterroot" "%premium_root_json_file%"') do set "afterroot=%%A"
for /f "delims=" %%A in ('%jq% -r ".\"%method%\".note" "%premium_root_json_file%" ^| %iconv% -f UTF-8 -t GBK') do set "note=%%A"
del /Q daxiaamu\temp\premium_root.json
echo !apk_url!>daxiaamu\temp\apk_url
echo !apk_md5!>daxiaamu\temp\apk_md5
echo !script_url!>daxiaamu\temp\script_url
echo !script_md5!>daxiaamu\temp\script_md5
echo !root_version!>daxiaamu\temp\root_version
echo !afterroot!>daxiaamu\temp\afterroot
echo !note!>daxiaamu\temp\note
echo !method!>daxiaamu\temp\method
endlocal
set /p apk_url=<daxiaamu\temp\apk_url
set /p apk_md5=<daxiaamu\temp\apk_md5
set /p script_url=<daxiaamu\temp\script_url
set /p script_md5=<daxiaamu\temp\script_md5
set /p root_version=<daxiaamu\temp\root_version
set /p afterroot=<daxiaamu\temp\afterroot
set /p note=<daxiaamu\temp\note
set /p method=<daxiaamu\temp\method
del /Q daxiaamu\temp\apk_url >nul 2>nul
del /Q daxiaamu\temp\apk_md5 >nul 2>nul
del /Q daxiaamu\temp\script_url >nul 2>nul
del /Q daxiaamu\temp\script_md5 >nul 2>nul
del /Q daxiaamu\temp\root_version >nul 2>nul
del /Q daxiaamu\temp\afterroot >nul 2>nul
del /Q daxiaamu\temp\note >nul 2>nul
del /Q daxiaamu\temp\method >nul 2>nul
@echo.
@echo #############################说明信息###################################
@echo.
echo %note%
@echo.
@echo ########################################################################
@echo.
%CHOICE% /c yx /n /M 输入y继续，如果需要退出本功能，请输入X：
set menuoption=%errorlevel%
if %menuoption%==2 (
rem cls
@echo.
@echo 你选择了退出ROOT流程
goto complete
)
rem cls
@echo.
@echo 正在连接设备，首次连接时手机上可能会出现弹窗，请注意打钩点允许
%adb% wait-for-device >nul 2>nul
rem cls
@echo.
@echo 设备已连接，正在检测运行环境
@%adb% shell "echo daxiaamu >/data/local/tmp/check && cat /data/local/tmp/check | grep -q daxiaamu && rm /data/local/tmp/check" >nul 2>nul
if %errorlevel% neq 0 (
@echo.
%cecho% {0C}ERROR{0F}程序无法继续运行，请将手机进行恢复出厂设置或格式化后再重试{#}{\n}
@echo.
@echo 按任意键回到主界面
pause >nul
goto complete
)
%cecho% {0A}PASS{#}{\n}
@echo.
@echo #############################准备工作###################################
@echo.
@echo 1. 接下来的ROOT过程，需要你准备一个ROM包（通常是指升级全量包）
@echo.
@echo 2. 理论上，你下载的包需要和你手机当前系统完全一致（或者理解为同一个系统包）
@echo.
@echo 3. 以下版本号提取自你的手机，供你下载ROM包时参考
@echo.
for /f "delims=" %%i in ('@%adb% shell getprop ro.build.display.id') do set ro.build.display.id=%%i
@%cecho% ro.build.display.id：【{00}{0A}%ro.build.display.id%{#}】{\n}
for /f "delims=" %%i in ('@%adb% shell getprop ro.build.display.ota') do set ro.build.display.ota=%%i
@%cecho% ro.build.display.ota：【{00}{0A}%ro.build.display.ota%{#}】{\n}
for /f "delims=" %%i in ('@%adb% shell getprop ro.rom.version') do set ro.rom.version=%%i
@%cecho% ro.rom.version：【{00}{0A}%ro.rom.version%{#}】{\n}
@echo.
@echo 4. 如果ROM和当前系统不一致，则将可能导致各种异常或无法开机
@echo.
@echo 5. 一加机型rom地址：oplusrom.com，小米机型rom地址：xiaomirom.com、mifirm.net，当然你也可以自己找
@echo.
@echo 6. 如果你无法找到需要的文件，也可以工具箱主界面输入Y联系作者来ROOT
@echo.
@echo ########################################################################
call:choosezip
if not exist "daxiaamu\temp\boot.img" if not exist "daxiaamu\temp\init_boot.img" (
call:dumpfailed
@echo.
@echo 你可以主界面输入Y联系作者远程协助
call:clean
@echo.
@echo 也可以按任意键重试
pause >nul
rem cls
goto premium_root
)
call:dumpspeed %starttime%
%cecho% {0A}PASS{#}{\n}
@echo 正在从服务器获取最新%method%文件，版本为%root_version%
del /Q daxiaamu\temp\root.apk >nul 2>nul
set downloadinfo=
@%aria2% -d daxiaamu\temp -o root.apk %apk_url% -x8 -s8 --allow-overwrite=true --summary-interval=0 -Vtrue --checksum=md5=%apk_md5% --check-certificate=false --console-log-level=error --disable-ipv6
if %errorlevel% neq 0 (
@echo.
%cecho% {0C}ERROR{0F}下载失败,请检查您的网络并确保网络稳定{#}{\n}
@echo.
@echo 你也可以主界面输入Y联系作者的协助
call:clean
@echo.
@echo 也可以按任意键重试
pause >nul
rem cls
goto premium_root
)
@%aria2% -d daxiaamu\temp -o root.bat %script_url% -x8 -s8 --allow-overwrite=true --summary-interval=0 -Vtrue --check-certificate=false --disable-ipv6 >nul 2>nul
@%adb% shell rm -rf /data/local/tmp/* >nul 2>nul
@%adb% push daxiaamu\temp\root.apk /data/local/tmp/root.apk >nul 2>nul
call daxiaamu\temp\root.bat
del /Q daxiaamu\temp\root.bat >nul 2>nul
if not exist daxiaamu\temp\%patchfile%.img (
@echo.
%cecho% {0C}ERROR{0F} %patchfile%文件patch失败！{#}{\n}
@echo.
@echo 你也可以主界面输入Y联系作者远程协助
call:clean
@echo.
@echo 也可以按任意键重试
pause >nul
rem cls
goto premium_root
)
%cecho% {0A}PASS{#}{\n}
@echo 正在安装%method% APP，手机端如有提示，请按提示继续执行安装操作
timeout /T 2 /NOBREAK >nul
@%adb% install daxiaamu\temp\root.apk >nul
timeout /T 2 /NOBREAK >nul
%cecho% {0A}PASS{#}{\n}
@echo %method% APP安装完成，正在进入Fastboot模式
call:rebootbootloader
call:regetbootloader
%cecho% {0A}PASS{#}{\n}
@echo 已进入Fastboot模式，正在检测解锁状态
call:chkunlock
%cecho% {0A}PASS{#}{\n}
@echo 手机bootloader已解锁，正在刷入SuperBoot
@%fastboot% flash init_boot daxiaamu\temp\init_boot.img >nul 2>nul
@%fastboot% flash boot daxiaamu\temp\boot.img >nul 2>nul
@%fastboot% reboot >nul 2>nul
%cecho% {0A}PASS{#}{\n}
@echo 手机会自动重启开机，期间请勿触碰手机
call :Countdown "20" "继续下一步"
@echo.
@echo 最后一步，这需要你按照弹出的网页中的教程，在手机上操作
call :Countdown "5" "自动弹出网页"
call :OpenUrl %afterroot%
@echo.
@%cecho% {00}{0A}工具箱主界面输入Q进群交流{#}{\n}
call:clean
echo.
@echo ========================================================================
@echo                                ROOT完成！！
@echo                                干得漂亮！！
@echo ========================================================================
@echo.
@echo 按任意键结束
pause >nul
goto complete
:recheckbootimg
if exist daxiaamu\payload\output\boot.img (
set bootimg=daxiaamu\payload\output\boot.img
goto :eof
)
goto recheckbootimg
:recheckinitbootimg
if exist daxiaamu\payload\output\init_boot.img (
set bootimg=daxiaamu\payload\output\init_boot.img
goto :eof
)
goto recheckinitbootimg
:recheckvendorbootimg
if exist daxiaamu\payload\output\vendor_boot.img (
set vendorbootimg=daxiaamu\payload\output\vendor_boot.img
goto :eof
)
goto recheckvendorbootimg
:recheckvbmetaimg
if exist daxiaamu\payload\output\vbmeta.img (
set vbmetaimg=daxiaamu\payload\output\vbmeta.img
goto :eof
)
goto recheckvbmetaimg
:choosezip
set mod=
set isurl=0
del /Q daxiaamu\temp\boot.img daxiaamu\temp\init_boot.img >nul 2>nul
set starttime=""
set endtime=""
setlocal enabledelayedexpansion
@echo.
@echo 现在你可以：【将文件拖到进来并回车】或【直接输入文件路径并回车】或【直接回车选择文件】
@echo.
@echo 也可以试试手气：【直接输入文件的url】（仅消耗少量流量，不会下载整包）
@echo.
@echo 如果需要退出本功能，请输入X。
@echo.
set /p "mod=这里："
if "!mod!"=="" (
@echo.
@echo 请选择文件
call:selectfile
)
if /I "!mod!"=="X" goto complete
if "!mod:~0,7!" == "http://" (
set "mod="!mod!""
@echo.
@echo 你输入了一个URL
)
if "!mod:~0,8!" == "https://" (
set "mod="!mod!""
@echo.
@echo 你输入了一个URL
)
@echo.
@echo 正在解包文件
daxiaamu\7za.exe l !mod! | findstr /r /c:"\<init_boot.img\>" /c:"\<boot.img\>" >>daxiaamu\temp\dump.log
if %errorlevel%==0 (
daxiaamu\7za.exe x !mod! init_boot.img -odaxiaamu\temp\ >>daxiaamu\temp\dump.log
daxiaamu\7za.exe x !mod! boot.img -odaxiaamu\temp\ >>daxiaamu\temp\dump.log
endlocal
exit /b
)
for /f %%a in ('daxiaamu\timestamp.exe') do set "starttime=%%a"
echo !starttime!>daxiaamu\temp\dumpstarttime
echo !mod!>daxiaamu\temp\tmp
endlocal
set /p starttime=<daxiaamu\temp\dumpstarttime
set /p mod=<daxiaamu\temp\tmp
del /Q daxiaamu\temp\tmp
del /Q daxiaamu\temp\dumpstarttime
daxiaamu\unziponline.exe %mod% daxiaamu\temp\  >nul 2>>daxiaamu\temp\dump.log
if %errorlevel% == 0 (
exit /b
)
if %errorlevel% == 1 (
exit /b
)
if %errorlevel% == 2 (
exit /b
)
@echo.
@echo   --检测ROM文件是否匹配
for /f "tokens=2 delims==" %%i in ('daxiaamu\payload_dumper.exe --metadata %mod% ^| findstr "post-timestamp"') do set POST_TIMESTAMP=%%i
if not defined POST_TIMESTAMP (
rem cls
@echo.
%cecho% {0C}ERROR{0F} 无法获取ROM包的信息，无法继续操作，你输入的可能不是ROM文件{#}{\n}
@echo.
@echo 按任意键重新选择文件
pause >nul
goto choosezip
)
for /f "tokens=*" %%i in ('%adb% shell getprop ro.build.date.utc') do set DEVICE_TIMESTAMP=%%i
if not defined DEVICE_TIMESTAMP (
rem cls
@echo.
%cecho% {0C}ERROR{0F} 无法获取手机的版本信息，可能是连接不稳定，请务必排除{#}{\n}
@echo.
@echo 然后按任意键重新选择文件
pause >nul
goto choosezip
)
if "%POST_TIMESTAMP%" NEQ "%DEVICE_TIMESTAMP%" (
rem cls
@echo.
%cecho% {0C}ERROR{0F} 你输入的文件与手机系统不匹配，继续操作可能导致严重后果{#}{\n}
@echo.
@echo 为了安全，禁止继续操作！
@echo.
@echo 按任意键重新选择文件
pause >nul
goto choosezip
)
%cecho% {0A}PASS{#}{\n}
@echo   --正在解包...
daxiaamu\payload_dumper.exe --partitions boot,init_boot --out daxiaamu\temp\ %mod% >nul 2>>daxiaamu\temp\dump.log
exit /b
:selectfile
setlocal enabledelayedexpansion
for /f "delims=" %%i in ('daxiaamu\selectfile.exe') do (
set "mod=%%i"
@echo !mod!
)
if "!mod!"=="" (
@echo.
@echo 没有输入文件路径。请重新操作。
goto choosezip
)
echo !mod!>daxiaamu\temp\tmp
endlocal
set /p mod=<daxiaamu\temp\tmp
del /Q daxiaamu\temp\tmp
exit /b
:dumpfailed
@echo.
%cecho% {0C}ERROR{0F}文件解包失败！{#}{\n}
@echo.
@echo #############################错误日志###################################
type daxiaamu\temp\dump.log
del /Q daxiaamu\temp\dump.log
@echo ########################################################################
exit /b
:parallel
rem cls
@echo.
@echo 正在连接设备
call:devices
if %status%==2 call:nodevice
if %status%==3 call:nodevice
if %status%==0 call:nodevice
del /Q daxiaamu\temp\*.*
%adb% shell pm list users |findstr /C:"999" >nul
if %errorlevel% == 1 (
@echo.
@echo 请先到系统双开设置中双开任意应用，然后再按任意键重试
pause >nul
goto parallel
)
@echo.
@echo 正在获取应用列表，根据应用数量，大约需要30秒到1分钟时间……
%adb% push daxiaamu\aapt2 /data/local/tmp/aapt2 >nul 2>nul
%adb% shell chmod 755 /data/local/tmp/aapt2
%adb% shell pm list packages -3^| sed 's/package://' >daxiaamu\temp\packagelist.txt
for /f "delims=" %%i in (daxiaamu\temp\packagelist.txt) do (
%adb% shell pm path %%i ^| sed 's/package://' >>daxiaamu\temp\path.txt
)
for /f "delims=" %%i in (daxiaamu\temp\path.txt) do (
%adb% shell /data/local/tmp/aapt2 d badging %%i ^|grep application-label-zh-CN: ^| sed 's/application-label-zh-CN://' >daxiaamu\temp\tmp.txt 2>nul
for %%a in (daxiaamu\temp\tmp.txt) do if %%~za==0 (
%adb% shell /data/local/tmp/aapt2 d badging %%i ^|grep application-label: ^| sed 's/application-label://' >>daxiaamu\temp\namelist.txt 2>nul
) else (
%adb% shell /data/local/tmp/aapt2 d badging %%i ^|grep application-label-zh-CN: ^| sed 's/application-label-zh-CN://' >>daxiaamu\temp\namelist.txt 2>nul
)
)
type "daxiaamu\temp\namelist.txt"|findstr/n ^^ > "daxiaamu\temp\applist.txt"
findstr /v "^$" daxiaamu\temp\applist.txt >daxiaamu\temp\result.txt
%adb% push daxiaamu\temp\namelist.txt /data/local/tmp/namelist.txt >nul 2>nul
%adb% push daxiaamu\temp\result.txt /data/local/tmp/applist.txt >nul 2>nul
%adb% push daxiaamu\temp\packagelist.txt /data/local/tmp/packagelist.txt >nul 2>nul
rem cls
rem MODE CON: COLS=72 LINES=500
echo.
@echo 已安装的应用为：
echo.
%adb% shell cat /data/local/tmp/applist.txt
:chooseparallelapp
@echo.
set /p inputstr= 请输入要双开的应用序号（如需退出请输入0）：
if %inputstr%==0 (
goto complete
)
set /a inputstr1= %inputstr%*1
if not %inputstr1% == %inputstr% (
@echo.
@echo 输入错误，请重新输入
goto chooseparallelapp
)
if 0 gtr %inputstr% (
@echo.
@echo 输入错误，请重新输入
goto chooseparallelapp
)
type daxiaamu\temp\packagelist.txt | find /v /c ""  >daxiaamu\temp\tmp.txt
set /p maxlines=<daxiaamu\temp\tmp.txt
if %inputstr% gtr %maxlines% (
@echo.
@echo 输入错误，请重新输入
goto chooseparallelapp
)
@echo.
@echo [应用名]:
%adb% shell cat /data/local/tmp/namelist.txt ^| sed -n %inputstr%p
@echo [包名]:
%adb% shell cat /data/local/tmp/packagelist.txt ^| sed -n %inputstr%p
%adb% shell cat /data/local/tmp/packagelist.txt ^| sed -n %inputstr%p >daxiaamu\temp\tmp.txt
set /p package=<daxiaamu\temp\tmp.txt
%adb% shell pm install-existing --user 999 %package% >nul
if %errorlevel% == 0 goto parallesuccess
@echo.
@echo 双开失败! 你可以从主界面下载一加全能盒子，在手机上双开
pause >nul
rem cls
goto complete
:parallesuccess
@echo.
@echo 双开成功！
@echo.
@echo 请注意，因为OPPO桌面的问题，重启手机后就看不到双开的应用图标了，你需要安装第三方桌面，例如【微软桌面】。具体请酷安搜索【微软桌面】下载安装
%CHOICE% /c 12 /n /M 继续双开输入1，回到主界面输入2:
set UserChoice=%errorlevel%
if %UserChoice%==1 goto chooseparallelapp
if %UserChoice%==2 goto goto complete
:play
@echo on
rem cls
@echo.
@echo 正在检测设备状态
call:devices
if %status%==1 (
%adb% shell pm uninstall com.android.vending >nul
%adb% install -r -d daxiaamu/play.apk >nul
@echo.
@echo 安装完成！按任意键回到主界面
pause >nul
goto complete
) else (
@echo.
@echo 设备未连接！按任意键回到主界面
pause >nul
goto complete
)
:switchslot
@echo on
rem cls
@echo.
@echo 本功能适用于所有A/B分区的机型
@echo.
@echo 请在开机或Fastboot模式下使用，是否继续操作？
@echo.
%CHOICE% /c yn /n /M 请输入y或n：
if %errorlevel%==2 goto complete
@echo.
@echo 正在检测设备状态
call:devices
if %status%==1 (
call:rebootbootloader
call:regetbootloader
goto :startswitchslot
)
if %status%==2 (
call:rebootbootloader
call:regetbootloader
goto startswitchslot
)
if %status%==3 goto startswitchslot
@echo.
@echo 设备未连接！按任意键回到主界面
pause >nul
goto complete
:startswitchslot
call:getcurrentslot
if %currentslot%==A (
@echo.
@echo 当前为A槽，正在切换为B槽位
)
if %currentslot%==B (
@echo.
@echo 当前为B槽，正在切换为A槽位
)
%fastboot% --set-active=other 2>&1 | findstr /C:"Finished" >nul 2>nul
if %errorlevel%==0 (
@echo.
@echo 操作成功，按任意键回到主界面
pause >nul
goto complete
)
@echo.
@echo 操作失败，按任意键回到主界面
pause >nul
goto complete
:getcurrentslot
%fastboot% getvar current-slot 2>&1 | findstr /C:"current-slot: a" >nul 2>nul
if %errorlevel%==0 (
set currentslot=A
goto :eof
)
%fastboot% getvar current-slot 2>&1 | findstr /C:"current-slot: b" >nul 2>nul
if %errorlevel%==0 (
set currentslot=B
goto :eof
)
set currentslot=unknown
goto :eof
:disableupgrade
@echo on
rem cls
@echo.
@echo 本功能支持一加全部机型，支持氢OS、氧OS和ColorOS，
@echo.
@echo 请注意：使用本功能禁用后，只能使用本功能再次恢复，是否继续
@echo.
%CHOICE% /c yn /n /M 请输入y或n：
if %errorlevel%==2 goto complete
call:devices
call:clearadb
call:chkshell
@echo.
@echo 1，禁用   2，启用
@echo.
%CHOICE% /c 12 /n /M 请输入1或者2：
set menuoption=%errorlevel%
if %menuoption%==2 (
@echo.
@echo 正在启用系统更新
%adb% shell pm install-existing com.oneplus.opbackup >nul 2>nul
%adb% shell pm install-existing com.oppo.ota >nul 2>nul
%adb% shell pm install-existing com.oplus.ota >nul 2>nul
%adb% shell pm install-existing com.oplus.romupdate >nul 2>nul
%adb% shell pm unsuspend com.oplus.ota >nul 2>nul
%adb% shell pm unsuspend com.oplus.romupdate >nul 2>nul
%adb% shell pm enable com.android.vending/com.google.android.finsky.systemupdateactivity.SystemUpdateActivity >nul 2>nul
@echo.
@echo 系统更新已启用
)
if %menuoption%==1 (
@echo.
@echo 正在禁用系统更新
%adb% shell settings put system strong_prompt_ota 0 >nul 2>nul
%adb% shell settings put system has_new_version_to_update 0 >nul 2>nul
%adb% shell pm uninstall --user 0 com.oneplus.opbackup >nul 2>nul
%adb% shell pm uninstall --user 0 com.oppo.ota >nul 2>nul
%adb% shell pm uninstall --user 0 com.oplus.ota >nul 2>nul
%adb% shell pm uninstall --user 0 com.oplus.romupdate >nul 2>nul
%adb% shell pm suspend com.oplus.ota >nul 2>nul
%adb% shell pm suspend com.oplus.romupdate >nul 2>nul
%adb% shell pm disable com.android.vending/com.google.android.finsky.systemupdateactivity.SystemUpdateActivity >nul 2>nul
@echo.
@echo 系统更新已禁用，如需启用，必须使用本工具来启用
@echo.
@echo 您也可以在弹出的网页中查看教程来手动关闭
call :Countdown "5" "打开网页"
call :OpenUrl "https://optool.daxiaamu.com/disable_update"
)
@echo.
@echo 按任意键结束
pause >nul
goto complete
:yuancheng
rem cls
@echo.
@echo 请在弹出的网页中联系我
@echo.
@echo 如蒙信任，当不负所托！
call :Countdown "5" "打开网页"
call :OpenUrl "https://optool.daxiaamu.com/remote_rescue?src=root"
@echo.
@echo 按任意键回到主界面
@pause >nul
goto complete
:superadb
rem cls
@echo.
@echo 请使用【SuperADB Tool】，这是一个独立工具，请下载后使用
call :Countdown "5" "打开网页"
call :OpenUrl "https://optool.daxiaamu.com/super_adb?src=root"
@echo.
@echo 按任意键回到主界面
@pause >nul
goto complete
:dumpspeed
for /f %%a in ('daxiaamu\timestamp.exe') do set "endtime=%%a"
if %starttime%=="" (
goto :eof
)
if %endtime%=="" (
goto :eof
)
%curl% -s "%dumpspeedapi%?start=%starttime%^&end=%endtime%" -o daxiaamu\temp\dumpspeed.json >nul 2>nul
if not exist daxiaamu\temp\dumpspeed.json (
exit /b 1
)
set "dumpcode=0"
for /f "delims=" %%i in ('%jq% -r ".code" daxiaamu\temp\dumpspeed.json 2^>nul') do set "dumpcode=%%i"
for /f "delims=" %%i in ('%jq% -r ".result.duration" daxiaamu\temp\dumpspeed.json 2^>nul') do set "dumpduration=%%i"
for /f "delims=" %%i in ('%jq% -r ".result.overthan" daxiaamu\temp\dumpspeed.json 2^>nul') do set "dumpoverthan=%%i"
for /f "delims=" %%i in ('%jq% -r ".result.totalcount" daxiaamu\temp\dumpspeed.json 2^>nul') do set "totalcount=%%i"
del /q daxiaamu\temp\dumpspeed.json
if %dumpcode%==200 (
%cecho% {0A}PASS{#}{\n}
%cecho% 解包挑战：耗时{0A}%dumpduration%{#}毫秒，你超过了{0A}%dumpoverthan%{#}的人，这是全能工具箱本月第%totalcount%次解包{\n}
exit /b
)
:devices
@echo on
call:clearadb
%adb% devices >nul 2>nul
%adb% devices | findstr "\<device\>" >nul 2>nul
if %ERRORLEVEL%==0 (
set status=1
goto :eof
)
%adb% devices | findstr "\<recovery\>" >nul 2>nul
if %ERRORLEVEL%==0 (
set status=2
goto :eof
)
%fastboot% devices | findstr "\<fastboot\>" >nul 2>nul
if %ERRORLEVEL%==0 (
set status=3
goto :eof
)
set status=0
goto :eof
:chkunlock
@%fastboot% oem device-info 2>&1 | findstr /C:"Device unlocked: true" >nul 2>nul
if %errorlevel%==0 goto:eof
@%fastboot% getvar unlocked 2>&1 | findstr /C:"unlocked: yes" >nul 2>nul
if %errorlevel%==0 goto:eof
@echo.
@echo 您的手机未解锁
@echo.
@echo 请按任意键回到主界面，先用本工具箱解锁BootLoader
@echo.
@echo 如果你确认已经解锁过bootloader，那就是连接问题导致的，请自行排查或主界面输入Y联系作者
pause >nul
goto complete
:regetrecovery
set /a regetreccounter=0
:regetreccounter
@echo on
%adb% devices | findstr "\<recovery\>" >nul 2>nul
set menuoption=%errorlevel%
if %menuoption%==0 goto :eof
set /a regetreccounter=regetreccounter+1
timeout /T 2 /NOBREAK >nul
if %regetreccounter% NEQ 60 goto regetreccounter
@echo.
%cecho% {00} {0C}连接超时，请在打开的网页中查看解决方法{#}{\n}
@echo.
%cecho% {00} {0A}或者联系本工具作者远程操作（弹出的网页中有联系方式）{#}{\n}
call :Countdown "5" "打开网页"
call :OpenUrl "https://optool.daxiaamu.com/wiki_pctool#异常处理"
@echo.
@echo 按任意键回到主界面
pause >nul
goto complete
:regetbootloader
@echo on
set /a regetblcounter=0
@echo.
@echo 等待Fastboot模式连接中
:regetblcounter
@echo on
%fastboot% devices | findstr "\<fastboot\>" >nul 2>nul
set menuoption=%errorlevel%
if %menuoption%==0 (
call:rechkfastbootdriver
goto :eof
)
set /a regetblcounter=regetblcounter+1
timeout /T 1 /NOBREAK >nul
set /p =■<nul
if %regetblcounter% NEQ 36 goto regetblcounter
@echo.
@echo.
%cecho% {00}{0C}等待连接Fastboot模式超时{#}{\n}
@echo.
%cecho% {00}{0C}请在打开的网页中查看解决方法{#}{\n}
@echo.
%cecho% {00}{0A}或者联系本工具作者远程操作（弹出的网页中有联系方式）{#}{\n}
call :Countdown "5" "打开网页"
call :OpenUrl "https://optool.daxiaamu.com/wiki_pctool#异常处理"
@echo.
%CHOICE% /c YN /n /M 输入Y重试，或输入N结束当前操作：
if %errorlevel%==1 goto regetbootloader
goto complete
:regetdevice
@echo on
set /a regetdevicecounter=0
@echo.
@echo 等待手机连接中，请确认已经打开USB调试和传输文件，手机端可能有提示，请你打钩点允许
:regetdevicecounter
@echo on
call:devices
if %status%==1 (
goto :eof
)
set /a regetdevicecounter=regetdevicecounter+1
timeout /T 1 /NOBREAK >nul
set /p =■<nul
if %regetdevicecounter% NEQ 36 goto regetdevicecounter
@echo.
@echo.
%cecho% {00}{0C}等待手机连接超时{#}{\n}
@echo.
%cecho% {00}{0C}请在打开的网页中查看解决方法{#}{\n}
@echo.
%cecho% {00}{0A}或者联系本工具作者远程操作（弹出的网页中有联系方式）{#}{\n}
call :Countdown "5" "打开网页"
call :OpenUrl "https://optool.daxiaamu.com/wiki_pctool#异常处理"
@echo.
%CHOICE% /c YN /n /M 输入Y重试，或输入N结束当前操作：
if %errorlevel%==1 goto regetdevice
goto complete
:rechkfastbootdriver
@echo on
set rechkfastbootdrivercounter = 0
:rechkfastbootdrivercounter
%fastboot% devices | findstr "\<fastboot\>" | findstr ??????? >nul 2>nul
set menuoption=%errorlevel%
if %menuoption%==1 goto :eof
set /a rechkfastbootdrivercounter = rechkfastbootdrivercounter +1
timeout /T 2 /NOBREAK >nul
if %rechkfastbootdrivercounter% NEQ 60 goto rechkfastbootdrivercounter
@echo.
%cecho% {00} {0C}检测到Fastboot模式但无法获取设备码，驱动未正确安装{#}{\n}
@echo.
%cecho% {00} {0A}建议联系本工具作者远程操作（弹出的网页中有联系方式）{#}{\n}
call :Countdown "5" "打开网页"
call :OpenUrl "https://optool.daxiaamu.com/wiki_pctool#异常处理"
@echo.
@echo 按任意键回到主界面
pause >nul
goto complete
:nodevice
@echo.
%cecho% {00} {0C}未检测到设备，请检查{#}{\n}
@echo.
%cecho% {00} {0C}1）是否已经用数据线连接手机和电脑{#}{\n}
@echo.
%cecho% {00} {0C}2）是否已经正确安装驱动{#}{\n}
@echo.
%cecho% {00} {0C}3）请确保手机在开机状态，且已打开USB调试，且已经在手机屏幕上允许连接{#}{\n}
@echo.
%cecho% {00} {0A}由于电脑环境复杂，或系统限制（比如网吧电脑），以上方法无法解决的，你也可以在弹出的网页中联系本工具作者远程操作{#}{\n}
call :Countdown "5" "打开网页"
call :OpenUrl "https://optool.daxiaamu.com/remote_rescue?src=root"
@echo.
@echo. 按任意键回到主界面
pause >nul
rem cls
goto complete
goto :eof
:systemreboot
@echo.
@echo 正在重启设备...
@%adb% shell reboot >nul
set menuoption=%errorlevel%
if %menuoption% NEQ 0 (
@%adb% reboot >nul 2>nul
goto :eof
)
goto :eof
:fastbootreboot
@echo.
@echo 设备正在开机...
@%fastboot% reboot >nul 2>nul
goto complete
:rebootrecovery
@echo.
@echo 设备正在进入Recovery模式...
@echo.
@echo 如果设置了锁屏，请解锁屏幕后继续
@%adb% shell reboot recovery >nul
set menuoption=%errorlevel%
if %menuoption% NEQ 0 (
@%adb% reboot recovery >nul 2>nul
goto :eof
)
goto :eof
:rebootbootloader
@%adb% shell reboot bootloader >nul 2>nul
set menuoption=%errorlevel%
if %menuoption% NEQ 0 (
@%adb% reboot bootloader >nul 2>nul
goto :eof
)
goto :eof
:fastbootrebootbootloader
rem cls
@echo.
@echo 设备正在进入Fastboot模式1
@%fastboot% reboot bootloader >nul 2>nul
goto complete
:clearadb
for /f "tokens=5" %%a in ('netstat -aon ^| findstr "5037"') do (
set PID=%%a
)
if "%PID%"=="" (
exit /b
)
for /f "tokens=2" %%b in ('tasklist /fo csv /nh /fi "PID eq %PID%" ^| findstr /i "%PID%"') do (
set ProcessName=%%b
)
taskkill /pid %PID% /f >nul 2>nul
exit /b
:chkroot
@echo.
@echo 正在申请Root权限，如果手机上有弹出窗口，请点击"允许"
%adb% shell "su -c 'ls /data'" | findstr /b /C:"app" >nul 2>nul
set menuoption=%errorlevel%
if %menuoption%==0 (
set root=1
call:clearadb
goto :eof
)
set root=0
call:clearadb
goto :eof
:reconfirm
@echo.
@echo 请确认已经清楚并了解，然后输入下面的随机码表示你已经确认
:reconfirm1
call:getrandomcode
@echo.
%cecho% {00} {0f}随机码 [{0b}%randomcode%{0f}]{#}{\n}
@echo.
set /p confirm= 请输入:
if "%confirm%"=="%randomcode%" (
@echo.
@echo 输入正确！
goto :eof
)
@echo.
%cecho% {00} {0c}输入错误，请重新输入{#}{\n}
goto reconfirm1
:getrandomcode
set randomcodelenth=6
set randomcode=
set n=0
:getrandomcode1
set /a m=%random%
set /a m=m%%36+1
if %m%==1 set xy=0&goto xy
if %m%==2 set xy=1&goto xy
if %m%==3 set xy=2&goto xy
if %m%==4 set xy=3&goto xy
if %m%==5 set xy=4&goto xy
if %m%==6 set xy=5&goto xy
if %m%==7 set xy=6&goto xy
if %m%==8 set xy=7&goto xy
if %m%==9 set xy=8&goto xy
if %m%==10 set xy=9&goto xy
if %m%==11 set xy=a&goto xy
if %m%==12 set xy=b&goto xy
if %m%==13 set xy=c&goto xy
if %m%==14 set xy=d&goto xy
if %m%==15 set xy=e&goto xy
if %m%==16 set xy=f&goto xy
if %m%==17 set xy=g&goto xy
if %m%==18 set xy=h&goto xy
if %m%==19 set xy=i&goto xy
if %m%==20 set xy=j&goto xy
if %m%==21 set xy=k&goto xy
if %m%==22 set xy=m&goto xy
if %m%==23 set xy=n&goto xy
if %m%==24 set xy=o&goto xy
if %m%==25 set xy=p&goto xy
if %m%==26 set xy=q&goto xy
if %m%==27 set xy=r&goto xy
if %m%==28 set xy=s&goto xy
if %m%==29 set xy=t&goto xy
if %m%==30 set xy=u&goto xy
if %m%==31 set xy=v&goto xy
if %m%==32 set xy=w&goto xy
if %m%==33 set xy=x&goto xy
:xy
set randomcode=%randomcode%%xy%
set /a n+=1
if %n%==%randomcodelenth% goto :eof
goto getrandomcode1
:chkshell
%adb% shell echo "hello" |findstr /b /C:"hello" >nul 2>nul
if %errorlevel%==0 (
call:clearadb
goto :eof
)
rem cls
@echo.
%cecho% {00} {0C}连接失败，可能由于你连接了多个设备或连接不稳定{#}{\n}
@echo.
%cecho% {00} {0A}或者在稍后弹出的网页中联系本工具作者远程操作{#}{\n}
call :Countdown "5" "打开网页"
call :OpenUrl "https://optool.daxiaamu.com/remote_rescue?src=root"
call:clearadb
@echo.
@echo 按任意键回到主界面
pause >nul
goto complete
:clean
set unlockorrelock=
set unlocked=
set a=
set UserChoice=
set ERRORLEVEL=
set status=
set status1=
set status2=
set status3=
set hostserror1=
set hostserror2=
set hostserror3=
set hostserror4=
set hostsaction=
set sum=
set confirm=
set regetreccounter=
set regetblcounter=
set confirm=
set menuoption=
set zip=
set currentslot=
set twrpimg=
set recimg=
set maxlines=
set inputstr=
set bootimg=
set superkey=
set patchfile=
set firstapi=
set mod=
del /Q daxiaamu\temp\*.* >nul 2>nul
del /Q daxiaamu\payload\input\*.* >nul 2>nul
del /Q daxiaamu\payload\output\*.* >nul 2>nul
del /Q daxiaamu\romunpack\payload.bin >nul 2>nul
for /d %%a in ("daxiaamu\romunpack\extracted*") do (
rd /s /q "%%a" >nul 2>nul
)
goto :eof
:Countdown
@echo.
set "time=%~1"
set "note=%~2"
set 退格键=
for /l %%a in (%time% -1 1) do (
set /p =%退格键%%%a 秒后%note%<nul
ping -n 2 127.1 >nul
)
@echo.
goto :eof
:OpenUrl
set "url=%~1"
start "" "%url%"
@echo.
@echo 如果网址没有正常打开，你也可以将网址复制到浏览器来手动打开它
@echo.
@echo 网址：%url%
goto :eof
:checkconsole
rem cls
call:showdaxiaamu
tasklist /FI "IMAGENAME eq OpenConsole.exe" 2>NUL | find /I /N "OpenConsole.exe">NUL
if "%ERRORLEVEL%"=="0" (
@echo.
%cecho% {0C}【终端设置不正确】{0F}这可能会使工具箱显示内容不完整{#}{\n}
@echo.
@echo 请按弹出的网页修改Windows 系统设置
call :Countdown "5" "打开网页"
call :OpenUrl "https://optool.daxiaamu.com/wiki_pctool#异常处理"
@echo.
@echo 现在你可以按任意键打开Windows 开发者选项
pause >nul
start ms-settings:developers
@echo.
@echo 修改完成后，按任意键，工具箱将关闭自己和所有 Windows终端窗口，然后你可以手动重新打开工具箱
pause >nul
for /f "tokens=2" %%a in ('tasklist /fi "imagename eq OpenConsole.exe" ^| findstr /i "OpenConsole.exe"')  do taskkill /pid %%a /f >nul 2>nul
exit
)
goto:eof
:showdaxiaamu
@echo                  _            _
@echo               __^| ^| __ ___  _(_) __ _  __ _ _ __ ___  _   _
@echo              / _` ^|/ _` \ \/ / ^|/ _` ^|/ _` ^| '_ ` _ \^| ^| ^| ^|
@echo             ^| (_^| ^| (_^| ^|^>  ^<^| ^| (_^| ^| (_^| ^| ^| ^| ^| ^| ^| ^|_^| ^|
@echo              \__,_^|\__,_/_/\_\_^|\__,_^|\__,_^|_^| ^|_^| ^|_^|\__,_^|
goto:eof
:complete
rem cls
@echo.
call:showdaxiaamu
@echo.
@echo 正在终止进程
call:clean
call:clearadb
taskkill /f /t /im choice32.exe >nul 2>nul
taskkill /f /t /im cecho.exe >nul 2>nul
taskkill /f /t /im choice64.exe >nul 2>nul
taskkill /f /t /im unziponline >nul 2>nul
taskkill /f /t /im adb.exe >nul 2>nul
rem cls
goto start
