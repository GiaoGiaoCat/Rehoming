# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

victor = User.create(unionid: '11xzxvzcvasvas1', nickname: 'Victor', headimgurl: 'ba.jpg')
group_a = Group.create(title: 'Free Group', category: 10)
post = Post.create(user_id: victor.id, group_id: group_a.id, content: 'hahaha')
