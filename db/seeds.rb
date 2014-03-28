['registered', 'banned', 'admin'].each do |role|
  Role.create(name: role)
end

User.create! :name => 'Eddie Fisher', :email => 'admin@example.com', :password => 'password', :password_confirmation => 'password'
