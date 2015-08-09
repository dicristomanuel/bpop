class RemoveToken1AndToken2FromIdentities < ActiveRecord::Migration
  def change
  	remove_column(:identities, :token_1)
  	remove_column(:identities, :token_2)
  end
end
