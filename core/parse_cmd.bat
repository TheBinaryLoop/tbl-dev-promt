

if "%TBLCMD_DEBUG%" GEQ "1" @echo [DEBUG:core\%~nx0] initializaing with arguments '%*'

@REM This script will be called a second time for the -clean_env
@REM scenario.  We skip parsing the command line and simply goto
@REM env variable clean-up.
if "%TBLCMD_ARG_CLEAN_ENV%" NEQ "" goto :clean_env

set __local_parse_error=0

:parse_loop
@for /F "tokens=1,* delims= " %%a in ("%__TBLCMD_ARGS_LIST%") do (
    for /F "tokens=1,2 delims==" %%1 in ("%%a") do (
        if "%TBLCMD_DEBUG%" GEQ "2" (
            @echo [DEBUG:parse_cmd] inner argument {%%1, %%2}
        )
        call :parse_arg_inner %%1 %%2
    )
    set "__TBLCMD_ARGS_LIST=%%b"
    goto :parse_loop
)

if "%TBLCMD_DEBUG%" GEQ "2" (
    @echo [DEBUG:parse_cmd] -no_ext : %__TBLCMD_ARG_NO_EXT%
    @echo [DEBUG:parse_cmd] -winsdk : %__TBLCMD_ARG_WINSDK%
    @echo [DEBUG:parse_cmd] -app_platform : %__TBLCMD_ARG_APP_PLAT%
    @echo [DEBUG:parse_cmd] -test   : %__TBLCMD_ARG_TEST%
    @echo [DEBUG:parse_cmd] -help   : %__TBLCMD_ARG_HELP%
    @echo [DEBUG:parse_cmd] -arch   : %__TBLCMD_ARG_TGT_ARCH%
    @echo [DEBUG:parse_cmd] -host_arch : %__TBLCMD_ARG_HOST_ARCH%
    @echo [DEBUG:parse_cmd] -vcvars_ver : %__TBLCMD_ARG_VCVARS_VER%
)

@REM Always set help variable
set "TBLCMD_ARG_help=%__TBLCMD_ARG_HELP%"
if "%__TBLCMD_ARG_HELP%" NEQ "" goto :print_help

goto :export_variables

@REM ------------------------------------------------------------------------
:parse_arg_inner
set __local_arg_found=

@REM First part (or only part) of an argument pair.
@REM Note: these are ordered alphabetically

@REM -- /? --
if /I "%1"=="-?" (
    set "__TBLCMD_ARG_HELP=1"
    set "__local_arg_found=1"
)
if /I "%1"=="/?" (
    set "__TBLCMD_ARG_HELP=1"
    set "__local_arg_found=1"
)

@REM -- /app_platform={platform} --
if /I "%1"=="-app_platform" (
    set "__TBLCMD_ARG_APP_PLAT=%2"
    set "__local_arg_found=1"
)
if /I "%1"=="/app_platform" (
    set "__TBLCMD_ARG_APP_PLAT=%2"
    set "__local_arg_found=1"
)

@REM -- /clean_env --
if /I "%1"=="-clean_env" (
    set __TBLCMD_ARG_CLEAN_ENV=1
    set "__local_arg_found=1"
)
if /I "%1"=="/clean_env" (
    set __TBLCMD_ARG_CLEAN_ENV=1
    set "__local_arg_found=1"
)

@REM -- /help --
if /I "%1"=="-help" (
    set "__TBLCMD_ARG_HELP=1"
    set "__local_arg_found=1"
)
if /I "%1"=="/help" (
    set "__TBLCMD_ARG_HELP=1"
    set "__local_arg_found=1"
)

@REM -- /no_ext --
if /I "%1"=="-no_ext" (
    set "__TBLCMD_ARG_NO_EXT=1"
    set "__local_arg_found=1"
)
if /I "%1"=="/no_ext" (
    set "__TBLCMD_ARG_NO_EXT=1"
    set "__local_arg_found=1"
)

@REM -- /no_logo --
if /I "%1"=="-no_logo" (
    set __TBLCMD_ARG_NO_LOGO=1
    set "__local_arg_found=1"
)
if /I "%1"=="/no_logo" (
    set __TBLCMD_ARG_NO_LOGO=1
    set "__local_arg_found=1"
)

