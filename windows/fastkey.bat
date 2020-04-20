@echo off

REM constants
set ALIAS_RC=%USERPROFILE%\.aliasrc

REM doskey script
setlocal enabledelayedexpansion
for /f "delims=]" %%i in (%ALIAS_RC%) do (
	set macroname_group=%%i $*
	REM echo !macroname_group!
	doskey !macroname_group!
)
endlocal

REM clear console
REM cls
