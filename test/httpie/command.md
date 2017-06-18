## 用户

### 微信用户登录
`http POST :3000/sessions Accept:application/json Content-type:application/json data:=@~/Documents/Projects/Rehoming/test/httpie/sessions.json`


## 帖子

### 发帖
`http POST :3000/posts Accept:application/json Content-type:application/json data:=@~/Documents/Projects/Rehoming/test/httpie/post.json`

## 测试 token

`JsonWebToken.encode { user_id: User.first.to_param }`

`http :3000/forums/1/posts Authorization:eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiN2EyNGY3NzMwNTBhNTZjOTc2OTE4ZjBkMTM3MzgzNTMiLCJleHAiOjE1MDAzNTQ2NTYsImlzcyI6IlJlaG9taW5nIEFQSSBWMS4wIn0.iGQCf3-XUsQFY1iz7NoGNNYFuShSPK3dCfe-YsSPB5E`
