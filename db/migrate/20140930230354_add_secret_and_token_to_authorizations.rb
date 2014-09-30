class AddSecretAndTokenToAuthorizations < ActiveRecord::Migration
  def change
    add_column :authorizations, :secret, :string
    add_column :authorizations, :token, :string
  end
end
