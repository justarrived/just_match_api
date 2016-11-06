# frozen_string_literal: true
module MigrateTranslations
  def self.down
    jobs_down
    comments_down
    users_down
    messages_down
  end

  def self.up(google_translate: false)
    jobs_up(google_translate: google_translate)
    comments_up(google_translate: google_translate)
    users_up(google_translate: google_translate)
    messages_up(google_translate: google_translate)
  end

  def self.jobs_up(google_translate:)
    Job.all.each do |job|
      attributes = {
        name: job[:name],
        description: job[:description],
        short_description: job[:short_description]
      }
      translation = job.create_translation(attributes, job.language_id)
      MachineTranslationsJob.perform_later(translation) if google_translate
    end
  end

  def self.jobs_down
    JobTranslation.delete_all
  end

  def self.comments_up(google_translate:)
    Comment.all.each do |comment|
      attributes = { body: comment[:body] }
      translation = comment.create_translation(attributes, comment.language_id)
      MachineTranslationsJob.perform_later(translation) if google_translate
    end
  end

  def self.comments_down
    CommentTranslation.delete_all
  end

  def self.users_up(google_translate:)
    User.all.each do |user|
      attributes = {
        description: user[:description],
        job_experience: user[:job_experience],
        education: user[:education],
        competence_text: user[:competence_text]
      }
      translation = user.create_translation(attributes, user.language_id)
      MachineTranslationsJob.perform_later(translation) if google_translate
    end
  end

  def self.users_down
    UserTranslation.delete_all
  end

  def self.messages_up(google_translate:)
    Message.all.each do |message|
      attributes = { body: message[:body] }
      translation = message.create_translation(attributes, message.language_id)
      MachineTranslationsJob.perform_later(translation) if google_translate
    end
  end

  def self.messages_down
    MessageTranslation.delete_all
  end
end
