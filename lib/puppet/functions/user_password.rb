# frozen_string_literal: true

Puppet::Functions.create_function(:user_password) do
  dispatch :user_password do
    param 'Variant[Sensitive[String], String]', :password
    return_type 'Variant[Sensitive[String], String]'
  end

  def user_password(password)
    password
  end
end
