defmodule Nightingale.Accounts.Encryption do
  require Argon2

  def hash_password(pass), do: Argon2.hash_pwd_salt(pass)
  def validate_password(password, hash), do: Argon2.verify_pass(password, hash)
end
