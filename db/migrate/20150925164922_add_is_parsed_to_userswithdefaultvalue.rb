class AddIsParsedToUserswithdefaultvalue < ActiveRecord::Migration
  def change
    add_column :users, :is_parsed, :boolean, :default => false
  end
end
