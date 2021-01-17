json.lab do
	json.array! @user_data do |user_data|
		json.partial! 'users/min_user', user: user_data[:user]
		json.order_count user_data[:orders]

	end
end

json.designer do
	json.array! @designer_data.each do |user_data|
		json.partial! 'users/min_user', user: user_data[:user]
		json.order_count user_data[:orders]
	end
end