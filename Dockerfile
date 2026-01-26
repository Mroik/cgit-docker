FROM debian:13.3-slim as builder

RUN apt update && apt install -y libzip-dev libcrypt-dev libssl-dev libluajit-5.1-dev liblua5.1-0-dev git make gcc libc-dev gettext

RUN mkdir /cgit
COPY cgit-src /cgit
WORKDIR /cgit
RUN make LUA_PKGCONFIG=luajit
RUN make install


FROM debian:13.3-slim

RUN apt update && apt install -y fcgiwrap libluajit-5.1-2 luajit python3 python3-markdown
RUN mkdir /cgit
RUN mkdir /cgit/www
RUN mkdir /cgit/filters
WORKDIR /cgit
COPY --from=builder /var/www/htdocs/cgit /cgit/www
COPY --from=builder /usr/local/lib/cgit/filters /cgit/filters

ENTRYPOINT ["fcgiwrap", "-s", "unix:/stuff/fcgi.sock"]
