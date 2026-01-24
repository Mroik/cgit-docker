FROM debian:13.3-slim

RUN apt update && apt install -y libzip-dev libcrypt-dev libssl-dev libluajit-5.1-dev liblua5.1-0-dev git make gcc libc-dev gettext

RUN mkdir /cgit
COPY cgit /cgit
WORKDIR /cgit
RUN make LUA_PKGCONFIG=luajit
RUN make install

RUN mkdir /output

ENTRYPOINT ["cp", "-r", "/var/www/htdocs/cgit", "/output"]
