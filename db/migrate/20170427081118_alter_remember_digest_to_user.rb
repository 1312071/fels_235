class AlterRememberDigestToUser < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :remmber_digest, :remember_digest
  end
end
