# LibbieOffice
![LibbieOffice splash](/splash/libbie_no8ch.png)

Universal (if not, then fix and commit) LibreOffice image replacement script
## Usage
Download and run just [libbie.sh](https://github.com/redspl/libbieoffice/raw/master/libbie.sh), or download the whole repo and run libbie.sh.
The script is designed to be portable - it creates a separate directory called libbie_icons, and then it downloads everything into it unless run with --local.

### Syntax
./libbie.sh [--local] [--all] [--splash (splashname)]

--local - do not download images; useful if you've downloaded the whole repo
--all - replace everything
--splash - replace just splash OR specify splash name to be installed with --all

Splash can be one of:
* default - LibbieOffice splash supplied by anon from 8ch.net/tech
* libbie_blue - LibbieOffice splash supplied by the same anon; Blue eye version
* libbie_no8ch, libbie_blue_no8ch - same as above, but without 8ch watermark
* libre - the original splash with Libbie instead of 5
* libre_alt - splash by [KarlFish](https://github.com/KarlFish)
* all - download all splashes, install default. does nothing if executed with --local