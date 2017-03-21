FROM alpine:edge

ADD [ "dosbox-0.74.tar.gz", "dosbox-0.74.patch", "/build/" ]

RUN apk add --no-cache sdl libxxf86vm libstdc++ libgcc build-base sdl-dev linux-headers file \
 && mkdir /dosbox \
 && cd /build \
 && patch -p0 < dosbox-0.74.patch \
 && cd dosbox-0.74 \
 && ./configure --prefix=/usr \
 && make \
 && make install \
 && apk del build-base sdl-dev linux-headers \
 && rm -R /build

ADD docker-entrypoint-noaudio.sh /docker-entrypoint.sh
RUN chmod a+x /docker-entrypoint.sh

# Mounting the config and data directory
VOLUME  [/root/.dosbox]
VOLUME  [/dosbox]

ENTRYPOINT [ "/docker-entrypoint.sh" ]
