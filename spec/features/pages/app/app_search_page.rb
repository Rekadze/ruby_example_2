class AppSearchPage < AppBasePage
  set_url AppBasePage.url + '/search{?query*}'

  sections :event_cards, '.eventCard' do
    element :event_date, '.m5guey-6'
    element :event_title, '.eventName'

    element :book_button, '.m5guey-8'
    element :event_price, '.m5guey-10'
  end
end