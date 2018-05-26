# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def create_admin
  u = User.new({
    name: 'Administrador',
    email: 'admin@stcarga.com.co',
    password: '123456'
  })
  u.save!
  u.be_admin
end

User.delete_all
1.times { create_admin }
