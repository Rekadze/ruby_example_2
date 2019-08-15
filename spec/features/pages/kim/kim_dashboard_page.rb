class KimDashboardPage < KimBasePage
  set_url KimBasePage.url + '/dashboard'

  element :email_field, "[name='username']"

  sections :dashboard_items, '.Dashboard__item__link' do
    element :title, ''
    element :count, '.Dashboard__item__value'
  end
end