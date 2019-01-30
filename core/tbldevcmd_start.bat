

if "%TBLCMD_DEBUG%" GEQ "1" @echo [DEBUG:core\%~n0] initializing with arguments '%*'

@REM At this point, [TBLTOOLS] may not have been set, so we call
@REM the command line parsing script in the same directory as this one.
call "%~dp0parse_cmd.bat" %*
if "%ERRORLEVEL%" NEQ "0" set /A __tblcmd_tbldevcmd_errcount=__tblcmd_tbldevcmd_errcount+1

if "%TBLCMD_DEBUG%" GEQ "2" (
    @echo [DEBUG:%~n0] Parsing results...
    @echo [DEBUG:%~n0] -clean_env : %TBLCMD_ARG_CLEAN_ENV%
    @echo [DEBUG:%~n0] -test      : %TBLCMD_TEST%
    @echo [DEBUG:%~n0] -help      : %TBLCMD_ARG_HELP%
)

@REM if -? was specified, then help was already printed and we can exit.
if "%TBLCMD_ARG_HELP%"=="1" goto :end

@REM Test scripts must not modify the environment, so we protect "test mode"
@REM execution via setlocal and avoid setting additional environment variables
@REM other than those set by the command line argument parsing.
if "%TBLCMD_TEST%" NEQ "" (

    if "%TBLCMD_DEBUG%" NEQ "" (
        @echo [DEBUG:%~n0] Writing pre-initialization test environment to %temp%\test_dd_tbldevcmd15_env.log
    )
    @REM if running tests, dump the environment to [TEMP]\%test_dd_tbldevcmd15_env.log
    set > %temp%\test_dd_tbldevcmd15_env.log

    @REM matching 'endlocal' is in tbldevcmd_end.bat.
    setlocal

    if "%TBLCMD_ARG_CLEAN_ENV%" NEQ "" (
        @echo [ERROR] -clean_env and -test cannot be specified at the same time. Ignoring -clean_env.
        if "%__tblcmd_tbldevcmd_errcount%" NEQ "" set /A __tblcmd_tbldevcmd_errcount=__tblcmd_tbldevcmd_errcount+1
    )
    goto :end
)

@REM clean env should restore the pre-initialization environment.
@REM Variable initialization may be skipped here.
if "%TBLCMD_ARG_CLEAN_ENV%" NEQ "" goto :end

@REM PATH should be set, but INCLUDE, LIB, and LIBPATH may not be
@REM set prior to execution of this script.  We'll "key" the capture of the
@REM environment variable values to restore on whether PATH has been saved.
if "%__TBLCMD_PREINIT_PATH%"=="" (
    set "__TBLCMD_PREINIT_PATH=%PATH%"
    if "%__TBLCMD_PREINIT_INCLUDE%"=="" set "__TBLCMD_PREINIT_INCLUDE=%INCLUDE%"
    if "%__TBLCMD_PREINIT_LIB%"==""set "__TBLCMD_PREINIT_LIB=%LIB%"
    if "%__TBLCMD_PREINIT_LIBPATH%"=="" set "__TBLCMD_PREINIT_LIBPATH=%LIBPATH%"
)

@REM if the classic installer is there, the environment will already have
@REM TBLTOOLS set.  We save that value, so we can restore this
@REM variable on -clean_env.
@REM TODO: Add tools to path
if "%TBLTOOLS%" NEQ "" (
::    if "%__TBLCMD_PREINIT_TBLTOOLS%" == "" (
::        set "__TBLCMD_PREINIT_TBLTOOLS=%TBLTOOLS%"
::    )
)

@REM using pushd/popd to avoid having "..\" in the env var.
@REM Set TBLTOOLS to scripts root
@REM Go from tbldevcmd/core to tbldevcmd
pushd "%~dp0..\"
set "TBLTOOLS=%CD%\"
popd

if "%TBLTOOLS%" NEQ "" set "PATH=%TBLTOOLS%;%PATH%"

:set_tblinstalldir

if "%TBLINSTALLDIR%" NEQ "" goto :set_devenvdir
@REM Set TBLINSTALLDIR to TBL's DevPromt Installation Directory
@REM tbldevcmd_start.bat location: DevComPrompt\core
@REM TBLINSTALLDIR location: DevComPrompt
pushd "%~dp0..\"
set "TBLINSTALLDIR=%CD%\"
popd

:set_devenvdir

::if "%DevEnvDir%" == "" (
::    if EXIST "%TBLINSTALLDIR%Common7\IDE\" (
::        set "DevEnvDir=%TBLINSTALLDIR%Common7\IDE\"
::    )
::)
if "%DevEnvDir%" NEQ "" set "PATH=%DevEnvDir%;%PATH%"

goto :end

@REM -----------------------------------------------------------------------
:end
if "%TBLCMD_DEBUG%" GEQ "2" (
    @echo [DEBUG:%~n0] end of script: TBLTOOLS="%TBLTOOLS%"
    @echo [DEBUG:%~n0] end of script: TBLINSTALLDIR="%TBLINSTALLDIR%"
    @echo [DEBUG:%~n0] end of script: DevEnvDir="%DevEnvDir%"
)

exit /B 0