@REM -- /test --
if /I "%1"=="-test" (
    set "__TBLCMD_ARG_TEST=1"
    set "__local_arg_found=1"
)
if /I "%1"=="/test" (
    set "__TBLCMD_ARG_TEST=1"
    set "__local_arg_found=1"
)

@REM -- /winsdk --
if /I "%1"=="-winsdk" (
    set "__TBLCMD_ARG_WINSDK=%2"
    set "__local_arg_found=1"
)
if /I "%1"=="/winsdk" (
    set "__TBLCMD_ARG_WINSDK=%2"
    set "__local_arg_found=1"
)

@REM -- /arch --
if /I "%1"=="-arch" (
    set "__TBLCMD_ARG_TGT_ARCH=%2"
    set "__local_arg_found=1"
)
if /I "%1"=="/arch" (
    set "__TBLCMD_ARG_TGT_ARCH=%2"
    set "__local_arg_found=1"
)

@REM -- /host_arch --
if /I "%1"=="-host_arch" (
    set "__TBLCMD_ARG_HOST_ARCH=%2"
    set "__local_arg_found=1"
)
if /I "%1"=="/host_arch" (
    set "__TBLCMD_ARG_HOST_ARCH=%2"
    set "__local_arg_found=1"
)

@REM -- /vcvars_ver --
if /I "%1"=="-vcvars_ver" (
    set "__TBLCMD_ARG_VCVARS_VER=%2"
    set "__local_arg_found=1"
)
if /I "%1"=="/vcvars_ver" (
    set "__TBLCMD_ARG_VCVARS_VER=%2"
    set "__local_arg_found=1"
)

if "%__local_arg_found%" NEQ "1" (
   if "%2"=="" (
       @echo [ERROR:%~nx0] Invalid command line argument: '%1'. Argument will be ignored.
   ) else (
       @echo [ERROR:%~nx0] Invalid command line argument: '%1=%2'.  Argument will be ignored.
   )
   set /A __local_parse_error=__local_parse_error+1
   set __local_arg_found=
   exit /B 1
)

set __local_arg_found=
exit /B 0

@REM ------------------------------------------------------------------------
:export_variables

@REM **** Export environment variables ****
set TBLCMD_TEST=%__TBLCMD_ARG_TEST%

@REM only set the following environmnet variables if we are NOT in test mode.
@REM
if "%TBLCMD_TEST%" NEQ "" goto :end

set "TBLCMD_ARG_winsdk=%__TBLCMD_ARG_WINSDK%"

@REM set -app_platform
    if NOT "%__TBLCMD_ARG_APP_PLAT%"=="" (
        set "TBLCMD_ARG_app_plat=%__TBLCMD_ARG_APP_PLAT%"
    ) else (
        set "TBLCMD_ARG_app_plat=Desktop"
    )

    @REM Set host and target architecture for tools that depend on this being
    @REM available. Note that we have special handling of "amd64" to convert to
    @REM "x64" due legacy usage of the former.
    if "%__TBLCMD_ARG_TGT_ARCH%" NEQ "" (
        if "%__TBLCMD_ARG_TGT_ARCH%"=="amd64" (
            set "TBLCMD_ARG_TGT_ARCH=x64"
        ) else (
            set "TBLCMD_ARG_TGT_ARCH=%__TBLCMD_ARG_TGT_ARCH%"
        )
    ) else (
        set "TBLCMD_ARG_TGT_ARCH=x86"
    )

    if "%__TBLCMD_ARG_HOST_ARCH%" NEQ "" (
        if "%__TBLCMD_ARG_HOST_ARCH%"=="amd64" (
            set "TBLCMD_ARG_HOST_ARCH=x64"
        ) else (
            set "TBLCMD_ARG_HOST_ARCH=%__TBLCMD_ARG_HOST_ARCH%"
        )
    ) else (
        @REM By default, the host architecture will match the target
        @REM architecture, which was exported above.
        set "TBLCMD_ARG_HOST_ARCH=%TBLCMD_ARG_TGT_ARCH%"
    )

    set "TBLCMD_ARG_no_ext=%__TBLCMD_ARG_NO_EXT%"
    set "TBLCMD_ARG_no_logo=%__TBLCMD_ARG_NO_LOGO%"
    set "TBLCMD_ARG_CLEAN_ENV=%__TBLCMD_ARG_CLEAN_ENV%"
    set "TBLCMD_ARG_VCVARS_VER=%__TBLCMD_ARG_VCVARS_VER%"

