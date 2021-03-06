# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

system_user = User.new(id: User::SYSTEM_USER_ID, display_name: 'System', email: 'cloud@m6securities.com', site_admin: true)
password = Rails.env.development? ? 'B83WC^?29CgzWGLk' : "#{SecureRandom.alphanumeric(24)}#^@" # needs symbols so...
system_user.password = system_user.password_confirmation = password

puts "Invalid Object: \n#{system_user.errors.messages}" if system_user.invalid?

puts "System User Information; email: 'cloud@m6securities.com' password: #{password}"

system_user.save unless User.exists?(system_user.id)

Setting.create # create the default settings

# create a default market
# market = Market.create(display_name: 'Manius Market', path_name: 'manius', email: 'cloud@m6securities.com')

# system_user.user_market_permissions.create(
# market_id: market.id,
#   formatted_permissions: UserMarketPermission.format_permissions([UserMarketPermission::OWNER])
# )
