class Order < ApplicationRecord
  belongs_to :user
  has_many :order_materials
  has_many :order_histories

  accepts_nested_attributes_for :order_materials, :allow_destroy => true

  def document_url
    document
  end

  def stl_file_url
    stl_file
  end

end
