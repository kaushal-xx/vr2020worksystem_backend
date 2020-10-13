json.array! @users do |user|
  json.partial! 'users/user', user: user
  json.created_by do
  	json.partial! 'users/min_user', user: user.created_by
  end
end