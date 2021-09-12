# frozen_string_literal: true

# handles creating and getting the instance var
class InstanceVar

  # generates an instance variable from the git commit. If that cannot be done, it generates a random number.
  def self.new_instance
    git_commit = `git rev-parse HEAD`.strip!
    heroku_commit = ENV['HEROKU_SLUG_COMMIT']

    version = if !git_commit.blank?
                git_commit
              elsif !heroku_commit.blank?
                heroku_commit
              else
                SecureRandom.alphanumeric(40)
              end
    Rails.cache.write('instance_var', version, expires_in: 48.hours) # heroku dynos restart every 24 hours give or take, so this technically shouldn't expire in production

    puts "New Instance Variable: #{version}"

    # GIT_COMMIT = version

    version
  end

  # returns the instance variable. If it doesn't exist, it generates it
  def self.get_instance
    version = Rails.cache.read('instance_var')

    version = new_instance if version.blank?

    version
  end

end