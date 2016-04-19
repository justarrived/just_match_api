# frozen_string_literal: true

# TODO: Set the URL
aws_s3_url = ':s3_domain_url'
aws_paperclip_path = '/:class/:attachment/:id_partition/:style/:filename'

Paperclip::Attachment.default_options[:url] = aws_s3_url
Paperclip::Attachment.default_options[:path] = aws_paperclip_path

if Rails.env.test?
  paper_part = ':class/:id_partition/:style.:extension'
  paperclip_path = "spec/test_files/#{paper_part}"
  Paperclip::Attachment.default_options[:path] = paperclip_path
end
