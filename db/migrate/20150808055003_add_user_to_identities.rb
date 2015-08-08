class AddUserToIdentities < ActiveRecord::Migration
  def change
    add_reference :identities, :user, index: true, foreign_key: true
  end
end
