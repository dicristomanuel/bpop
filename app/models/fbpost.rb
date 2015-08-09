class Fbpost < ActiveRecord::Base
	belongs_to :identity
	has_many :fblikes, dependent: :destroy
end
