RSpec.configure do |config|
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :system
  
  config.before(:each, type: :request) do
    host! 'localhost:3000'
  end
end
