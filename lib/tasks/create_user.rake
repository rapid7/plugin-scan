namespace :db do
  desc "Creates a new user"
  task :create_user => :environment do
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

    User.create!(
      :username => username,
      :first_name => first_name,
      :last_name => last_name,
      :password => password,
      :password_confirmation => password_confirmation 
    )
  end
end
