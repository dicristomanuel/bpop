class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.string :provider

      t.timestamps null: false
    end
  end
end
