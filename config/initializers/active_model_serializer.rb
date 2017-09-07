# frozen_string_literal: true

ActiveModelSerializers.config.adapter = :json_api
ActiveModelSerializers.config.jsonapi_pagination_links_enabled = true
ActiveModelSerializers.config.key_transform = :unaltered
ActiveModelSerializers::Model.derive_attributes_from_names_and_fix_accessors
