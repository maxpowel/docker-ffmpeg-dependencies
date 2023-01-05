# docker-ffmpeg-dependencies

Due some license limitations, you cannot redistribute an ffmpeg compiled version with some codecs/libs but there is not problem with just compiling the libraries.
It is ok to build by yourself later ffmpeg using them as long as you don't distribute your binary.

This dependency list is based on my own preferences. It does not cover "all" possible dependencies, just some I use so probably it not enough for you. Anyway, the
dockerfile may be helpful to build your own.

I use my built ffmpeg version in my amd64 computer and raspberries (armv7 and aarch64) so all this architectures are available.

# Using it

You can use something like this

```
FROM maxpowel/ffmpeg-dependencies

RUN wget https://ffmpeg.org/releases/ffmpeg-5.0.2.tar.gz
RUN cd ffmpeg && \
./configure \
    --enable-gpl \
    --enable-nonfree \
    --enable-shared \
    --enable-libass \
    --enable-libfdk-aac \
    --enable-libfreetype \
    --enable-libmp3lame \
    --enable-libtheora \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libx264 \
    --enable-libx265 \
    --enable-xlib \
&& make -j 8 && make install


```

# Advise
It is not recommended to take precompiled stuff from random guys over there. For testing and save time it is ok, but when going to production
or doing something important take the time to build it buy yourself. All the work are done by your computer and docker, you only have to run a command and
take a coffee. Don't be lazy when you don't have to ;)


#  Build

The container is built for arm64, armv7 and amd64
```
docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t maxpowel/ffmpeg-dependencies --push .
```
