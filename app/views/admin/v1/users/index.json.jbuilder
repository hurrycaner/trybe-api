json.users do
  json.array! @users, :id, :name, :email, :image, :profile
end
