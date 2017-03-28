# frozen_string_literal: true
class JobUserMailer < ApplicationMailer
  default from: DEFAULT_SUPPORT_EMAIL

  def new_applicant_job_info_email(job_user:, skills:, languages:)
    user = job_user.user
    @user_name = user.first_name
    @job_name = job_user.job.name

    skill_names = skills.map(&:name)
    language_names = languages.map { |language| language.name_for(I18n.locale) }
    @competence_names = skill_names + language_names

    @user_edit_url = FrontendRouter.draw(:user_edit, id: user.id)

    subject = I18n.t('mailer.new_applicant_job_info.subject')
    mail(to: user.contact_email, subject: subject)
  end
end
