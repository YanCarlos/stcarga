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
    active: true,
    identification: '123456' #password_too
  })
  u.be_admin
  u.save!
end

def create_user
  a = User.new({
    name: Faker::Company.name.capitalize,
    email: Faker::Internet.email,
    active: true,
    identification: '123456' #password_too
  })
  role = rand(2)
  if role == 1
    a.be_customer
  else
    a.be_employee
  end
  a.save!
end

User.delete_all
1.times { create_admin }
40.times { create_user }
