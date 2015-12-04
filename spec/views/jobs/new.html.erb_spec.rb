require 'rails_helper'

RSpec.describe "jobs/new", type: :view do
  before(:each) do
    assign(:job, Job.new(
      :max_rate => 1,
      :description => "MyText",
      :performed => false
    ))
  end

  it "renders new job form" do
    render

    assert_select "form[action=?][method=?]", jobs_path, "post" do

      assert_select "input#job_max_rate[name=?]", "job[max_rate]"

      assert_select "textarea#job_description[name=?]", "job[description]"

      assert_select "input#job_performed[name=?]", "job[performed]"
    end
  end
end
