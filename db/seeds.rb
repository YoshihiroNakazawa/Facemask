# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

100.times do |n|
  if n%6 == 0
    Faker::Config.locale = 'ja'
    name = Faker::Name.name
  elsif n%6 == 1
    name = Faker::Pokemon.name
  elsif n%6 == 2
    name = Faker::Superhero.name
  else
    Faker::Config.locale = 'ja'
    name = Faker::Name.name
  end
  email = "mail#{n}@mail.com"
  password = "testuser"
  confirmed_at = Time.now
  uid = SecureRandom.uuid
  #Faker::Internet.password
  User.create!(email: email, name: name, password: password, password_confirmation: password, confirmed_at: confirmed_at, uid: uid)
end

=begin
100.times do |n|
  title = Faker::Name.title
  if n%4 == 0
    content = Faker::Hacker.say_something_smart
  elsif n%4 == 1
    content = Faker::Yoda.quote
  elsif n%4 == 2
    content = Faker::Shakespeare.hamlet_quote
  else
    content = Faker::Hipster.paragraph
  end
  user_id = rand(100)+1
  Blog.create!(title: title, content: content, user_id: user_id,)
end
=end
