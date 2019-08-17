class PamLoginPage < PamBasePage
  set_url PamBasePage.url + '/'

  element :email_field, "#email"
  element :password_field, "#password"

  element :login_button, ".submit"
end