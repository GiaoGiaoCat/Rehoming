# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

victor = User.create(unionid: '11xzxvzcvasvas1', nickname: 'Victor', headimgurl: 'ba.jpg')
yuki = User.create(unionid: 'u3YBkQDBVetKaVJknprv', nickname: 'Yuki', headimgurl: 'ba.jpg')
roc = User.create(unionid: 'RwcP9YchpgxLDgzwAjmb', nickname: 'Roc', headimgurl: 'ba.jpg')

forum_a = Forum.create(name: 'Free Group', category: 10)

victor.join_forum(forum_a)
yuki.join_forum(forum_a)


# victor.forum_memberships.find_by(forum: forum_a).accept
# yuki.forum_memberships.find_by(forum: forum_a).accept

victor.forum_memberships.find_by(forum: forum_a).preference.update(nickname: '老王')
yuki.forum_memberships.find_by(forum: forum_a).preference.update(nickname: '小陈')

post = Post.create(user_id: victor.id, forum_id: forum_a.id, content: 'hahaha', sticky: true, recommended: true)
post.attachments.create(category: 'image', url: 'http://www.baidu.com/a.jpg')
post.attachments.create(category: 'image', url: 'http://www.baidu.com/b.jpg')
post.attachments.create(category: 'video', url: 'http://www.baidu.com/c.avi')


Post.create(user_id: victor.id, forum_id: forum_a.id, content: 'today is fine')
Post.create(user_id: yuki.id, forum_id: forum_a.id, content: 'cool man')

comment = post.comments.create(author: victor, content: 'commment with attachments')
post.comments.create(author: yuki, content: 'reply to victor', replied_user_id: victor.id)
comment.attachments.create(category: 'image', url: 'http://www.baidu.com/hello.jpg')
15.times do |i|
  post.comments.create(author: victor, content: "this is the #{i} commment.")
end

victor.favor post
victor.like post
yuki.like post

20.times do
  Feeds::CreateForm.create({
    sourceable_id: Post.last.id, sourceable_type: Post.first.class,
    creator_id: User.last.id, user_id: User.first.id, event: 'new_post'
  })
end

20.times do
  Feeds::CreateForm.create({
    sourceable_id: Post.first.id, sourceable_type: Post.first.class,
    creator_id: User.last.id, user_id: User.first.id, event: 'new_post'
  })
end
