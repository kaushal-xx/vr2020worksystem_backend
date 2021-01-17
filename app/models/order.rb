class Order < ApplicationRecord
  belongs_to :user
  has_many :order_materials
  has_many :order_histories
  has_many :invites

  accepts_nested_attributes_for :order_materials, :allow_destroy => true

  PRIORITIES_ORDERED = ['New', 'Progress', 'Done']

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
    orders = Order.where(search_status)
    orders = orders.where("DATE(orders.created_at) >= ?", params[:min_date]) if params[:min_date].present?
    orders = orders.where("DATE(orders.created_at) <= ?", params[:max_date]) if params[:max_date].present?
    orders = orders.where("orders.id = ?", params[:order_id]) if params[:order_id].present?
    orders = orders.where("orders.document like ?", "%"+params[:document_url]) if params[:document_url].present?
    orders = orders.where("orders.user_id = ?", params[:lab]) if params[:lab].present? && current_user.role != 'user'
    orders = orders.where("orders.user_id = ?", current_user.id) if current_user.role == 'user'
    orders = orders.joins(:invites).where(invites: {user_id: params[:assignee_id]}) if params[:assignee_id].present?
    [orders.order(self.order_by_case).page(page).per(15), orders.group(:status).count]
  end

  def invite_users
  	invites.map(&:user)
  end

  def self.order_by_case
    ret = "CASE"
    PRIORITIES_ORDERED.each_with_index do |p, i|
      ret << " WHEN status = '#{p}' THEN #{i}"
    end
    ret << " END"
  end

end
