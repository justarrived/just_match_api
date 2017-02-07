# frozen_string_literal: true
require 'global_phone'

GlobalPhone.db_path = Rails.root.join('db', 'global_phone.json').to_s
