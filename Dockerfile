FROM debian:13.3-slim as builder

RUN apt update && apt install -y libzip-dev libcrypt-dev libssl-dev libluajit-5.1-dev liblua5.1-0-dev git make gcc libc-dev gettext

RUN mkdir /cgit
COPY cgit-src /cgit
WORKDIR /cgit
RUN make LUA_PKGCONFIG=luajit
RUN make install


FROM alpine:3.23.2

RUN apk add fcgiwrap luajit python3 py3-markdown gcompat patchelf musl-dev
RUN mkdir /cgit
RUN mkdir /cgit/www
RUN mkdir /cgit/filters
WORKDIR /cgit
COPY --from=builder /var/www/htdocs/cgit /cgit/www
COPY --from=builder /usr/local/lib/cgit/filters /cgit/filters
RUN patchelf --add-needed libgcompat.so.0 /cgit/www/cgit.cgi

ENTRYPOINT ["fcgiwrap", "-s", "unix:/stuff/fcgi.sock"]
