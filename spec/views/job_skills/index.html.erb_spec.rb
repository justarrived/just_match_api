require 'rails_helper'

RSpec.describe "job_skills/index", type: :view do
  before(:each) do
    assign(:job_skills, [
      JobSkill.create!(
        :job => nil,
        :skill => nil
      ),
      JobSkill.create!(
        :job => nil,
        :skill => nil
      )
    ])
  end

  it "renders a list of job_skills" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
