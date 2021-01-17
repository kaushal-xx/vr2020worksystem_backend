if user.present?
	if current_user.role == 'designer' && user.role == 'user'
		json.(user, :id)
	else
		json.(user, :id, :email, :role, :client_name, :first_name, :last_name, :phone, :address1, :address2, :country, :state, :zip_code)
	end
end