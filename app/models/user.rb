class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, uniqueness: { case_sensitive: false }, presence: true, allow_blank: false

  # mount_uploaders :documents, DocumentUploader
  # serialize :documents, JSON # If you use SQLite, add this line.
  has_many_attached :documents

  acts_as_token_authenticatable

  def generate_jwt
    JWT.encode({ id: id, exp: 60.days.from_now.to_i }, Rails.application.secrets.secret_key_base)
  end

  def attachments
    documents.attachments.map{|s| s.blob.service_url.sub(/\?.*/, '')}
  end

  def files_url
    documents.attachments.map{|s| s.blob.service_url.sub(/\?.*/, '')}.join("</br>").html_safe
  end

end
