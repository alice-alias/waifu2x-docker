FROM ubuntu AS build

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y \
    git \
    \
    g++ \
    cmake \
    \
    libavcodec-dev \
    libc6-dev \
    libexpat1-dev \
    libgl1-mesa-dev \
    libopencv-dev \
    libssl-dev \
    ocl-icd-opencl-dev \
    opencl-headers \
    pkg-config \
    python3-opencv \
    zlib1g-dev

WORKDIR /root

RUN git clone --depth 1 https://github.com/DeadSix27/waifu2x-converter-cpp

WORKDIR /root/waifu2x-converter-cpp/out

RUN cmake ..
RUN make -j4
RUN make install
RUN ldconfig

FROM ubuntu

RUN apt-get update && apt-get install -y \
    libopencv-imgcodecs4.2 \
 && rm -rf /var/lib/apt/lists/*

COPY --from=build /usr/local/lib/libw2xc.so /usr/local/lib/libw2xc.so
COPY --from=build /usr/local/bin/waifu2x-converter-cpp /usr/local/bin/waifu2x-converter-cpp
COPY --from=build /usr/local/share/waifu2x-converter-cpp /usr/local/share/waifu2x-converter-cpp

RUN ldconfig
