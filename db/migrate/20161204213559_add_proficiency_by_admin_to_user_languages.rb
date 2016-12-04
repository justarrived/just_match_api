class AddProficiencyByAdminToUserLanguages < ActiveRecord::Migration[5.0]
  def change
    add_column :user_languages, :proficiency_by_admin, :integer
  end
end
