@echo off
:: Build the icuuc and icuin dlls to forward to icu.dll

set original_directory="%cd%"
set arch=%1

echo. Got Arch: %arch%

cd %~dp0
cd ..\..\icu\icu4c\source\common
:: Not sure if we can build both architectures like this at once.
call:compile_dll icuuc
call:compile_dll icuin

cd %original_directory%

EXIT /b %ERRORLEVEL%

:compile_dll
IF %arch%==x64 set out_dir="..\..\bin64"
IF %arch%==x86 set out_dir="..\..\bin"

echo. Got Library: %~1
echo. Got Output directory: %out_dir%

:: Cleanup since last run
del cmemory.obj %~1.dll %~1.lib %~1.exp ucln_cmn.lib ucln_cmn.exp ucln_cmn.obj umutex.obj utrace.obj
:: Generate a .lib with the required forwarding rules
lib /MACHINE:%arch% /nologo /def:..\common-and-i18n\%~1.def
:: Generate a .dll with all of the implementations for dll export (implemented in ucln_cmn.cpp + deps) as well as the lib above
cl /nologo /LD /DU_COMMON_IMPLEMENTATION /DU_EXPORT_2= /DU_EXPORT= /DU_PLATFORM_HAS_WIN32_API ucln_cmn.cpp cmemory.cpp umutex.cpp utrace.cpp %~1.lib /link /def:..\common-and-i18n\%~1.def /out:%~1.dll /MACHINE:%arch% /DLL
move %~1.dll %out_dir%\%~1.dll
:goto :eof