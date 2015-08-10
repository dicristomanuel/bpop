class AddTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :bpop_token, :string
  end
end
