class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :address, :email, :name, :other, :phone_number, :username, :password, :password_confirmation
  

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :username, :presence => true,
                       :uniqueness => { :case_sensitive => false }
                    
  validates :name, :presence => true

  validates :email,  :format   => { :with => email_regex },  :allow_blank => true
  
  # Cree automatique l'attribut virtuel 'password_confirmation'.
  validates :password, :presence => true,
                       :confirmation => true,
                       :length => { :within => 6..40 }

                       
  before_save :encrypt_password
  
  # Retour true (vrai) si le mot de passe correspond.
  def has_password?(password_soumis)
    # Compare encrypted_password avec la version cryptée de
    # password_soumis.
    encrypted_password == encrypt(password_soumis)
  end
 
  # retourne l'utilisateur en base si
  # username et submitted_password correspond à un couple
  # sauvegardé en base
  # retourne nil sinon
  def self.authenticate(username, submitted_password)
    user = find_by_username(username)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end 

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  
  private
  
    def encrypt_password
      self.salt = make_salt if new_record?
      self.valid?
      if !self.errors[:password].any?
           self.encrypted_password = encrypt(password)
      end
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end 
end
# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  username           :string(255)
#  name               :string(255)     not null
#  address            :text
#  phone_number       :string(255)
#  email              :string(255)
#  other              :text
#  admin              :boolean         default(FALSE)
#  encrypted_password :string(255)
#  salt               :string(255)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#

