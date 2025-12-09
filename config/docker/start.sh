#!/bin/bash
# nohup redis-server &
rails db:migrate
# Start Rails server without PID file to avoid permission issues
rails server -b 0.0.0.0 -P /tmp/server.pid
