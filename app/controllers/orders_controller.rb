class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = Order.search(current_user, params)
  end

  def status_count
    orders = if current_user.role == 'user'
      current_user.orders.group(:status).count
    else
      Order.group(:status).count
    end
    render json: orders
  end

 def create
  @order = current_user.orders.new(order_params)
  if @order.save
    OrderHistory.create_obj(@order.id, {}, @order.attributes)
    render :show
  else
    render json: { errors: @order.errors }, status: :unprocessable_entity
  end
 end

 def show
  @order = current_user.orders.find(params[:id])
  if @order.blank?
     render json: { errors: 'Order is not found' }, status: :unprocessable_entity
  end
 end

 def update
  if current_user.role == 'user'
    @order = current_user.orders.find(params[:id])
  else
    @order = Order.find(params[:id])
  end
  old_attributes = @order.attributes
  if @order.update(order_params)
    OrderHistory.create_obj(@order.id, old_attributes, @order.attributes)
    render :show
  else
    render json: { errors: @order.errors }, status: :unprocessable_entity
  end
 end

 def destroy
  if current_user.role == 'user'
    @order = current_user.orders.where(id: params[:id], status: 'draft').first
  else
    @order = Order.where(id: params[:id], status: 'draft').first
  end
  if @order.present?
    if @order.destroy
      render json: { message: 'Order was successfully destroyed.' }
    else
      render json: { errors: @order.errors }, status: :unprocessable_entity
    end
  else
    render json: { errors: "Order is not found" }, status: :unprocessable_entity
  end
 end

 def invite
  @order = Order.find_by_id params[:id]
  user = User.find_by_id params[:designer_id]
  if @order.blank? || user.blank?
    render json: { errors: "Order/User is not found" }, status: :unprocessable_entity
  else
    invite = @order.invites.first
    if invite.blank?
      @order.invites.create(user_id: user.id)
    else
      invite.update(user_id: user.id)
    end
    render :show
  end
 end

 def update_invite
  invite = Invite.find_by_id params[:invite_id]
  if invite.blank?
    render json: { errors: "Invite is not found" }, status: :unprocessable_entity
  else
    invite.order_id = params[:order_id] if params[:order_id].present?
    invite.user_id = params[:user_id] if params[:user_id].present?
    if invite.save
      @order = invite.order
      render :show
    else
      render json: { errors: "invite is not save" }, status: :unprocessable_entity
    end
  end
 end

 def delete_invite
  invite = Invite.find_by_id params[:invite_id]
  if invite.blank?
    render json: { errors: "Invite is not found" }, status: :unprocessable_entity
  else
    if invite.destroy
      render json: { message: 'Invite was successfully destroyed.' }
    else
      render json: { errors: invite.errors }, status: :unprocessable_entity
    end
  end
 end

 def assing_orders
  @orders = Order.where(id: params[:ids])
  user = User.find_by_id params[:designer_id]
  @orders.each do |order|
    invite = order.invites.first
    if invite.blank?
      order.invites.create(user_id: user.id)
    else
      invite.update(user_id: user.id)
    end
  end
  render json: { message: 'All Order were assigned successfully.' }
 end

  private

  def order_params
    params.require(:order).permit(:status, 
      :design_approval,
      :unit, :tooth_material,
      :design_type,
      :turn_around_time,
      :model,
      :custom_tray,
      :rpd_framework,
      :abutment_optional,
      :message,
      :destination,
      :document,
      :stl_file,
      :tooth_no,
      :com_message,
      order_materials_attributes:[:id, :_destroy, :unit, :tooth_material, :design_type, :tooth_no])
  end
end