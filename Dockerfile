FROM --platform=linux/amd64 ubuntu:20.04

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential yasm cmake

ADD . /efficient-compression-tool
WORKDIR /efficient-compression-tool/src/build
RUN cmake ..
RUN make -j8
