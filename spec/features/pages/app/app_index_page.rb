class AppIndexPage < AppBasePage
  set_url AppBasePage.url + '/'

  element :search_field, '#search'
end