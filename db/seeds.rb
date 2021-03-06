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
    email: 'gerencia@stcarga.com.co',
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
    identification: Faker::Number.number(6) #password_too
  })
  role = rand(2)
  if role == 1
    a.be_customer
  else
    a.be_employee
  end
  a.save!
end

def create_container
  Container.create!(
    code: Faker::Lorem.characters(4).upcase + ' ' + Faker::Number.number(6) + ' ' + Faker::Number.number(1) ,
    delivered: false,
    date_of_entry_to_warehose_at: Date.today,
    start_of_debt_at: Date.today,
    deadline_to_return_at: Date.today + (Faker::Number.number(1).to_i).week,
    user_id: User.with_role(:customer).sample(1)[0].id,
    employee_id: User.find_by(email: 'admin@stcarga.com.co').id
  )
end

def create_empty_container
  c = Container.new({
    id: 0,
    code: 'Sin contenedor',
    delivered: false,
    date_of_entry_to_warehose_at: nil,
    start_of_debt_at: nil,
    deadline_to_return_at: nil,
    user_id: nil,
    employee_id: User.find_by(email: 'admin@stcarga.com.co').id
  })
  c.save(validate: false)
end

def create_product
  p = Product.new({
    name: Faker::Food.dish.upcase,
    reference: Faker::Number.number(6),
    description: Faker::Lorem.sentence(6).upcase,
  })
end

# Audit.delete_all
# Container.delete_all
# User.delete_all
# Product.delete_all
# 1.times { create_admin }
1.times { create_empty_container }
# 10.times { create_user }
# 100.times { create_container }
# 50.times { create_product }
