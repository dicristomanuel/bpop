class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.string :provider
      t.string :token_1
      t.string :token_2

      t.timestamps null: false
    end
  end
end
