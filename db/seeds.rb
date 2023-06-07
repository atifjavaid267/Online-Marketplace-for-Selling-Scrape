# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(email: 'admin@gmail.com', password: '123456789',
             password_confirmation: '123456789', role: 0, first_name: 'Admin', last_name: 'Admin', phone_no: '03451234567', confirmation_sent_at: Time.zone.now, confirmed_at: Time.zone.now)
