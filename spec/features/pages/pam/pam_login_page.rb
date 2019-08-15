class PamLoginPage < PamBasePage
  set_url PamBasePage.url + '/'

  element :email_field, "#email"
  element :password_field, "#password"

  element :login_button, ".submit"

  def login_as(user)
    email_field.set user[:email]
    password_field.set user[:password]

    login_button.click
  end
end