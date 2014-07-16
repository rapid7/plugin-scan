require 'securerandom'
require 'fileutils'

# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
secret_directory  = File.expand_path(File.join(File.dirname(__FILE__), ".."))
secret_file       = File.join(secret_directory, "rails.key")
unless File.exists?(secret_file)
  File.open(secret_file, "wb") do |fd|
    FileUtils.chmod 0700, secret_file
    fd.write(SecureRandom.hex(128))
  end

end

Myapp::Application.config.secret_token = File.read(secret_file)
