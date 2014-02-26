#!/usr/bin/env puma

environment = 'production'
rails_env = 'production'
ENV['RAILS_ENV'] ||= 'production'

threads 4,8

bind  "unix:///home/rails/apps/character_sheet/shared/tmp/puma/character_sheet.sock"
pidfile "/home/rails/apps/character_sheet/shared/tmp/puma/pid"
state_path "/home/rails/apps/character_sheet/shared/tmp/puma/state"

activate_control_app
