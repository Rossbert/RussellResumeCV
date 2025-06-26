@echo off
:: Setting the output folder name
set OUTPUT_DIR=outputs

:: Get the current Git branch name
for /f "delims=" %%B in ('git rev-parse --abbrev-ref HEAD') do (
    set BRANCH=%%B
)

:: Extract the main filename
for %%F in (%1) do (
    set MAIN_NAME=%%~nF
)

:: Print final name
echo Output file name: %MAIN_NAME%_%BRANCH%.pdf

:: Ensure outputs directory exists
if not exist %OUTPUT_DIR% (
    :: Creating outputs directory
    echo Creating outputs directory...
    mkdir %OUTPUT_DIR%
)

@REM if "%1"=="clean" (
@REM     echo Cleaning auxiliary files from %OUTPUT_DIR%...
@REM     for /r "%OUTPUT_DIR%" %%f in (*) do (
@REM         :: Checks if the files does not have an .pdf extension
@REM         if /I not "%%~xf"==".pdf" (
@REM             del "%%f"
@REM         )
@REM     )
@REM     exit /b
@REM )

:: Runing the latexmk command with dynamic output naming
latexmk -synctex=1 -interaction=nonstopmode -file-line-error -lualatex -outdir=%OUTPUT_DIR% -jobname=%MAIN_NAME%_%BRANCH% %1

:: For VSCode latex extension copies the output pdf to the current folder with the original name
for %%f in ("%OUTPUT_DIR%\%MAIN_NAME%_%BRANCH%.pdf") do (
    copy "%%f" "%MAIN_NAME%.pdf"
)