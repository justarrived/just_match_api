require 'rails_helper'

RSpec.describe "job_users/show", type: :view do
  before(:each) do
    @job_user = assign(:job_user, JobUser.create!(
      :user => nil,
      :job => nil,
      :accepted => false,
      :role => 1,
      :rate => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
  end
end
