#!/bin/bash

# Start Transmission
transmission-daemon -g /etc/transmission-daemon &

# Start FileBrowser
filebrowser -c /etc/filebrowser/filebrowser.db &

# Start Nginx (reverse proxy)
nginx -g "daemon off;" &

# Prevent container from exiting
tail -f /dev/null
