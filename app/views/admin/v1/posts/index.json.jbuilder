json.posts do
  json.array! @posts do |post|
    json.id post.id
    json.title post.title
    json.content post.content
    json.created_at post.created_at
    json.updated_at post.updated_at
    json.partial! post.user
  end
end
