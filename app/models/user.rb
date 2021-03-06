class User < ActiveRecord::Base
	before_create :generate_bpoptoken

	serialize :fans_data, JSON

	validates_uniqueness_of :email
	# validates_presence_of :password, :password_confirmation

	has_many :identities, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
     :omniauthable, :omniauth_providers => [:facebook, :twitter]

	private

	def generate_bpoptoken
		 self.bpoptoken = SecureRandom.hex
	end
end
