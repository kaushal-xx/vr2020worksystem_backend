if user.present?
	json.(user, :id, :email, :role, :client_name, :authentication_token, :attachments, :first_name, :last_name, :phone, :address1, :address2, :country, :state, :zip_code, :stl_files)
end