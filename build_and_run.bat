@echo off
chcp 65001 >nul
cd /d "%~dp0"

set "CMAKE=C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe"
set "BUILD=%CD%\build"

if not exist "%CMAKE%" (
  echo ERROR: CMake not found. Install VS 2022 with "Desktop development with C++".
  goto :errend
)

echo === Star Yuan Game build ===

"%CMAKE%" -S "%CD%" -B "%BUILD%" -G "Visual Studio 17 2022" -A x64
if errorlevel 1 goto :retry1
goto :buildstep

:retry1
echo First configure failed. Wiping build and retrying with ghproxy.net...
rd /s /q "%BUILD%" 2>nul
"%CMAKE%" -S "%CD%" -B "%BUILD%" -G "Visual Studio 17 2022" -A x64 -DSFML_ZIP_URL=https://ghproxy.net/https://github.com/SFML/SFML/archive/refs/tags/2.6.2.zip
if errorlevel 1 goto :retry2
goto :buildstep

:retry2
echo Second configure failed. Wiping build and retrying with ghproxy.com...
rd /s /q "%BUILD%" 2>nul
"%CMAKE%" -S "%CD%" -B "%BUILD%" -G "Visual Studio 17 2022" -A x64 -DSFML_ZIP_URL=https://ghproxy.com/https://github.com/SFML/SFML/archive/refs/tags/2.6.2.zip
if errorlevel 1 goto :configfail
goto :buildstep

:configfail
echo CMake configure still failed. See errors above.
goto :errend

:buildstep
if not exist "%BUILD%\CMakeCache.txt" (
  echo ERROR: Configure did not create CMakeCache.txt.
  goto :errend
)
"%CMAKE%" --build "%BUILD%" --config Release
if errorlevel 1 (
  echo BUILD FAILED - see errors above.
  goto :errend
)

echo === Running game ===
cd /d "%BUILD%\Release"
if not exist "star_yuan_game.exe" (
  echo ERROR: star_yuan_game.exe not found.
  goto :errend
)
star_yuan_game.exe
echo Game exited.
goto :okend

:errend
pause
exit /b 1

:okend
pause
exit /b 0
