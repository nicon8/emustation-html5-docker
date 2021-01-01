Docker video dummy
==================

## General Idea

I wanted to provide the easiest way to play retrogames.

This repo compiles and installs

https://github.com/RetroPie/RetroPie-Setup

inside a docker, and gives access to 

https://github.com/RetroPie/EmulationStation

using Xorg, xpra and xpra-html5 on a standard browser.

Games must be placed in the roms directory. 

This is almost a security joke, do not use in production.

## How to use

```bash
git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git

cd RetroPie-Setup

# Last checked
git checkout ac8d87759f4cad763affbba624be4fb206790ceb

docker build -t emustation 

docker run -t \
      -e XDG_RUNTIME_DIR=/tmp -e DISPLAY=:1 -e TERM=xterm --shm-size=256m \
      -v "$(pwd)"/rom:/root/RetroPie/roms -p 14500:14500 emustation xpra start --bind-tcp=0.0.0.0:10000 --html=on \
      --start-child="/opt/retropie/supplementary/emulationstation/emulationstation --resolution 1024 768" \
      --exit-with-children --daemon=no \
      --xvfb="Xorg -noreset +extension GLX +extension RANDR +extension RENDER -logfile ./xdummy.log -config /etc/X11/xorg.conf" \
      --sharing=yes --pulseaudio=yes --notifications=no --bell=no

```

## Result

Opening a browser on port 14500 (xpra,xpra) gives you html5 access to emulationstation.

![Emulationstation menu](/screenshot/emulationstation.PNG?raw=true "Emulationstation menu")

![Crash Bandicot GBA version](/screenshot/crash_bandicot_gba.PNG?raw=true "Crash Bandicot GameBoyAdvanced version")

## ToDo
- fix sound
- fix missing sudo binary (emulationstation suppose to have sudo installed)
- compile from scratch xdummy package patched with constant font dpi

## Credits
- https://xpra.org/
- https://github.com/JAremko/docker-x11-bridge
- https://github.com/brugnara/video-dummy
- https://techoverflow.net/2019/02/23/how-to-run-x-server-using-xserver-xorg-video-dummy-driver-on-ubuntu/
- https://stackoverflow.com/questions/39085462/xdummy-in-docker-container
- https://github.com/RetroPie/RetroPie-Setup
- https://github.com/RetroPie/EmulationStation
- https://github.com/ffeldhaus/docker-xpra-html5-minimal
