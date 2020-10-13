class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    page = params[:page]||1
    if params[:status].present?
      @orders = current_user.role == 'user' ? current_user.orders.where(status: params[:status]).page(page).per(15) : Order.where(status: params[:status]).page(page).per(15)
    else
      @orders = current_user.role == 'user' ? current_user.orders.page(page).per(15) : Order.all.page(page).per(15)
    end
  end

 def create
  @order = current_user.orders.new(order_params)
  if @order.save
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
  if @order.update(order_params)
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
      order_materials_attributes:[:id, :_destroy, :unit, :tooth_material, :design_type, :tooth_no])
  end
end