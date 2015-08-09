class AddFieldsToIdentities < ActiveRecord::Migration
  def change
    add_column :identities, :name, :string
    add_column :identities, :image_url, :string
    add_column :identities, :profile_url, :string
    add_column :identities, :followers_count, :string
    add_column :identities, :friends_count, :string
    add_column :identities, :statuses_count, :string
    add_column :identities, :access_token, :string
    add_column :identities, :secret_token, :string
  end
end
