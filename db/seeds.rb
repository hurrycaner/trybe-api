posts_count = Post.count
users_count = User.count
puts 'Deletando Posts, se existirem...'
Post.destroy_all
puts "#{posts_count} excluídos!"
puts '================================='
puts 'Deletando Users, se existirem...'
User.destroy_all
puts "#{users_count} excluídos!"
puts '================================='
puts 'Criando usuário administrativo'

admin = User.create(
  name: 'admin',
  email: 'admin@email.com',
  profile: 'admin',
  image: Faker::Internet.url,
  password: '123456',
  password_confirmation: '123456'
)
puts 'Admin criado com sucesso!'
puts '================================='
puts 'Criando usuários do tipo cliente...'
20.times do
  user = User.create(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    profile: 'client',
    image: Faker::Internet.url,
    password: '123456',
    password_confirmation: '123456'
  )

  puts "Cliente ID:#{user.id} criado com sucesso!"
end

puts '================================='
puts 'Criando posts do Admin'
10.times do
  admin_post = Post.create(
    title: Faker::Game.title,
    content: Faker::ChuckNorris.fact,
    user: admin
  )
  puts "Post ID:#{admin_post} criado com sucesso!"
end
puts '================================='

puts 'Criando posts dos Clientes'
90.times do |n|
  scope_without_admin = User.where.not(id: admin.id)
  client_post = Post.create(
    title: "Title #{n + 1}", # helping the manual test of search feature
    content: Faker::Lorem.paragraph,
    user: scope_without_admin.order(Arel.sql('RANDOM()')).first
  )
  puts "Post ID:#{client_post.id} criado com sucesso!"
end

puts 'Done!'
