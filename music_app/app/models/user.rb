# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  session_token   :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
    validates :email, :session_token, uniqueness: true
    validates :email, :session_token, :password_digest, presence: true
    validates :password, length: {minimum: 8 }, allow_nil: true
    validate :unique_char_inclusion?
    

    attr_reader :password
    before_validation :ensure_session_token

    def self.find_by_credentials(email, password)
        user = User.find_by(email, password)
        if user && user.is_valid_password?(password)
            user
        else
            nil
        end
    end

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_valid_password?(passsword)
        password_obj = BCrypt::Password.new(password_digest)
        password_obj.is_password?(password)
    end

    def reset_session_token!
        self.session_token = SecureRandom::urlsafe_base64
        self.save!
        self.session_token
    end

    def ensure_session_token
        self.session_token ||= SecureRandom::urlsafe_base64
    end

    def unique_char_inclusion?
        count = 0
        u_chars = ['!', '@', '#', '$', '%', '&', '*']
        u_chars.each do |u_char|
            count += 1 if password.include?(u_char)
        end
        if count > 1
            return true
        else
            self.errors_add(:password, message: "no unique character in the password")
            return false
        end
    end

end
