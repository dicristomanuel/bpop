class AddGenderToFbLikes < ActiveRecord::Migration
  def change
    add_column :fblikes, :gender, :string
  end
end
