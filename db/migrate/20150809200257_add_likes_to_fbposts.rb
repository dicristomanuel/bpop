class AddLikesToFbposts < ActiveRecord::Migration
  def change
    add_column :fbposts, :likes, :integer
  end
end
