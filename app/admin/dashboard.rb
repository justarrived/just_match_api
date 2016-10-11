# frozen_string_literal: true
ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        panel 'Recent Jobs' do
          ul do
            Job.last(5).map do |job|
              li link_to(job.name, admin_job_path(job))
            end
          end
        end
      end

      column do
        panel 'Info' do
          para 'Welcome to Just Arrived Admin Interface.'
        end
      end
    end
  end # content
end
