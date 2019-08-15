require File.dirname(__FILE__) + '/sections/purchase_section'

class AppEventPage < AppBasePage
  set_url AppBasePage.url + '/event/{event_code}'

  element :search_field, '#search'

  element :event_date, '.Header__When-ehAspF'
  element :event_title, '.Header__Title-eurZFS'
  element :event_price, '.Header__Cost-ibRECG'

  element :book_now_button, '.PurchaseCTAButton__CTAButton-iuZDvd'

  section :purchase_section, PurchaseSection, '.PurchaseFragment'
end