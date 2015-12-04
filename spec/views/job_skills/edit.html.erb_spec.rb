require 'rails_helper'

RSpec.describe "job_skills/edit", type: :view do
  before(:each) do
    @job_skill = assign(:job_skill, JobSkill.create!(
      :job => nil,
      :skill => nil
    ))
  end

  it "renders the edit job_skill form" do
    render

    assert_select "form[action=?][method=?]", job_skill_path(@job_skill), "post" do

      assert_select "input#job_skill_job_id[name=?]", "job_skill[job_id]"

      assert_select "input#job_skill_skill_id[name=?]", "job_skill[skill_id]"
    end
  end
end
