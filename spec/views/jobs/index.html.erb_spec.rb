require 'rails_helper'

RSpec.describe "jobs/index", type: :view do
  before(:each) do
    assign(:jobs, [
      Job.create!(
        :max_rate => 1,
        :description => "MyText",
        :performed => false
      ),
      Job.create!(
        :max_rate => 1,
        :description => "MyText",
        :performed => false
      )
    ])
  end

  it "renders a list of jobs" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
