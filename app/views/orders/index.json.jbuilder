json.orders @orders do |order|
	json.partial! 'orders/order', order: order
	json.order_materials order.order_materials do |order_material|
		json.(order_material, :id, :unit, :tooth_material, :design_type, :tooth_no)
	end
	json.user do
		json.partial! 'users/min_user', user: order.user
	end
	json.order_history order.order_histories do |order_history|
		json.partial! 'orders/order_history', order_history: order_history
	end
	json.order_invite order.invites do |invite|
		json.invite_id invite.id
		json.partial! 'users/min_user', user: invite.user
	end
end

json.pagination do
  json.total_page @orders.try(:total_pages) if @orders.present?
end