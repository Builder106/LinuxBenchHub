#!/bin/bash

# Create or migrate the sqlite databases before booting the server. This
# script replaced the standard bin/docker-entrypoint (still in bin/ for
# reference) to add websockify below, and that db:prepare step got lost
# in the process, so nothing ever created the production/cache/queue/
# cable databases.
bundle exec rails db:prepare

# Start websockify in the background
websockify --web=/path/to/noVNC 5902 $VM_IP:5901 &

# Start your Ruby server
bundle exec rails server