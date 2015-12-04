require 'rails_helper'

RSpec.describe "user_skills/index", type: :view do
  before(:each) do
    assign(:user_skills, [
      UserSkill.create!(
        :user => nil,
        :skill => nil
      ),
      UserSkill.create!(
        :user => nil,
        :skill => nil
      )
    ])
  end

  it "renders a list of user_skills" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
