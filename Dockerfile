FROM alpine:3.9
RUN apk --no-cache add cmake clang clang-dev make gcc g++ libc-dev linux-headers git
WORKDIR /work
RUN mkdir src build install && git clone https://github.com/ambrop72/badvpn src
WORKDIR /work/build
RUN cmake ../src -DBUILD_NOTHING_BY_DEFAULT=1 -DBUILD_UDPGW=1 -DCMAKE_INSTALL_PREFIX=../install && make install

FROM alpine
COPY --from=0 /work/install/bin/badvpn-udpgw /usr/bin/badvpn-udpgw
RUN chmod +x /usr/bin/badvpn-udpgw
CMD ["sh", "-c", "/usr/bin/badvpn-udpgw --listen-addr 0.0.0.0:7300 >/dev/null 2>&1"]