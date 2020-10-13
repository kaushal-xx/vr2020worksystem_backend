json.order do |json|
	json.partial! 'orders/order', order: @order
	json.user do
		json.partial! 'users/min_user', user: @order.user
	end
	json.order_materials @order.order_materials do |order_material|
		json.(order_material, :id, :unit, :tooth_material, :design_type, :tooth_no)
	end
end