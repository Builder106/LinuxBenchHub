#!/bin/bash

# Start websockify in the background
websockify --web=/path/to/noVNC 5902 $VM_IP:5901 &

# Start your Ruby server
bundle exec rails server