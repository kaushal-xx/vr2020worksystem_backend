require 'securerandom'
class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:send_varification_code, :need_support]

  def index
    page = params[:page]||1
    if current_user.role == 'admin'
      if params[:role].present?
        @users = User.where(role: params[:role]).page(page).per(15)
      else
        @users = User.all.page(page).per(15)
      end
    end
  end

  def send_varification_code
    user_varification = UserVerification.where(email: params[:email], verified: false).first
    if user_varification.present?
      user_varification.update(token: SecureRandom.urlsafe_base64(5))
    else
      user_varification = UserVerification.create(email: params[:email], verified: false, token: SecureRandom.urlsafe_base64(5))
    end
    UserMailer.send_varification_code(params[:email], user_varification.token).deliver
    render json: { varification_id: user_varification.id }, status: :ok
  end

  def need_support
    user_info = params[:user_info]
    UserMailer.send_need_support(params[:user_info], params[:contant]).deliver
    render json: { message: "Send Support Email" }, status: :ok
  end

  def show
  end

  def update
   if current_user.update(user_params)
     render :show
   else
     render json: { errors: current_user.errors }, status: :unprocessable_entity
   end
  end

  def add_designer
   @user = User.new(designer_params)
   @user.role = 'designer'
   @user.created_by_id = current_user.id
   if @user.save
     render :show
   else
     render json: { errors: @user.errors }, status: :unprocessable_entity
   end
  end

 def get_designer
   @users = User.where(created_by_id: current_user.id, role: 'designer')
 end

  private

  def user_params
    params.require(:user).permit(:email, :password, :first_name, :last_name, :client_name, :phone, :address1, :address2, :country, :state, :zip_code, :varification_code, :varification_id, stl_files: [])
  end

  def designer_params
    params.require(:user).permit(:email, :password, :first_name, :last_name, :client_name)
  end
end