#!/bin/bash
# nohup redis-server &
rails db:migrate
rails server -b 0.0.0.0
