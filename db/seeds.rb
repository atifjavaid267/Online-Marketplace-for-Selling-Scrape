# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(email: 'admin@gmail.com', password: 'admin12345',
             password_confirmation: 'admin12345', role: 'admin', first_name: 'Admin', last_name: 'Admin', phone_no: '03451234567')

# User.find_each { |user| user.update_attribute(:otp_secret_key, User.otp_random_secret) }
