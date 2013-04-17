TuneDoctor
==========
The Mac OSX app that fixes exclamation points in iTunes.

![Tune Doctor Screenshot](tunedoctor-screenshot.png "Screenshot")

The Problem
-----------
For those of us with massive iTunes music libraries located on external storage like a NAS, using iTunes can be a headache.  When manipulating your songs, if the NAS is in powersaving mode then iTunes will think your songs are missing!  It then puts a nice little explamation point next to the song title and it won't sync with your phone anymore.

The Solution
------------
You can fix it manually yourself by playing each song, one by one.  That works, but it takes forever.  This program takes the manual part out of it.  Just run iTunes, select the songs or albums with exclamation points to fix, run this program, and click the "Remove!" button.

Making it Happen
----------------
If you're lazy like me, you just want to download and run the program.  That will work fine provided you meet these requirements:

* Mac OSX 10.6 or above / 64-bit
* iTunes 10.0 or above (may work on older versions as well)

If so, download the app and give it a shot.  If anything goes wrong, let me know.

Using TuneDoctor
----------------
Using TuneDoctor is reasonably easy.  

# Ensure the device(s) holding your songs is powered up and accessible by your Mac.
# The connection to your song storage device should be hard-wired - no WiFi.  Otherwise the process will take too long.
# Open iTunes and select some songs with exclamation points next to them.  For the first run, only select a handfull of songs to get a good idea of your performance.
# Run the program and make sure the songs show up in the interface.  If not, click "Refresh".
# Click the "Clear Exclamations!" button and watch the magic.

After the program runs, the exclamantion points should be gone.  You can then get these files to sync up to your iPhone.

Stuff That Could Be Better
--------------------------
The program works, but there are a lot of nice enhancements that could be made.  Go ahead and grab the source and make it so.  Here are a few things to start with:

* Implement background processes so the interface stays responsive if the connection is slow
* Allow the user to cancel during operation

How It Works
------------
It's pretty simple.  iTunes allows a lot of automation.  TuneDoctor reads the selected songs, and then just tries to play each one of them.  Even though the song location appears to be missing in the iTunes database, it still knows where the song should be.  If iTunes finds it, the exclamation point goes away.

