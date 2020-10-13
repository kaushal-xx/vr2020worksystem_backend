json.users (@users||[]) do |user|
	json.partial! 'users/user', user: user
	json.created_by do
		json.partial! 'users/min_user', user: user.created_by
	end
end

json.pagination do
  json.total_page @users.try(:total_pages) if @users.present?
end

json.storage_details do
  json.accessKeyId Rails.application.credentials.dig(:aws, :access_key_id)
  json.secretAccessKey Rails.application.credentials.dig(:aws, :secret_access_key)
  json.region Rails.application.credentials.dig(:aws, :region)
  json.bucket Rails.application.credentials.dig(:aws, :bucket)
end