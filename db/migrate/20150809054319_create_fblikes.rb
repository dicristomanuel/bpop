class CreateFblikes < ActiveRecord::Migration
  def change
    create_table :fblikes do |t|
      t.string :user_name
      t.string :user_facebook_id

      t.timestamps null: false
    end
  end
end
