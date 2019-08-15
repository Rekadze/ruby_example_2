feature 'Login' do
  given(:kim_login_page) { KimLoginPage.new }
  given(:kim_dashboard_page) { KimDashboardPage.new }

  given(:pam_login_page) { PamLoginPage.new }
  given(:pam_event_list_page) { PamEventListPage.new }

  given(:user) { {email: 'admin@dice.fm', password: 'admin'} }

  scenario 'Check login into kim' do
    kim_login_page.load

    kim_login_page.email_field.set user[:email]
    kim_login_page.password_field.set user[:password]
    kim_login_page.login_button.click

    expect(kim_dashboard_page).to be_displayed
    expect(kim_dashboard_page).to have_dashboard_items(count: 8)
  end

  scenario 'Check login into pam' do
    pam_login_page.load

    pam_login_page.email_field.set user[:email]
    pam_login_page.password_field.set user[:password]
    pam_login_page.login_button.click

    expect(pam_login_page).not_to have_login_button
    expect(pam_event_list_page.header_menu).to have_menu_button
  end
end