wixelpi_uploader
================

*** THIS IS AN EXPERIMENT!! DO NOT USE THIS CODE, OR RESULTING DATA, TO MAKE ANY MEDICAL DECISIONS! ***

Uploader scripts for Raspberry Pi (or other linux) to upload raw cgm records from wixel to mongo.
I've set this up using a raspberry pi (out of the box setup, no changes or mods. I may have had to install curl (can't recall)
This connects via a usb cable to a wixel (http://www.pololu.com/product/1336) running Adrien's code (search the cgminthecloud facebook group for a post linking to his code repository) that *does not* shut down the USB. This is important as the the readline code won't work otherwise.

Load the files into a directory, and make the .sh files executable (chmod +x *.sh)

You can determine which USB port has the wixel by simply plugging and unplugging to see what appears and goes away. On my rpi it's /dev/ttyACM0

Load mongo credentials into mongo.cfg

Invoke the program as ./dexterity.sh XXXXX /dev/usbporthere
substituting your values.

--- Peter Miller
