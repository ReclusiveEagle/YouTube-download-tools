# Youtube-download-tools
Personal command line tools for YouTube-DLP.

[**Requires YouTube-DLP**](https://github.com/yt-dlp/yt-dlp)

Comments have been added to the .bat file.

## What does this do?
This script automates the download process, asking the user for a URL, presenting them with a list of videos to download and then proceeds to download and preserve metadata such as description, video name, channel. Script will also automatically download and embed english subtitles if there are any available. Embedded subtitles are turned off by default and will need to be turned on in a video player such as VLC. 

The script will do the following in order.

1. CD to the current location the .bat file is in and sets the command line to recognzie Unicode 8 formatting. *Unicode 8 will preserve file names without broken characters and is even able to display emojis*

2. Deletes the following existing temporary files from exited runs of the script if there are any (More on this later.)
   - Thumbnails.txt
   - Channel.txt
   - Title.txt
3. Asks user to enter YouTube URL then lists the available formats for this video.
   - *Please open the video then copy the URL. If you right click copy from recommended or home it appends a pre assigned download format and instantly downloads this instead of listing the formats*
   - For example [https://www.youtube.com/watch?v=SWc-Gll-fT8] becomes [https://www.youtube.com/watch?v=SWc-Gll-fT8&pp=wgIGCgQQAhgB] if you right click and copy link. There must only be **one =**
  
4. Asks the user which formats they would like to download and merge into an .mkv container. Also sanitizes file names to be compatible with Windows.
   - Files will be downloaded to /Downloads in the same folder the .bat file is located in, in a folder with the channel name.
   - Multiple formats can be downloaded and merged with +. Example 251+140.
   - Sanitizes file names. Replaces [:<>/\?*] with nothing. Replaces | with a -
   - .mkv is a *container format* and does not re-encode videos or audio. Files are preserved as downloaded in the container format and can be extracted with [MKVToolNix](https://mkvtoolnix.download/)
  
6. Starts downloading selected formats and saves sanitized title and channel name to temporary text files
   - Creates Channel.txt and Title.txt. They are temporary and are used to store variables because CMD is extremely finicky about Unicode character names in variables. These text files are used for CMD to read from later on and will be deleted at the end.
  
7. Presents the User with a list of thumbnails to select from and download.
   - Stores list in Thumbnails.txt. CMD then searches the text file for the line containing the selected format and downloads the image with cURL.
   - Images are renamed to the video name and stored in the folder with the video. More on this later.
  
8. Embeds the chosen thumbnail into the .mkv container as the cover.
    - **Please note:** Microsoft still does not natively support displaying .mkv thumbnails. If you are using VLC, go to tools and select metadata to verify images are being embedded for the day MICROSOFT decides to stop forcing .avi as the only industry standard and fully support .mkv.
    - Thumbnails will not be deleted from the folder for this specific reason. Other wise there would be no need to store the thumbnail along side the video.
  
9. Deletes temporary text files and jumps back to start of .bat file to ask the user for the next URL to download.
