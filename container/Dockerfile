FROM opencast-registry.ctest.univie.ac.at/ffmpeg-builder:latest

RUN git clone https://github.com/ggerganov/whisper.cpp.git \
 && cd whisper.cpp \
 && make \
 && mv main /usr/local/bin/whisperc \
 && mkdir -p /var/lib/whisper
