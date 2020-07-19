# frozen_string_literal: true

# User class
class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  VALID_PASSWORD_REGEX = /\A(?=.*[a-zA-Z])(?=.*[0-9]).{8,}\z/i.freeze

  before_save :downcase_email
  before_save :generate_expires_at

  has_secure_password

  has_secure_token :auth_token

  validates :name, presence: true, length: { maximum: 50 }

  validates :email, presence: true, length: { maximum: 50 }, format: { with: VALID_EMAIL_REGEX }

  validates :password, presence: true, length: { minimum: 8 }, format: { with: VALID_PASSWORD_REGEX },
                       confirmation: true, if: :password_digest_changed?

  def token_expired?
    expires_at < Time.zone.now
  end

  private

  def generate_expires_at
    self.expires_at = 1.day.from_now
  end

  def downcase_email
    email.downcase!
  end
end
