Before building you need to download the `cgit` source code. There's already a
reference to it as a submodule. To download just run `git submodule update
--init --recursive`.

After running the container you just configure your webserver to use the exposed
unix socket (`./stuff/fcgi.sock`) with `fastcgi`.

Following a Caddy config example using the official caddy docker alpine image:
```Cadyfile
my.cgit.domain {
	handle_path /static/* {
		root /srv/cgit
		file_server
	}

	handle {
		reverse_proxy unix//fcgi.sock {
			transport fastcgi {
				env SCRIPT_FILENAME /cgit/www/cgit.cgi
			}
		}
	}
}
```

Obviously when using caddy you have to mount the cgit `www` folder onto the
caddy container as well. The same goes for the socket exposed by this container.
So everytime you restart this container you need to restart the caddy container.

Note that `SCRIPT_FILENAME` is set to the location of cgit file in the cgit
container.
