namespace :db do
  desc "Seed the database with production data"
  task seed_production: :environment do
    # Add your seed data here
    admin = User.create!(
      name: 'admin',
      email: 'admin@project-i.com',
      password: '123456',
      status: 'admin',
      theme: 'dark',
      language: 'en',
      nationality: 'unknown',
      city: 'unknown'
    )
    admin.skip_confirmation!
    admin.save!

    (1..20).each do |_i|
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


      # Create 3 collections for each user
      3.times do
        collection = Collection.create!(
          name: Faker::Book.publisher,
          description: Faker::Lorem.paragraph,
          category: "Books",
          owner_id: user.id
        )
        puts "Collection created: #{collection.name}"

        # Create 7 items for each collection
        7.times do
          item = Item.create!(
            name: Faker::Book.title,
            tags: Faker::Book.genre,
            collection_id: collection.id,
            owner_id: user.id
          )
          puts "Item created: #{item.name}"
        end
      end
    end
  end
end
