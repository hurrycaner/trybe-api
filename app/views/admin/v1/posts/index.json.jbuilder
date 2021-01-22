json.posts do
  json.array! @posts, :id, :created_at, :updated_at,
              :title, :content, :user
end
