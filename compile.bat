@echo off
:: Remove previous log
if exist compile.log del compile.log

:: Setting the output folder name
set OUTPUT_DIR=..\outputs

:: Get the current Git branch name
for /f "delims=" %%B in ('git rev-parse --abbrev-ref HEAD') do (
    set BRANCH=%%B
)

:: Extract the base name (without extension) of the input file
for %%F in (%1) do (
    set MAIN_NAME=%%~nF
)

:: Get current folder name as context (e.g., 'resume cv' or 'cover letter')
for %%D in ("%CD%") do (
    set CONTEXT_NAME=%%~nxD
)

:: Final output name
set FINAL_NAME=%MAIN_NAME%_%BRANCH%
:: Print final name
echo ===============================>> compile.log
echo Output file name: %MAIN_NAME%.pdf>> compile.log
echo ===============================>> compile.log

:: Runing the latexmk command with dynamic output naming
latexmk -synctex=1 -interaction=nonstopmode -file-line-error -lualatex -outdir=%OUTDIR% -jobname=%DOC% %1

:: Ensure outputs directory exists
if not exist %OUTPUT_DIR% (
    :: Creating outputs directory
    echo Creating outputs directory...
    mkdir %OUTPUT_DIR%
)

echo ===============================>> compile.log
echo Source: "%MAIN_NAME%.pdf">> compile.log
echo Destiny: "%OUTPUT_DIR%\%FINAL_NAME%.pdf">> compile.log
echo ===============================>> compile.log
:: Copy final PDF to shared outputs folder
copy "%MAIN_NAME%.pdf" "%OUTPUT_DIR%\%FINAL_NAME%.pdf"