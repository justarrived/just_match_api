# frozen_string_literal: true

ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        panel link_to(I18n.t('admin.recent_jobs.title'), admin_jobs_path) do
          scope = Job.with_translations.
                  includes(:hourly_pay).
                  where(just_arrived_contact: authenticated_admin).
                  left_joins(:job_users).
                  select('jobs.*, count(job_users.id) as job_users_count').
                  group('jobs.id, job_users.job_id').
                  order(created_at: :desc).
                  limit(20)

          table_for(scope) do
            column(:applicants) do |job|
              column_content = safe_join([
                                           user_icon_png(html_class: 'table-column-icon'),
                                           job.job_users_count
                                         ])
              column_content
            end

            column(I18n.t('admin.recent_jobs.name')) do |job|
              link_to(truncate(job.display_name), admin_job_path(job))
            end

            column(I18n.t('admin.recent_jobs.hours')) do |job|
              job.hours.round(0)
            end

            column(I18n.t('admin.recent_jobs.hourly_pay')) do |job|
              job.hourly_pay.gross_salary
            end

            column(I18n.t('admin.recent_jobs.start_date')) do |job|
              now_time = Time.now.utc
              job_date = job.job_date

              time_in_words = distance_of_time_in_words(now_time, job_date)

              if now_time > job_date
                I18n.t('admin.time_ago', time: time_in_words)
              else
                I18n.t('admin.time_from_now', time: time_in_words)
              end
            end

            column(I18n.t('admin.recent_jobs.filled')) do |job|
              status_tag(job.filled)
            end
          end
        end
      end

      column do
        panel link_to(I18n.t('admin.recent_ff_invoices.title'), admin_frilans_finans_invoices_path) do # rubocop:disable Metrics/LineLength
          scope = FrilansFinansInvoice.order(created_at: :desc).
                  includes(:job_user, :user, job: %i(translations language)).
                  limit(20)

          table_for(scope) do
            column(I18n.t('admin.recent_ff_invoices.status')) do |ff_invoice|
              paid_status = FrilansFinansInvoice::FF_PAID_STATUS
              default_status_name = I18n.t('admin.frilans_finans_invoice.not_paid')
              status_tag(
                ff_invoice.ff_status_name || default_status_name,
                ff_invoice.ff_status == paid_status ? :yes : :warning
              )
            end
            column(I18n.t('admin.recent_ff_invoices.id')) do |ff_invoice|
              link_to(
                "##{ff_invoice.id}", admin_frilans_finans_invoice_path(ff_invoice)
              )
            end

            column(I18n.t('admin.job_user_name')) do |ff_invoice|
              link_to(
                ff_invoice.job_user.name,
                admin_job_user_path(ff_invoice.job_user)
              )
            end

            column(I18n.t('admin.job_name')) do |ff_invoice|
              link_to(
                truncate(ff_invoice.job.original_name),
                admin_job_path(ff_invoice.job)
              )
            end

            column(I18n.t('admin.user_name')) do |ff_invoice|
              link_to(
                ff_invoice.user.name,
                admin_user_path(ff_invoice.user)
              )
            end
          end
        end
      end
    end

    columns do
      column do
        panel link_to(I18n.t('admin.recent_users.title'), admin_users_path) do
          table_for User.includes(:system_language).order(created_at: :desc).limit(20) do
            column(I18n.t('admin.user.verified')) do |user|
              status_tag(user.verified)
            end

            column(I18n.t('admin.user.locale')) do |user|
              truncate(user.locale)
            end

            column(I18n.t('admin.user.email')) do |user|
              truncate(user.email)
            end

            column(I18n.t('admin.user.name')) do |user|
              link_to(user.display_name, admin_user_path(user))
            end

            column(I18n.t('admin.user.company')) do |user|
              status_tag(user.company?)
            end
          end
        end
      end

      column do
        panel(link_to(I18n.t('admin.recent_job_users.title'), admin_job_users_path)) do
          scope = JobUser.order(created_at: :desc).
                  includes(:user, job: %i(translations language)).
                  limit(20)

          table_for(scope) do
            column(I18n.t('admin.recent_job_users.accepted')) do |job_user|
              status_tag(job_user.accepted)
            end

            column(I18n.t('admin.recent_job_users.will_perform')) do |job_user|
              status_tag(job_user.will_perform)
            end

            column(I18n.t('admin.recent_job_users.id')) do |job_user|
              link_to("##{job_user.id}", admin_job_user_path(job_user))
            end

            column(I18n.t('admin.recent_job_users.job')) do |job_user|
              link_to(
                truncate(job_user.job.display_name),
                admin_job_path(job_user.job)
              )
            end

            column(I18n.t('admin.recent_job_users.user')) do |job_user|
              link_to(job_user.user.name, admin_user_path(job_user.user))
            end
          end
        end
      end
    end

    columns do
      column do
        panel(link_to(I18n.t('admin.no_invoice_job_users.title'), admin_job_users_path)) do # rubocop:disable Metrics/LineLength
          scope = JobUser.order(created_at: :desc).
                  includes(:user,
                           job: %i(translations language)).
                  where(will_perform: true,
                        application_withdrawn: false,
                        'jobs.job_end_date': Time.at(0).utc..Time.now.utc,
                        'jobs.cancelled': false,
                        'frilans_finans_invoices.id': nil).
                  left_joins(:frilans_finans_invoice).
                  limit(20)

          table_for(scope) do
            column(I18n.t('admin.no_invoice_job_users.id')) do |job_user|
              link_to("##{job_user.id}", admin_job_user_path(job_user))
            end

            column(I18n.t('admin.no_invoice_job_users.job')) do |job_user|
              link_to(
                truncate(job_user.job.display_name),
                admin_job_path(job_user.job)
              )
            end

            column(I18n.t('admin.no_invoice_job_users.user')) do |job_user|
              link_to(job_user.user.name, admin_user_path(job_user.user))
            end
          end
        end
      end
    end
  end
end
