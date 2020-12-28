class OrderHistory < ApplicationRecord
    #=============== Store attr ====================================
    store_accessor :old_data
    store_accessor :new_data

    belongs_to :order

	def self.create_obj(order_id, old_attriubtes, new_attriubtes)
		last_version = self.where(order_id: order_id).order(:version).last
		change_keys = new_attriubtes.select{|key, value| ['created_at', 'updated_at', 'user_id', 'id'].include?(key) == false && old_attriubtes[key] != value}.keys
		if change_keys.present?
			old_data = old_attriubtes.select{|key,value| change_keys.include?(key)}
			new_data = new_attriubtes.select{|key,value| change_keys.include?(key)}
			obj = new(old_data: old_data, new_data: new_data, order_id: order_id)
			if last_version.present?
				obj.version = last_version.version+1
			else
				obj.version = 1
			end
			obj.save
		end
	end
end
