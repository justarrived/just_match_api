require 'rails_helper'

RSpec.describe "job_skills/new", type: :view do
  before(:each) do
    assign(:job_skill, JobSkill.new(
      :job => nil,
      :skill => nil
    ))
  end

  it "renders new job_skill form" do
    render

    assert_select "form[action=?][method=?]", job_skills_path, "post" do

      assert_select "input#job_skill_job_id[name=?]", "job_skill[job_id]"

      assert_select "input#job_skill_skill_id[name=?]", "job_skill[skill_id]"
    end
  end
end
