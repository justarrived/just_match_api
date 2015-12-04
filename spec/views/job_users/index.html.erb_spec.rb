require 'rails_helper'

RSpec.describe "job_users/index", type: :view do
  before(:each) do
    assign(:job_users, [
      JobUser.create!(
        :user => nil,
        :job => nil,
        :accepted => false,
        :role => 1,
        :rate => 2
      ),
      JobUser.create!(
        :user => nil,
        :job => nil,
        :accepted => false,
        :role => 1,
        :rate => 2
      )
    ])
  end

  it "renders a list of job_users" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
