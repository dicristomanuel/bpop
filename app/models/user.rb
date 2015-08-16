class User < ActiveRecord::Base
	before_create :generate_bpopToken

	has_many :identities, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
     :omniauthable, :omniauth_providers => [:facebook, :twitter]

	private

	def generate_bpopToken
		 self.bpopToken = SecureRandom.hex		
	end
end
