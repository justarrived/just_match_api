require 'rails_helper'

RSpec.describe Api::V1::LanguagesController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/api/v1/languages').to('api/v1/languages#index', {}) }
  it { should route(:get, '/api/v1/languages/1').to('api/v1/languages#show', {:id=>"1"}) }
  it { should route(:post, '/api/v1/languages').to('api/v1/languages#create', {}) }
  it { should route(:patch, '/api/v1/languages/1').to('api/v1/languages#update', {:id=>"1"}) }
  it { should route(:delete, '/api/v1/languages/1').to('api/v1/languages#destroy', {:id=>"1"}) }
  # === Callbacks (Before) ===
  it { should use_before_filter(:set_language) }
  # === Callbacks (After) ===

  # === Callbacks (Around) ===

end
