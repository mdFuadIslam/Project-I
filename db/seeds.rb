User.create!(
  name: 'admin',
  email: 'admin@project-i.com',
  password: '123456',
  status: 'admin',
  theme: 'dark',
  language: 'en',
  nationality: 'unknown',
  city: 'unknown',
  confirmed_at: Time.current
)
puts "admin created"


20.times do
  user = User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: '123456',
    status: 'member',
    theme: 'dark',
    language: 'en',
    nationality: Faker::Address.country,
    city: Faker::Address.city,
    confirmed_at: Time.current
  )
  puts "User created: #{user.name}"
end
