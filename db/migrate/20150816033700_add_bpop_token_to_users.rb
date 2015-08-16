class AddBpopTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bpopToken, :string
  end
end
