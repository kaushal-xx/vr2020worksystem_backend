class Invite < ApplicationRecord
	belongs_to :order
	belongs_to :user
end
