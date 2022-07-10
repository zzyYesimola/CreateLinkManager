@echo off
title CLFM v1.2
echo.
echo ********************************************
echo **  Create Link File Manager v1.2
echo **  by: TSN zzyyesimola@gmail.com
echo ********************************************
echo.


if "%1" == "" (
	echo No Command Line Found, You Can Use --help To Know How To Use It.
	goto end
)
if "%1" == "--help" (
	echo Print Help Messages Now.
	goto helpmsg
)
if not "%2" == "" (
	if not "%3" == "" (
		echo Create Link Start.
		echo.
		for /f "tokens=2,*" %%i in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Desktop"') do (
			set desktop=%%j
		)
		set res=%1
		set lnk=%2
		set cat=%3
		set iix=0
		set ife=%1
		set thisProcess=ok
		if "%4" == "--icon-index" (
			set iix=%5
		)
		if "%6" == "--icon-file" (
			set ife=%7
		)
		if "%3" == "${desktop}" (
			set cat="%desktop%"
		)
		goto createLink
	)
)


REM ** CREATE-LINK
:createLink
echo Creating Link...
echo [InternetShortcut] > %lnk%.url
echo URL="%res%" >> %lnk%.url
echo IconIndex=%iix% >> %lnk%.url
echo IconFile="%ife%" >> %lnk%.url

echo Copying Link...
xcopy /V /Q /R /Y "%cd%\%lnk%.url" "%cat%"
if not "%ERRORLEVEL%" == "0" (
	echo WARNING : File Copy Failed!
	set thisProcess=err
	color 04
	timeout 1 > nul
	color 0f
	timeout 1 > nul
	color 04
	timeout 1 > nul
	color
)
echo Remove Temp File...
if not "%ERRORLEVEL%" == "0" (
	echo WARNING : Temp File Remove Failed!
	set thisProcess=err
	color 04
	timeout 1 > nul
	color 0f
	timeout 1 > nul
	color 04
	timeout 1 > nul
	color
)
del /q /f "%lnk%.url"
echo.
if not "%thisProcess%" == "err" (
	echo Link Created Success.
) else (
	echo Link Create Is NOT Success.
)
goto end


REM ** HELPMSG
:helpmsg
echo.
echo Usage:
echo createLnk [ResourceName] [LinkName] [CreateAt] [..OPTION]
echo.
echo :: Options List ::
echo --icon-index=[IconIndexNumber] : Set Icon Index Number By User
echo --icon-file=[IconResourceName] £ºSet Icon Resource By User
echo --help : Print This Help Message
echo.
echo :: Important ::
echo * The Default [IconIndexNumber] = 0
echo * The Default [IconResourceName] = [ResourceName]
echo * If You Want Create A Link At The Desktop, Please Use ${desktop}
echo.
echo The Command Look Like:
echo creatLnk C:\Windows\System32\cmd.exe CommandLine C:\
echo creatLnk A:\setup.exe AppSetup ${desktop} --icon-index=3 --icon-file=A:\res\app.dll
goto end


REM ** END
:end
echo.
REM exit
@echo on
