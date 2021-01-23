json.post do
  json.call(@post, :id, :created_at, :updated_at, :title, :content)
  json.partial! @post.user
end
