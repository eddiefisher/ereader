class User < ActiveRecord::Base
  include RedisInit
  include RedisReadable
  include RedisFlagable
  include RedisStarable

  belongs_to :role
  has_many :imports
  has_many :user_channels
  has_many :channels, through: :user_channels

  before_create :set_default_role

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable

  private

  def set_default_role
    self.role ||= Role.find_by_name('registered')
  end
end
