FROM ubuntu AS build

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y beignet-opencl-icd
RUN apt-get install -y build-essential
RUN apt-get install -y cmake
RUN apt-get install -y git
RUN apt-get install -y libavcodec-dev
RUN apt-get install -y libc6-dev
RUN apt-get install -y libexpat1-dev
RUN apt-get install -y libgl1-mesa-dev
RUN apt-get install -y libopencv-dev
RUN apt-get install -y libssl-dev
RUN apt-get install -y ocl-icd-opencl-dev
RUN apt-get install -y opencl-headers
RUN apt-get install -y pkg-config
RUN apt-get install -y python3-opencv
RUN apt-get install -y zlib1g-dev

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
