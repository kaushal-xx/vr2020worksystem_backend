class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, uniqueness: { case_sensitive: false }, presence: true, allow_blank: false

  validate :validated_code, if: Proc.new { |model| model.id.blank? && model.role == 'user'}

  # mount_uploaders :documents, DocumentUploader
  # serialize :documents, JSON # If you use SQLite, add this line.
  has_many_attached :documents
  has_many :orders

  acts_as_token_authenticatable

  attr_accessor :varification_code, :varification_id

  def generate_jwt
    JWT.encode({ id: id, exp: 60.days.from_now.to_i }, Rails.application.secrets.secret_key_base)
  end

  def attachments
    documents.attachments.map{|s| s.blob.service_url.sub(/\?.*/, '')}
  end

  def files_url
    documents.attachments.map{|s| s.blob.service_url.sub(/\?.*/, '')}.join("</br>").html_safe
  end

  def created_by
    User.find_by_id self.created_by_id if self.created_by_id.present?
  end

  def validated_code
    if varification_id.blank? 
      errors.add(:varification_id, "Can't be blank")
    elsif varification_code.blank?
      errors.add(:varification_code, "Can't be blank")
    else
      varification = UserVerification.where(id: varification_id, email: email, verified: false).first
      if varification.blank? || varification.token != varification_code
        errors.add(:varification_code, "is not valid") 
      end
    end
  end
end
