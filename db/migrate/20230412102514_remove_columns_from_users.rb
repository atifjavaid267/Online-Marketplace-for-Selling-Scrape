class RemoveColumnsFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :second_factor_attempts_count, :integer
    remove_column :users, :encrypted_otp_secret_key, :string
    remove_column :users, :encrypted_otp_secret_key_iv, :string
    remove_column :users, :encrypted_otp_secret_key_salt, :string
    remove_column :users, :direct_otp, :string
    remove_column :users, :direct_otp_sent_at, :datetime
    remove_column :users, :totp_timestamp, :datetime
    remove_column :users, :otp, :string
  end
end
