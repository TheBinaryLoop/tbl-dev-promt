

@if NOT "%TBLCMD_DEBUG%" GEQ "3" @echo off

@REM If in debug mode, we want to log the environment variable state
@REM prior to TBLDevCmd.bat being executed. This is disabled by default
@REM and is enabled by setting [TBLCMD_DEBUG] to some value.
if "%TBLCMD_DEBUG%" NEQ "" (
        @echo [DEBUG:%~n0] Writing pre-initialization environment to %temp%\dd_tbldevcmd_preinit_env.log
        set > %temp%\dd_tbldevcmd_preinit_env.log
)

@REM script-local error counter
set __tblcmd_tbldevcmd_errcount=0

@REM Parse the command line and set variables needed.
@REM Need to use this variable instead of passing arguments to escape
@REM the /? option, which will otherwise display the help for 'call'.
set "__TBLCMD_ARGS_LIST=%*"
call "%~dp0tbldevcmd\core\vsdevcmd_start.bat"
set __TBLCMD_ARGS_LIST=
