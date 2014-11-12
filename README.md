wixelpi_uploader
================

Uploader scripts for Raspberry Pi (or other linux) to upload raw cgm records from wixel to mongo.
I've set this up using a raspberry pi (out of the box setup, no changes or mods. I may have had to install curl (can't recall)
This connects via a usb cable to a wixel (http://www.pololu.com/product/1336) running Adrien's code (search the cgminthecloud facebook group for a post linking to his code repository) that *does not* shut down the USB. This is important as the the readline code won't work otherwise.

--- Peter Miller
