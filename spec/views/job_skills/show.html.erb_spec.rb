require 'rails_helper'

RSpec.describe "job_skills/show", type: :view do
  before(:each) do
    @job_skill = assign(:job_skill, JobSkill.create!(
      :job => nil,
      :skill => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
