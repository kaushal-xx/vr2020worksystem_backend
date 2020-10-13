json.user do |json|
  json.partial! 'users/user', user: @user||current_user
  json.created_by do
  	json.partial! 'users/min_user', user:(@user||current_user).created_by
  end
end

json.storage_details do
  json.accessKeyId Rails.application.credentials.dig(:aws, :access_key_id)
  json.secretAccessKey Rails.application.credentials.dig(:aws, :secret_access_key)
  json.region Rails.application.credentials.dig(:aws, :region)
  json.bucket Rails.application.credentials.dig(:aws, :bucket)
end