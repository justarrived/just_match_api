class AddMissingKeys < ActiveRecord::Migration
  def change
    add_foreign_key "communication_template_translations", "communication_templates", name: "communication_template_translations_communication_template_id_fk"
  end
end
