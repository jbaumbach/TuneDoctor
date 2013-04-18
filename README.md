TuneDoctor
==========
The Mac OSX app that fixes exclamation points in iTunes.

![Tune Doctor Screenshot](tunedoctor-screenshot.png "Screenshot")

The Problem
-----------
For those of us with massive iTunes music libraries located on external storage like a NAS, using iTunes can be a headache.  When manipulating your songs, if the NAS is in powersaving mode then iTunes will think your songs are missing!  It then puts a nice little explamation point next to the song title and it won't sync with your phone anymore.

The Solution
------------
You can fix it manually yourself by playing each song, one by one.  That works, but it takes forever.  This program takes the manual part out of it.  Just run iTunes, select the songs or albums with exclamation points to fix, run this program, and click the "Clear Exclamations!" button.

Getting TuneDoctor
------------------
If you're lazy like me, you just want to download and run the program.  Unfortunately, Github doesn't like large binaries anymore.  Until I can find a good alternative solution, you can get it running yourself with a few extra mouse clicks.  You need:

* Mac OSX 10.6 or above / 64-bit
* iTunes 10.0 or above (may work on older versions as well)
* Apple Xcode 4.6.1 or above (may work on older versions as well). Xcode is a free program by Apple that is used to create Mac and iOS apps.  If you don't have the latest version, you can get it quickly and for free from Apple: <https://developer.apple.com/xcode/> 

Download the source code using the links at the top of this page.  If you are already using Github's client, you can click "Clone in Mac".  Otherwise, just click the "Zip" link, then extract the files to a temp directory and open the project up in Xcode.  Then run it in Xcode (click __Product -> Run__).  You can also build the TuneDoctor.app application, which you can then copy to your "Applications" folder and run it anytime without having to go into XCode.  To do that, select __Product -> Build For -> Archiving__, then right click the __Products -> TuneDoctor.app__ link at the bottom of the solution listing on the left-hand side of Xcode and select __Show in Finder__.  

When you run TuneDoctor.app, you should see the screen above.  If you do, then it built properly.  If not, make sure you have the proper versions of each of the programs listed above and update them as necessary.

Using TuneDoctor
----------------
Using TuneDoctor is reasonably easy.  

1. Ensure the device(s) holding your songs is powered up and accessible by your Mac.
1. The connection to your song storage device __should be hard-wired - no WiFi__.  Otherwise the process will take too long.
1. Open iTunes and select some songs with exclamation points next to them.  For the first run, only select a handfull of songs to get a good idea of your performance.
1. Run the program and make sure the songs show up in the interface.  If not, click "Refresh".
1. Click the "Clear Exclamations!" button and watch the magic.

After the program runs, the exclamantion points should be gone.  You can then get these files to sync up to your iPhone.

Stuff That Could Be Better
--------------------------
The program works, but there are a lot of nice enhancements that could be made.  Go ahead and grab the source and make it so, then do a pull request and we'll get your enhancements out there for everyone else.  Here are a few things to start with:

* Unit tests.  I am all about TDD now, but when I started this app I wasn't.
* Implement background processes so the interface stays responsive if the connection is slow
* Allow the user to cancel during operation
* Cool icon

How It Works
------------
It's pretty simple.  iTunes allows a lot of automation.  TuneDoctor reads the selected songs, and then just tries to play each one of them.  Even though the song location appears to be missing in the iTunes database, it still knows where the song should be.  If iTunes finds it, the exclamation point goes away.

![iTunes Y U No](itunes-y-u-no.jpg "iTunes YUNo")

License
-------
Copyright (c) 2011-2013 John Baumbach <john.j.baumbach@gmail.com>

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

