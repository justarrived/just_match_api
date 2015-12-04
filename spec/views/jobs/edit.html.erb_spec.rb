require 'rails_helper'

RSpec.describe "jobs/edit", type: :view do
  before(:each) do
    @job = assign(:job, Job.create!(
      :max_rate => 1,
      :description => "MyText",
      :performed => false
    ))
  end

  it "renders the edit job form" do
    render

    assert_select "form[action=?][method=?]", job_path(@job), "post" do

      assert_select "input#job_max_rate[name=?]", "job[max_rate]"

      assert_select "textarea#job_description[name=?]", "job[description]"

      assert_select "input#job_performed[name=?]", "job[performed]"
    end
  end
end
