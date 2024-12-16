@echo off
setlocal enabledelayedexpansion

REM Check if the source and destination directories are provided
@REM if "%~1"=="" (
@REM     echo Usage: %~nx0 <source_directory> <destination_directory>
@REM     exit /b 1
@REM )

@REM if "%~2"=="" (
@REM     echo Usage: %~nx0 <source_directory> <destination_directory>
@REM     exit /b 1
@REM )

REM Assign command-line arguments to variables
set "SOURCE_DIR=%~1"
set "DEST_DIR=%~2"

REM Ensure source directory exists
if not exist "%SOURCE_DIR%" (
    echo Error: Source directory "%SOURCE_DIR%" does not exist.
    exit /b 1
)

REM Create the destination directory if it doesn't exist
if not exist "%DEST_DIR%" (
    echo Creating destination directory: "%DEST_DIR%"
    mkdir "%DEST_DIR%"
)

REM Define an array of music file extensions
set "MUSIC_EXTENSIONS=mp3 wav flac aac m4a ogg wma"

REM Initialize file count
set "file_count=0"

REM Count total music files to process
echo Counting music files in "%SOURCE_DIR%"...
for %%E in (%MUSIC_EXTENSIONS%) do (
    for /r "%SOURCE_DIR%" %%F in (*.%%E) do (
        if exist "%%F" (
            set /a file_count+=1
        )
    )
)

if "%file_count%"=="0" (
    echo No music files found in "%SOURCE_DIR%".
    exit /b 0
)

echo Found %file_count% music files to move.

REM Move music files and show progress
set "moved_count=0"
for %%E in (%MUSIC_EXTENSIONS%) do (
    for /r "%SOURCE_DIR%" %%F in (*.%%E) do (
        if exist "%%F" (
            move /y "%%F" "%DEST_DIR%" >nul
            set /a moved_count+=1
            echo Progress: !moved_count! / %file_count% files moved.
        )
    )
)

REM Delete all remaining files and folders in the source directory
echo Cleaning up remaining files and folders in "%SOURCE_DIR%"...
for /d %%D in ("%SOURCE_DIR%\*") do rd /s /q "%%D"
for %%F in ("%SOURCE_DIR%\*") do del /q "%%F"

echo Cleanup completed.
echo All music files have been moved and source directory cleaned up successfully!
exit /b 0
