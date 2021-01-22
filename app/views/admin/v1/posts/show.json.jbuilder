json.post do
  json.call(@post, :id, :created_at, :updated_at, :title, :content, :user)
end
