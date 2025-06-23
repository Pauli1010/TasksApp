# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

user_data = [
  { user_name: 'Admin', email: 'admin@example.com', password: 'Test123!', password_confirmation: 'Test123!', admin: true },
  { user_name: 'Normal User', email: 'normal@example.com', password: 'Test123!', password_confirmation: 'Test123!' },
]

user_data.each do |user_params|
  # next if User.find_by(email: user_params[:email])

  user = User.find_by(email: user_params[:email]) || User.create(user_params)
  user.activate! if user.activation_state_pending?
end

dictionaries = [
  { name: 'Books', items: ['Horror', 'Romance', 'Comedy'] },
  { name: 'Food', items: ['Vegetables', 'Fruits', 'Dairy', 'Meat', 'Pasta'] },
  { name: 'Months', items: ['January', 'February', 'March', 'April'] }
]

dictionaries.each do |dictionary_params|
  dictionary = Dictionary.find_or_create_by(name: dictionary_params[:name])
  dictionary_params[:items].each do |item|
    DictionaryItem.find_or_create_by(dictionary: dictionary, name: item)
  end
end
