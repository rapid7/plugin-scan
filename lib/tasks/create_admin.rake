namespace :db do
  desc "Creates a new admin user"
  task :create_admin => :environment do
    feed = Feed.default
    if feed.user_id.present?
      user = User.find_by(id: feed.user_id)
      abort("The default feed is already assigned to '#{user.username}'.")
    end

    puts "\nEnter the username: "
    username = STDIN.gets.chomp
    puts "Enter the first name: "
    first_name = STDIN.gets.chomp
    puts "Enter the last name: "
    last_name = STDIN.gets.chomp
    puts "Password: "
    password = STDIN.gets.chomp
    puts "Password (confirmation): "
    password_confirmation = STDIN.gets.chomp

    puts '[*] Adding admin user'
    user = User.create!(
      :username => username,
      :first_name => first_name,
      :last_name => last_name,
      :password => password,
      :password_confirmation => password_confirmation 
    )
    user.admin = true
    user.save!

    puts '[*] Assigning admin user to default feed'
    feed.user_id = user.id
    feed.save!
  end
end
