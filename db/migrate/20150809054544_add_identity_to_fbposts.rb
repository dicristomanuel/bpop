class AddIdentityToFbposts < ActiveRecord::Migration
  def change
    add_reference :fbposts, :identity, index: true, foreign_key: true
  end
end
