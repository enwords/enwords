class User < ActiveRecord::Base
  has_and_belongs_to_many :words
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :set_default_lang, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end

  def set_default_lang
    self.language_1_id = 1 #eng
    self.language_2_id = 2 #rus
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


end