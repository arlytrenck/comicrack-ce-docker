# ComicRack Community Edition (Windows/.NET) under Wine, served via KasmVNC.
# No upstream container exists; this follows pezhore/comicrack-docker's approach.
FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntujammy

ARG CRCE_VERSION=v0.9.184

ENV TITLE="ComicRack CE" \
    WINEPREFIX=/config/wine \
    WINEARCH=win64 \
    WINEDEBUG=-all

RUN rm -f /etc/apt/sources.list.d/nodesource* && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends wget ca-certificates gnupg unzip cabextract xvfb xdotool && \
    mkdir -pm755 /etc/apt/keyrings && \
    wget -qO /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key && \
    wget -qNP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources && \
    apt-get update && \
    apt-get install -y --install-recommends winehq-stable winbind && \
    wget -qO /usr/local/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
    chmod +x /usr/local/bin/winetricks && \
    mkdir -p /opt/comicrack && \
    wget -qO /tmp/crce.zip "https://github.com/maforget/ComicRackCE/releases/download/${CRCE_VERSION}/ComicRackCE_${CRCE_VERSION}.zip" && \
    (unzip -q /tmp/crce.zip -d /opt/comicrack || [ $? -eq 1 ]) && \
    rm -rf /tmp/crce.zip /var/lib/apt/lists/*

COPY root/ /
