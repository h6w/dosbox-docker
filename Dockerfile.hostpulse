FROM alpine:edge

ADD [ "dosbox-0.74-2.tar.gz", "dosbox-0.74.patch", "/build/" ]

ENV PULSE_SERVER /run/pulse/native

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk update \
 && apk add --no-cache sdl libxxf86vm libstdc++ libgcc build-base sdl-dev linux-headers file pulseaudio@testing pulseaudio-utils@testing pulseaudio-dev@testing \
 && wget ftp://ftp.alsa-project.org/pub/lib/alsa-lib-1.1.3.tar.bz2 \
 && bzip2 -d alsa-lib-1.1.3.tar.bz2 \
 && tar xvf alsa-lib-1.1.3.tar \
 && cd alsa-lib-1.1.3 \
 && ./configure \
 && make \
 && make install \
 && cd - \
 && rm -R alsa-lib-1.1.3* \
 && wget ftp://ftp.alsa-project.org/pub/plugins/alsa-plugins-1.1.1.tar.bz2 \
 && bzip2 -d alsa-plugins-1.1.1.tar.bz2 \
 && tar xvf alsa-plugins-1.1.1.tar \
 && cd alsa-plugins-1.1.1 \
 && ./configure --enable-pulseaudio \
 && make \
 && make install \
 && cd - \
 && rm -R alsa-plugins-1.1.1* \
 && apk add --no-cache alsa-utils@testing \
 && mkdir /dosbox \
 && cd /build \
 && patch -p0 < dosbox-0.74.patch \
 && cd dosbox-0.74-2 \
 && ./configure --prefix=/usr \
 && make \
 && make install \
 && apk del build-base sdl-dev linux-headers \
 && rm -R /build
ADD asound.conf /etc/asound.conf

ADD docker-entrypoint-hostpulse.sh /docker-entrypoint.sh
RUN chmod a+x /docker-entrypoint.sh

# Mounting the config and data directory
VOLUME  [/root/.dosbox]
VOLUME  [/dosbox]

ENTRYPOINT [ "/docker-entrypoint.sh" ]
