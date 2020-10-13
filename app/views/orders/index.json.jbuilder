json.orders @orders do |order|
	json.partial! 'orders/order', order: order
	json.order_materials order.order_materials do |order_material|
		json.(order_material, :id, :unit, :tooth_material, :design_type, :tooth_no)
	end
	json.user do
		json.partial! 'users/min_user', user: order.user
	end
end

json.pagination do
  json.total_page @orders.try(:total_pages) if @orders.present?
end