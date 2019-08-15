class KimLoginPage < KimBasePage
  set_url KimBasePage.url + '/'

  element :email_field, "[name='username']"
  element :password_field, "[name='password']"

  element :login_button, "[name='Sign in']"
end