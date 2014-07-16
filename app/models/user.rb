class User
  include Mongoid::Document

  devise :database_authenticatable, :registerable, :rememberable, :validatable

  validates_uniqueness_of :username
  validates_presence_of :encrypted_password
  
  ## Database authenticatable
  field :username,           :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  ## Rememberable
  field :remember_created_at, :type => Time

  field :first_name
  field :last_name
  field :admin, :type => Boolean, :default => false

  validates_presence_of :username, :first_name, :last_name
  attr_accessible :username, :first_name, :last_name, :password, :password_confirmation

  def name
    "#{first_name} #{last_name}"
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
