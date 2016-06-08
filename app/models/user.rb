class User < ApplicationRecord
  before_create :set_default_role
  # belongs_to :role

  private
  def set_default_role
    # self.role << Role.where(:name => 'registered').first
    # self.update(role_id: Role.find_by_name('registered').id)
    # self.role_id = Role.find_by_name('registered').id
    self.role_id = Role.find_by_name('registered').id
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
