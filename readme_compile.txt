You can compile the source simply by opening projecthelena.lpr in Lazarus IDE and pushing F9 to complie&run.

Testing version will require Castle Game Engine at least 5.1.2 version to compile. Download and installation instructions may be found here http://castle-engine.sourceforge.net/engine.php
You will also require DAT folder from a compiled game (I didn't include it in source to reduce size).

Linux version requires 32bit GTK+2 (Thanks Akien for the information).
Testing version also requires (Debian/Ubuntu package reference):
libopenal1
libopenal-dev
libpng
libpng-dev
zlib1g
zlib1g-dev
libvorbis
libvorbis-dev
Or Castle Game Engine DLLs (32 bit / 64 bit) in case of Windows. These may be downloaded here: http://castle-engine.sourceforge.net/engine.php

However, if you prefer command-line compilation, you may try lazbuild. See instructions at http://wiki.lazarus.freepascal.org/lazbuild (Thanks to Akien for the information)