RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before do
    FactoryBot.find_definitions if FactoryBot.factories.count.zero?
  end
end
