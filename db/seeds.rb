User.create! name: "Admin User",
  email: "example@railstutorial.org",
  password: "123456",
  password_confirmation: "123456",
  is_admin: true

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create! name: name,
    email: email,
    password: password,
    password_confirmation: password
end

20.times do
  name = Faker::Lorem.words(rand(3..4)).join " "
  description = Faker::Lorem.paragraph sentence_count = 1,
    supplemental = false, random_sentences_to_add = 1
  Category.create! name: name,
    description: description
end

100.times do |n|
  content = Faker::Lorem.word + "#{n}"
  category = Category.order("RANDOM()").first
  category.words.create!(content: content,
    answers: Answer.create([
      {content: Faker::Lorem.word, is_correct: true},
      {content: Faker::Lorem.word, is_correct: false},
      {content: Faker::Lorem.word, is_correct: false},
      {content: Faker::Lorem.word, is_correct: false}
  ]))
end

Lesson.create! user_id: 1, category_id: 15,
  results: Result.create([
    {word_id: 1, answer_id: 2},
    {word_id: 2, answer_id: 5},
    {word_id: 3, answer_id: 7},
    {word_id: 4, answer_id: 12},
    {word_id: 5, answer_id: 16}
  ])
