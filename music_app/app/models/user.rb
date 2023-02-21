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
#FIGVAPER

class User < ApplicationRecord
    validates :email, :session_token, uniqueness: true, presence: true
    validates :password_digest, presence: true

    #we allow nil for the password field so that when we perform actions later down the line, we won't run into errors bc we wldn't need to input a password
    validates :password, , allow_nil: true

    attr_reader :password
    
    before_validation :ensure_session_token

    def password=(password)
        #setting the password_digest in user to a BCrypt object
        self.password_digest = BCrpyt::Password.create(password)
        #defining a password instance so that we can save the input password
        @password = password
    end

    #checks if the users' input password is the same as the one they have in their instances
    def is_password?(password)
        bcrypt_obj = BCrpyt::Password.new(self.password_digest)

        #the #is_password?() method belongs to the BCrypt class and it turns the input into a password_digest/bcrypt object and compares it with whatever comes before it.
        bcrypt_obj.is_password?(password)
    end

    def generate_unique_session_token
        token = SecureRandom::urlsafe_base64

        #makes sure that the token generate is not the same as any existing token in the session_token column of :users table
        while User.exists?(session_token: token)
            token = SecureRandom::urlsafe_base64
        end

        token
    end

    #resets the session token to a newly generated one
    def reset_session_token!
        self.session_token = generate_unique_session_token
        self.save!
        self.session_token
    end

    #this method makes sure that a user has a valid session_token
    def ensure_session_token
        #if there isn't a session_token for the user, then generate one w the method we defined earlier
        self.session_token ||= generate_unique_session_token
    end


    self.find_by_credentials(email, password)
        #this sets our variable user to whatever instance is found with the find by method.
        #the find_by method takes in a key-value pair. the key is the column name. the method will look at all rows in that column to see if they match the value.
        user = User.find_by(email: email)

        #if a match is found and the input password matches the password in that record, return the user instance
        if user && user.is_password?(password)
            user
        else
            nil
        end
    end


end
