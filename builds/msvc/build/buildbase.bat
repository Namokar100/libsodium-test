@ECHO OFF
REM Usage: [buildbase.bat ..\vs2019\mysolution.sln 16]

SETLOCAL enabledelayedexpansion

SET solution=%1
SET version=%2
SET log=build_%version%.log
SET tools=Microsoft Visual Studio %version%.0\VC\vcvarsall.bat

IF %version% == 17 (
  SET tools=Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvarsall.bat
  SET environment="%programfiles%\!tools!"
  IF NOT EXIST !environment! (
    SET environment="%programfiles(x86)%\!tools!"
    IF NOT EXIST !environment! (
      SET tools=Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat
    )
  )
)

IF %version% == 16 (
  SET tools=Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvarsall.bat
  SET environment="%programfiles%\!tools!"
  IF NOT EXIST !environment! (
    SET environment="%programfiles(x86)%\!tools!"
    IF NOT EXIST !environment! (
      SET tools=Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat
    )
  )
)

IF %version% == 15 (
  SET tools=Microsoft Visual Studio\2017\Enterprise\VC\Auxiliary\Build\vcvarsall.bat
  SET environment="%programfiles%\!tools!"
  IF NOT EXIST !environment! (
    SET environment="%programfiles(x86)%\!tools!"
    IF NOT EXIST !environment! (
      SET tools=Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat
    )
  )
)
SET environment="%programfiles%\!tools!"
IF NOT EXIST !environment! SET environment="%programfiles(x86)%\!tools!"

ECHO Environment: !environment!

IF NOT EXIST !environment! GOTO no_tools

ECHO Building: %solution%

CALL !environment! x86 > nul
ECHO Platform=x86

ECHO Configuration=DynDebug
msbuild /m /v:n /p:Configuration=DynDebug /p:Platform=Win32 %solution% >> %log%
IF errorlevel 1 GOTO error
ECHO Configuration=DynRelease
msbuild /m /v:n /p:Configuration=DynRelease /p:Platform=Win32 %solution% >> %log%
IF errorlevel 1 GOTO error
ECHO Configuration=LtcgDebug
msbuild /m /v:n /p:Configuration=LtcgDebug /p:Platform=Win32 %solution% >> %log%
IF errorlevel 1 GOTO error
ECHO Configuration=LtcgRelease
msbuild /m /v:n /p:Configuration=LtcgRelease /p:Platform=Win32 %solution% >> %log%
IF errorlevel 1 GOTO error
ECHO Configuration=StaticDebug
msbuild /m /v:n /p:Configuration=StaticDebug /p:Platform=Win32 %solution% >> %log%
IF errorlevel 1 GOTO error
ECHO Configuration=StaticRelease
msbuild /m /v:n /p:Configuration=StaticRelease /p:Platform=Win32 %solution% >> %log%
IF errorlevel 1 GOTO error

CALL !environment! x86_amd64 > nul
ECHO Platform=x64

ECHO Configuration=DynDebug
msbuild /m /v:n /p:Configuration=DynDebug /p:Platform=x64 %solution% >> %log%
IF errorlevel 1 GOTO error
ECHO Configuration=DynRelease
msbuild /m /v:n /p:Configuration=DynRelease /p:Platform=x64 %solution% >> %log%
IF errorlevel 1 GOTO error
ECHO Configuration=LtcgDebug
msbuild /m /v:n /p:Configuration=LtcgDebug /p:Platform=x64 %solution% >> %log%
IF errorlevel 1 GOTO error
ECHO Configuration=LtcgRelease
msbuild /m /v:n /p:Configuration=LtcgRelease /p:Platform=x64 %solution% >> %log%
IF errorlevel 1 GOTO error
ECHO Configuration=StaticDebug
msbuild /m /v:n /p:Configuration=StaticDebug /p:Platform=x64 %solution% >> %log%
IF errorlevel 1 GOTO error
ECHO Configuration=StaticRelease
msbuild /m /v:n /p:Configuration=StaticRelease /p:Platform=x64 %solution% >> %log%
IF errorlevel 1 GOTO error

@REM Build ARM64 packages only for Visual studio 2019 and later
IF %version% GEQ 16 (
  CALL !environment! ARM64 > nul
  ECHO Platform=ARM64

  ECHO Configuration=DynDebug
  msbuild /m /v:n /p:Configuration=DynDebug /p:Platform=ARM64 %solution% >> %log%
  IF errorlevel 1 GOTO error
  ECHO Configuration=DynRelease
  msbuild /m /v:n /p:Configuration=DynRelease /p:Platform=ARM64 %solution% >> %log%
  IF errorlevel 1 GOTO error
  ECHO Configuration=LtcgDebug
  msbuild /m /v:n /p:Configuration=LtcgDebug /p:Platform=ARM64 %solution% >> %log%
  IF errorlevel 1 GOTO error
  ECHO Configuration=LtcgRelease
  msbuild /m /v:n /p:Configuration=LtcgRelease /p:Platform=ARM64 %solution% >> %log%
  IF errorlevel 1 GOTO error
  ECHO Configuration=StaticDebug
  msbuild /m /v:n /p:Configuration=StaticDebug /p:Platform=ARM64 %solution% >> %log%
  IF errorlevel 1 GOTO error
  ECHO Configuration=StaticRelease
  msbuild /m /v:n /p:Configuration=StaticRelease /p:Platform=ARM64 %solution% >> %log%
  IF errorlevel 1 GOTO error
)

ECHO Complete: %solution%
GOTO end

:error
ECHO *** ERROR, build terminated early, see: %log%
GOTO end

:no_tools
ECHO *** ERROR, build tools not found: !tools!

:end

