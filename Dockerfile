FROM alpine:3.4

ADD [ "dosbox-0.74.tar.gz", "dosbox-0.74.patch", "/build/" ]

RUN apk update \
 && apk add build-base sdl sdl-dev linux-headers \
 && mkdir /dosbox \
 && cd /build \
 && patch -p0 < dosbox-0.74.patch \
 && cd dosbox-0.74 \
 && ./configure --prefix=/usr \
 && make \
 && make install \
 && apk del build-base sdl-dev linux-headers \
 && rm -R /build

# Mounting the config and data directory
VOLUME  [/root/.dosbox]
VOLUME  [/dosbox]

CMD /usr/bin/dosbox
