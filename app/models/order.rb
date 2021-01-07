class Order < ApplicationRecord
  belongs_to :user
  has_many :order_materials
  has_many :order_histories
  has_many :invites

  accepts_nested_attributes_for :order_materials, :allow_destroy => true

  def document_url
    document
  end

  def stl_file_url
    stl_file
  end

  def self.search(current_user, params = {})
    page = params[:page]||1
    search_params = []
    search_status = {status: params[:status]} if params[:status].present?
    search_params << "created_at >= #{params[:min_date]}" if params[:min_date].present?
    search_params << "created_at <= #{params[:max_date]}" if params[:max_date].present?
    search_params << "id = #{params[:order_id]}" if params[:order_id].present?
    search_params = search_params.join(' and ')
    if current_user.role == 'user'
    	current_user.orders.where(search_params).where(search_status).page(page).per(15)
    else
    	Order.where(search_params).where(search_status).page(page).per(15)
    end
  end

  def invite_users
  	invites.map(&:user)
  end

end
