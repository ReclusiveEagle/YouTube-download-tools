# Youtube-download-tools
Personal command line tools for YouTube-DLP.

Comments have been added to the .bat file.

## What does this do?
The script will do the following in order.

1. CD to the current location the .bat file is in and sets the commandline to recognzie Unicode 8 formatting. *Unicode 8 will preserve file names without broken characters and is even able to display emojis*

2. Deletes the following existing temporary files from exited runs of the script if there are any (More on this later.)
   - Thumbnails.txt, Channel.txt, Title.txt
