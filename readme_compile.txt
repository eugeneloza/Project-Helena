You can compile the source simply by opening projecthelena.lpr in Lazarus IDE and pushing F9 to complie&run.

Testing version will require Castle Game Engine at least 5.1.2 version to compile properly installed in Lazarus. In case you're using Castle Game Engine 5.1.2 version and below, you should comment out a deprecated declaration of TImage in CastleImages unit. Download and installation instructions may be found here  http://castle-engine.sourceforge.net/engine.php
WARNING: No Engine version >=5.2.0 will compile the current code due to OnMouseDown event deprecated in TCastleControl! And there is no quick fix for that yet (onMouseDown/onMouseOver should be rewritten to OnPress/onMotion/onRelease but they have really different organization logic). So, to use latest Engine versions you'll just have to wait until I rewrite the interface completely... or help me to :) because I'm really bad at UI design and programming and that slows down the work significantly due to motivation drop (I know I can't do GUI well no matter how hard I try).

Linux version requires (Debian/Ubuntu package reference):
32bit GTK+2 (Thanks Akien for the information)
libopenal1
libopenal-dev
libpng
libpng-dev
zlib1g
zlib1g-dev
libvorbis
libvorbis-dev
libfreetype6
libfreetype6-dev
You will also need dev version of OpenGL drivers for your videocard. In general case it is libgl1-mesa-dev.

Or Castle Game Engine DLLs (32 bit / 64 bit) in case of Windows. These may be downloaded here: http://castle-engine.sourceforge.net/engine.php
The DLLs must be placed in the exe folder (recommended) or in any folder referred to in $PATH.

If you prefer command-line compilation, you may try lazbuild. See instructions at http://wiki.lazarus.freepascal.org/lazbuild (Thanks to Akien for the information)