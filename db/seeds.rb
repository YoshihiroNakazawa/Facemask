# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
##
## 重複なし乱数の生成(Fisher-Yates改)
##
#
# 長さNで(0 .. N-1)の重複しない乱数の繰り返し
#
# UniqRand.new(size) : 長さsizeで乱数を初期化
# UniqRand.getNext : 乱数を取り出す
#
Faker::Config.locale = 'ja'

100.times do |n|
  if n%6 == 0
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

User.create!(email: "admin@mail.com", name: "admin", password: "adminpass", password_confirmation: "adminpass", confirmed_at: Time.now, uid: SecureRandom.uuid)

1000.times do |n|
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
  Topic.create!(title: title, content: content, user_id: user_id,)
end

1000.times do |n|
  if n%4 == 0
    content = Faker::Hacker.say_something_smart
  elsif n%4 == 1
    content = Faker::Yoda.quote
  elsif n%4 == 2
    content = Faker::Shakespeare.hamlet_quote
  else
    content = Faker::Hipster.paragraph
  end
  topic_id = rand(1000)+1
  user_id = rand(100)+1
  Comment.create!(content: content, user_id: user_id, topic_id: topic_id)
end

(1..100).each do |n1|
  follower_id = n1
  u = UniqRand.new(100)
  30.times do |n2|
    followed_id = u.getNext
    if followed_id > 0 && followed_id < 101 && follower_id != followed_id
      Relationship.create(follower_id: follower_id, followed_id: followed_id)
    end
  end
end

(1..100).each do |n1|
  (n1+1..100).each do |n2|
    if rand(100)%5==0
      Conversation.create!(sender_id: n1, recipient_id: n2)
    end
  end
end

conversations = Conversation.all
conversations.each do |c|
  n = rand(10)
  n.times do |n1|
    if n1%4 == 0
      user_id = c.sender_id
      body = Faker::Hacker.say_something_smart
    elsif n1%4 == 1
      user_id = c.recipient_id
      body = Faker::Yoda.quote
    elsif n1%4 == 2
      user_id = c.sender_id
      body = Faker::Shakespeare.hamlet_quote
    else
      user_id = c.recipient_id
      body = Faker::Hipster.paragraph
    end
    Message.create!(body: body, conversation_id: c.id, user_id: user_id)
  end
end
