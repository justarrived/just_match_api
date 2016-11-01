# frozen_string_literal: true
module MigrateTranslations
  def self.down
    jobs_down
    comments_down
  end

  def self.up
    jobs_up
    comments_up
  end

  def self.jobs_up
    Job.all.each do |job|
      attributes = {
        name: job[:name],
        description: job[:description],
        short_description: job[:short_description]
      }
      job.create_translation(attributes, job.language_id)
    end
  end

  def self.jobs_down
    JobTranslation.delete_all
  end

  def self.comments_up
    Comment.all.each do |comment|
      attributes = { body: comment[:body] }
      comment.create_translation(attributes, comment.language_id)
    end
  end

  def self.comments_down
    CommentTranslation.delete_all
  end
end
