#!/usr/bin/env bash
/usr/bin/caddy start --config /etc/caddy/Caddyfile
/ServerStatus/server/sergate --config=/ServerStatus/server/config.json --web-dir=/usr/share/caddy
