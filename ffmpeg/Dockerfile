FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    tar \
    build-essential \
    gcc-mingw-w64-x86-64 \
    gcc-mingw-w64-i686 \
    nasm \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /ffmpeg

COPY build-ffmpeg.sh /build-ffmpeg.sh
RUN chmod +x /build-ffmpeg.sh

CMD ["/build-ffmpeg.sh"]