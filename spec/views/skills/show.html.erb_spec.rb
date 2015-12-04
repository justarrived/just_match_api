require 'rails_helper'

RSpec.describe "skills/show", type: :view do
  before(:each) do
    @skill = assign(:skill, Skill.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
