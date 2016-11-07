# frozen_string_literal: true
module AdminHelpers
  module MachineTranslation
    module Actions

      def self.included(mod)
        mod.instance_eval do
          confirm_msg = I18n.t('admin.machine_translate.confirm_dialog_title')
          batch_action :machine_translate, confirm: confirm_msg do |ids|
            collection.where(id: ids).find_each(batch_size: 1000).each do |model|
              MachineTranslationsJob.perform_later(model.original_translation)
            end

            message = I18n.t('admin.machine_translate.queued_msg_multiple')
            redirect_to collection_path, notice: message
          end

          member_action :machine_translate, method: :post do
            MachineTranslationsJob.perform_later(resource.original_translation)
            message = I18n.t('admin.machine_translate.queued_msg')
            redirect_to(collection_path, notice: message)
          end

          action_item :view, only: :show do
            title = I18n.t('admin.machine_translate.post_btn')
            path_method = "machine_translate_admin_#{resource.model_name.singular}_path"
            link_to title, public_send(path_method, resource), method: :post
          end
        end
      end
    end
  end
end
