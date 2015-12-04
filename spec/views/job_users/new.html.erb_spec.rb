require 'rails_helper'

RSpec.describe "job_users/new", type: :view do
  before(:each) do
    assign(:job_user, JobUser.new(
      :user => nil,
      :job => nil,
      :accepted => false,
      :role => 1,
      :rate => 1
    ))
  end

  it "renders new job_user form" do
    render

    assert_select "form[action=?][method=?]", job_users_path, "post" do

      assert_select "input#job_user_user_id[name=?]", "job_user[user_id]"

      assert_select "input#job_user_job_id[name=?]", "job_user[job_id]"

      assert_select "input#job_user_accepted[name=?]", "job_user[accepted]"

      assert_select "input#job_user_role[name=?]", "job_user[role]"

      assert_select "input#job_user_rate[name=?]", "job_user[rate]"
    end
  end
end
