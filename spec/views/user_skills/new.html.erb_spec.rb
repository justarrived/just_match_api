require 'rails_helper'

RSpec.describe "user_skills/new", type: :view do
  before(:each) do
    assign(:user_skill, UserSkill.new(
      :user => nil,
      :skill => nil
    ))
  end

  it "renders new user_skill form" do
    render

    assert_select "form[action=?][method=?]", user_skills_path, "post" do

      assert_select "input#user_skill_user_id[name=?]", "user_skill[user_id]"

      assert_select "input#user_skill_skill_id[name=?]", "user_skill[skill_id]"
    end
  end
end
