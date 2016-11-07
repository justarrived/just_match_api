# frozen_string_literal: true
ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        panel 'Recent Candidates' do
          ul do
            JobUser.last(5).map do |job_user|
              li link_to(
                "#{job_user.user.name} applied to #{job_user.job.name}",
                admin_job_user_path(job_user)
              )
            end
          end
        end
      end

      column do
        panel 'Recent Frilans Finans Invoices' do
          ul do
            FrilansFinansInvoice.last(5).map do |ff_invoice|
              li link_to(
                "##{ff_invoice.name}", admin_frilans_finans_invoice_path(ff_invoice)
              )
            end
          end
        end
      end

      column do
        panel 'Recent Users' do
          ul do
            User.last(5).map do |user|
              li link_to(user.name, admin_user_path(user))
            end
          end
        end
      end

      column do
        panel 'Recent Jobs' do
          ul do
            Job.last(5).map do |job|
              li link_to(job.name, admin_job_path(job))
            end
          end
        end
      end
    end
  end # content
end
