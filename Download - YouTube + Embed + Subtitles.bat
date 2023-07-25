@echo off
:: CD to current file
cd /D "%~dp0"

::Sets cmd to save and recognize Unicode 8 text files (For the thumbnail name). > nul hides activation.
chcp 65001 > nul

del Thumbnails.txt, Channel.txt, Title.txt >nul 2>&1

:start
set /p "url=Enter YouTube video URL: "

yt-dlp.exe %url% --list-formats
goto download



::-------------------------------------------------------------------------------------------

:download
set /p "download=Formats to download: "


yt-dlp.exe %url% -f %download% --embed-metadata --replace-in-metadata "title" "[:<>/\?*]" "" --replace-in-metadata "title" "[|]" "-" -o "Downloads/%%(uploader)s/%%(title)s-temp.%%(ext)s" --embed-subs --sub-lang en --merge-output-format mkv --print-to-file "%%(title)s" Title.txt --encoding utf8 --print-to-file "%%(uploader)s" Channel.txt --encoding utf8


set /p Title=<Title.txt
set /p Channel=<Channel.txt

goto Thumbnail



::-------------------------------------------------------------------------------------------

:Thumbnail

::Writes list of thumbnails to temp.txt instead of displaying them. Then used type to print contents of text file. This is done to temporarily store thumbnail urls in the text file.

yt-dlp.exe %url% --list-thumbnails > Thumbnails.txt
type Thumbnails.txt



:: Asks the user to select url by index number and searches for that line in text file. Then finds the string and extracts only the url and stores it in %ThumbnailURL%.

set /p index="Select Thumbnail: "
for /f "tokens=1-4" %%a in ('findstr /b /c:"%index% " Thumbnails.txt') do set ThumbnailURL=%%d



:: Extracts file extension from url
for %%a in (%ThumbnailURL%) do set ThumbnailExtension=%%~xa



::Combines title + thumbnail extension and stores it in %Filename% | Disabled
::set Filename=%Title%%ThumbnailExtension%


::-------------------------------------------------------------------------------------------
:Download Thumbnail

::Downloads image, stores it in Downloads\Channel\Filename.extension, prints message in cmd, and deletes temp.txt. echo. creates blank lines in cmd.

echo.
cURL %ThumbnailURL% --output "Downloads\%Channel%\temp%ThumbnailExtension%" 
rename "Downloads\%Channel%\temp%ThumbnailExtension%" "%Title%%ThumbnailExtension%"
echo.



echo Saved Thumbnail to "Downloads\%Channel%\%Title%%ThumbnailExtension%"

::-------------------------------------------------------------------------------------------
:Embed Thumbnail

if "%ThumbnailExtension%" == ".webp" (
    rename "Downloads\%Channel%\%Title%-temp.mkv" "%Title%.mkv"
    goto :End
)

if "%ThumbnailExtension%" == ".jpg" (set "mimetype=image/jpeg")
if "%ThumbnailExtension%" == ".jpeg" (set "mimetype=image/jpeg")
if "%ThumbnailExtension%" == ".png" (set "mimetype=image/png")
if "%ThumbnailExtension%" == ".webp" (set "mimetype=image/webp")



ffmpeg -i "Downloads\%Channel%\%Title%-temp.mkv" -map 0 -c copy -attach "Downloads\%Channel%\%Title%%ThumbnailExtension%" -metadata:s:t mimetype=%mimetype% -metadata:s:t:0 filename="cover%ThumbnailExtension%" "Downloads\%Channel%\%Title%.mkv" >nul 2>&1
::-------------------------------------------------------------------------------------------

:End
echo Embedded Thumbnail in "Downloads\%Channel%\%Title%.mkv"
del Thumbnails.txt, Channel.txt, Title.txt, "Downloads\%Channel%\%Title%-temp.mkv" >nul 2>&1

::Goes back to start to enter a new video url
goto start



:: Stop .bat from exiting

cmd /k










::-------------------------------------------------------------------------------------------
::Legacy

:: -o "%(uploader)s/%(title)s.%(ext)s" creates a folder with the creators name.
:: Note when using .bat. a double %% has to be used instead of a single % or the file will be renamed to (uploader)s/(title)s.(ext)s.




:: -s --print-to-file stops the file from downloading. -s works like --skip-download for --print-to-file


::Prints filename which contains the video title, watch id, and file extension to text file overwriting the channel name and stores only the video title in %Title%. Set "Title=%Title:~0,-1%" removes blank space before extension.

::set /p Title=<Title.txt