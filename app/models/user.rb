class User < ApplicationRecord
  has_many :users

  before_create :set_default_role

  private
  def set_default_role
    self.role_id ||= Role.find_by_name('registered')
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
