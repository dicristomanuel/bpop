class AddBpopTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bpoptoken, :string
  end
end
