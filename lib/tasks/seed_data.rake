namespace :db do
  desc "Seed the database with production data"
  task seed_production: :environment do
    # Add your seed data here
    user = User.create!(
      name: 'admin',
      email: 'admin@project-i.com',
      password: '123456',
      status: 'admin',
      theme: 'dark',
      language: 'en',
      nationality: 'unknown',
      city: 'unknown'
    )
    user.skip_confirmation!
    user.save!

    20.times do
      user = User.create!(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password: '123456',
        status: 'member',
        theme: 'dark',
        language: 'en',
        nationality: Faker::Address.country,
        city: Faker::Address.city
      )
      user.skip_confirmation!
      user.save!
  end
end