goto :end

@REM ------------------------------------------------------------------------
:print_help

@echo .
@echo ** TheBinaryLoop's Developer Command Prompt Help **
@echo ** Version : %TBLCMD_VER%
@echo .
@echo Syntax: tbldevcmd.bat [options]
@echo [options] :
@echo     TODO
goto comment
@echo     -arch=architecture : Architecture for compiled binaries/libraries
@echo            * x86 [default]
@echo            * amd64
@echo            * arm
@echo            * arm64
@echo     -host_arch=architecture : Architecture of compiler binaries
@echo            * x86 [default]
@echo            * amd64
@echo     -winsdk=version : Version of Windows SDK to select.
@echo            ** 10.0.xxyyzz.0 : Windows 10 SDK (e.g 10.0.10240.0)
@echo                               [default : Latest Windows 10 SDK]
@echo            ** 8.1 : Windows 8.1 SDK
@echo            ** none : Do not setup Windows SDK variables.
@echo                      For use with build systems that prefer to
@echo                      determine Windows SDK version independently.
@echo     -app_platform=platform : Application Platform Target Type.
@echo            ** Desktop : Classic Win32 Apps          [default]
@echo            ** UWP : Universal Windows Platform Apps
@echo     -no_ext : Only scripts from [TBLCOMNTOOLS]\TBLDevCmd\Core
@echo               directory are run during initialization.
@echo     -no_logo : Suppress printing of the developer command prompt banner.
@echo     -vcvars_ver=version : Version of VC++ Toolset to select
@echo            * [empty] : Latest VC++ Toolset [Default]
@echo            * 14.0    : TBL 2015 (v140) VC++ Toolset (installation of the v140 toolset is a prerequisite)
@echo            * 14.1x   : TBL 2017 (v141) VC++ Toolset, if that version is installed on the system under 
@echo                        [TBLInstallDir]\VC\MSVC\Tools\[version].  Where '14.1x' specifies a partial 
@echo                        [version]. The latest [version] directory that matches the specified value will 
@echo                        be used.
@echo            * 14.1x.yyyyy : TBL 2017 (v141) VC++ Toolset, if that version is installed on the system under 
@echo                            [TBLInstallDir]\VC\MSVC\Tools\[version]. Where '14.1x.yyyyy' specifies an 
@echo                            exact [version] directory to be used.
@echo     -test : Run smoke tests to verify environment integrity after
@echo             after initialization (requires all other arguments
@echo             to be the same other than -test).
:comment
@echo     -help : prints this help message.
@echo.

goto :end

@REM ------------------------------------------------------------------------
:clean_env

if "%TBLCMD_DEBUG%" GEQ "1" @echo [DEBUG:%~n0] cleaning environment

set TBLCMD_ARG_app_plat=
set TBLCMD_ARG_CLEAN_ENV=
set TBLCMD_ARG_help=
set TBLCMD_ARG_host_arch=
set TBLCMD_ARG_no_ext=
set TBLCMD_ARG_no_logo=
set TBLCMD_TEST=
set TBLCMD_ARG_tgt_arch=
set TBLCMD_ARG_winsdk=
set TBLCMD_ARG_VCVARS_VER=

goto :end

@REM ------------------------------------------------------------------------
:end

@REM Remove the local temporary variables used by this script
set __TBLCMD_ARG_APP_PLAT=
set __TBLCMD_ARG_CLEAN_ENV=
set __TBLCMD_ARG_HELP=
set __TBLCMD_ARG_HOST_ARCH=
set __TBLCMD_ARG_NO_EXT=
set __TBLCMD_ARG_NO_LOGO=
set __TBLCMD_ARG_TEST=
set __TBLCMD_ARG_TGT_ARCH=
set __TBLCMD_ARG_WINSDK=
set __TBLCMD_ARG_VCVARS_VER=

if "%__local_parse_error%" NEQ "0" (
    set __local_parse_error=
    exit /B 1
)

set __local_parse_error=
exit /B 0

