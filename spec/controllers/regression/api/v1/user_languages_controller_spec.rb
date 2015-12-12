require 'rails_helper'

RSpec.describe Api::V1::UserLanguagesController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/api/v1/user_languages').to('api/v1/user_languages#index', {}) }
  it { should route(:get, '/api/v1/user_languages/1').to('api/v1/user_languages#show', {:id=>"1"}) }
  it { should route(:post, '/api/v1/user_languages').to('api/v1/user_languages#create', {}) }
  it { should route(:delete, '/api/v1/user_languages/1').to('api/v1/user_languages#destroy', {:id=>"1"}) }
  # === Callbacks (Before) ===
  it { should use_before_filter(:set_user_language) }
  # === Callbacks (After) ===

  # === Callbacks (Around) ===

end
