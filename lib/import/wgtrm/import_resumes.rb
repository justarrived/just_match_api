# frozen_string_literal: true
module Wgtrm
  class ImportResumes
    UserMap = Struct.new(:user, :slug)

    def initialize(glob_path: 'tmp/wgrtm-resumes/*')
      @paths = Dir[glob_path]
      @user_map = User.all.map do |user|
        UserMap.new(user.id, to_slug(user.name))
      end
    end

    def commit
      @commit ||= begin
        @paths.map do |path|
          file = File.open(path, 'rb')
          file_name = Pathname.new(file).basename.to_s

          user = @user_map.detect { |map| file_name.include?(map.slug) }&.user
          next if user.nil?

          document = Document.create!(document: file)
          UserDocument.create!(user: user, document: document, category: :cv)
        end
      end
    end

    private

    # https://stackoverflow.com/questions/1302022/best-way-to-generate-slugs-human-readable-ids-in-rails
    def to_slug(name)
      # strip the string
      ret = name.strip.downcase

      # blow away apostrophes
      ret.gsub!(/['`]/, '')

      #  @ --> at, and & --> and
      ret.gsub!(/\s*@\s*/, ' at ')
      ret.gsub!(/\s*&\s*/, ' and ')

      # replace all non alphanumeric, underscore or periods with underscore
      ret.gsub!(/\s*[^A-Za-z0-9\.\-]\s*/, '_')

      # convert double underscores to single
      ret.gsub!(/_+/, '_')

      # strip off leading/trailing underscore
      ret.gsub!(/\A[_\.]+|[_\.]+\z/, '')

      ret
    end
  end
end
