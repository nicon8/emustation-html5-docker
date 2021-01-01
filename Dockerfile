FROM ubuntu:20.04

LABEL version="0.1"
LABEL maintainer="nicola.manica@gmail.com"

# skip interactive configuration dialogs
ENV DEBIAN_FRONTEND noninteractive

# add winswitch repository and install Xpra,xpra-html5,mame
RUN apt-get update && \
    apt-get install -y --no-install-recommends openssl gnupg curl && \
    UBUNTU_VERSION=$(cat /etc/os-release | grep UBUNTU_CODENAME | sed 's/UBUNTU_CODENAME=//') && \
    curl http://xpra.org/gpg.asc | apt-key add - && \
    echo "deb http://xpra.org/ $UBUNTU_VERSION main" >> /etc/apt/sources.list.d/xpra.list && \
    apt-get update && \
    apt-get install -y xserver-xorg-video-dummy -y && \
    apt-get install -y --no-install-recommends xpra && \
    apt-get install -y xterm -y && \
    apt-get install -y python3-paramiko -y && \
    apt-get install -y python3-xdg -y && \
    apt-get install -y python3-notify2 -y && \
    apt-get install -y --no-install-recommends xpra-html5 python3-requests && \
    apt-get install -y gpg -y && \
    apt-get remove -y --purge gnupg curl && \
    apt-get autoremove -y --purge && \
    rm -rf /var/lib/apt/lists/*

# copy xpra config file
COPY ./xpra.conf /etc/xpra/xpra.conf

COPY RetroPie-Setup /opt/RetroPie-Setup
#sudo ./retropie_packages.sh setup basic_install_setup
RUN /opt/RetroPie-Setup/retropie_packages.sh setup basic_install_setup
RUN /opt/RetroPie-Setup/retropie_packages.sh setup basic_install
RUN /opt/RetroPie-Setup/retropie_packages.sh bluetooth depends
RUN /opt/RetroPie-Setup/retropie_packages.sh usbromservice
RUN /opt/RetroPie-Setup/retropie_packages.sh samba depends
RUN /opt/RetroPie-Setup/retropie_packages.sh samba install_shares
#RUN /opt/RetroPie-Setup/retropie_packages.sh splashscreen default
#RUN /opt/RetroPie-Setup/retropie_packages.sh splashscreen enable
RUN /opt/RetroPie-Setup/retropie_packages.sh xpad

#copy keyboard setup
COPY es_input.cfg /opt/retropie/configs/all/emulationstation/

# allow users to read default certificate
RUN chmod 644 /etc/xpra/ssl-cert.pem

# add xpra user
RUN useradd --create-home --shell /bin/bash xpra --gid xpra --uid 1000
WORKDIR /home/xpra

# create run directory for xpra socket and set correct permissions for xpra user
RUN mkdir -p /run/user/1000/xpra && chown -R 1000 /run/user/1000

VOLUME /tmp/.X11-unix

# copy xpra config file
COPY ./xpra.conf /etc/xpra/xpra.conf

# set default password
ENV XPRA_PASSWORD xpra

# expose xpra HTML5 client port
EXPOSE 14500

# CMD ["sudo X -config dummy-1920x1080.conf"]
COPY dummy-1920x1080.conf /etc/X11/xorg.conf

