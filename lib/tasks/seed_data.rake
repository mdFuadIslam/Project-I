namespace :db do
  desc "Seed the database with production data"
  task seed_production: :environment do
    # Add your seed data here
    User.create!(
      name: 'admin',
      email: 'admin@project-i.com',
      password: '123456',
      status: 'admin',
      theme: 'dark',
      language: 'en',
      nationality: 'unknown',
      city: 'unknown'
    )
  end
end
