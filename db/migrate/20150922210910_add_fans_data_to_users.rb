class AddFansDataToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fans_data, :string
  end
end
