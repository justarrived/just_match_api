# frozen_string_literal: true
# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
Mime::Type.register 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', :docx # rubocop:disable Metrics/LineLength
Mime::Type.register 'application/vnd.oasis.opendocument.text', :odt
Mime::Type.register 'text/plain', :txt
Mime::Type.register 'application/rtf', :rtf
Mime::Type.register 'application/x-ole-storage', :doc
