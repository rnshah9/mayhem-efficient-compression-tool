FROM --platform=linux/amd64 ubuntu:20.04 as builder

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential yasm cmake

ADD . /efficient-compression-tool
WORKDIR /efficient-compression-tool/src/build
RUN cmake ..
RUN make -j8

RUN mkdir -p /deps
RUN ldd /efficient-compression-tool/src/build/ect | tr -s '[:blank:]' '\n' | grep '^/' | xargs -I % sh -c 'cp % /deps;'

FROM ubuntu:20.04 as package

COPY --from=builder /deps /deps
COPY --from=builder /efficient-compression-tool/src/build/ect /efficient-compression-tool/src/build/ect
ENV LD_LIBRARY_PATH=/deps
