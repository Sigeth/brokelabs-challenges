#!/bin/sh
# Runs as root when the instance starts: three services, no firewall.
set -eu

serve() { # name port directory description
  mkdir -p "$3"
  cat > "/etc/systemd/system/$1.service" <<UNIT
[Unit]
Description=$4

[Service]
ExecStart=/usr/bin/python3 -m http.server $2 --directory $3
Restart=always

[Install]
WantedBy=multi-user.target
UNIT
  systemctl enable --now "$1"
}

echo '<h1>Welcome to example.org</h1>' > /tmp/index.html
mkdir -p /srv/www && mv /tmp/index.html /srv/www/index.html
serve website 80 /srv/www "Public website"

mkdir -p /srv/admin && echo '<h1>Admin panel</h1><p>internal use only</p>' > /srv/admin/index.html
serve admin-panel 8080 /srv/admin "Internal admin panel"

mkdir -p /srv/metrics && echo 'requests_total 42' > /srv/metrics/index.html
serve metrics 9100 /srv/metrics "Metrics endpoint (debug)"
