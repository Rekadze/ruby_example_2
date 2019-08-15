class PaymentSection < BaseSection

  element :name_on_card_field, '#cardName-anchor input'
  element :card_number_field, '#cardNumber-anchor input'
  element :expare_date_month_field, '#expiry-anchor .DateField__MonthInput-dPcwhN'
  element :expare_date_year_field, '#expiry-anchor .DateField__YearInput-hqDHqD'
  element :cvv_field, '#cvv-anchor input'

  element :purchase_ticket_button, '.PaymentForm__FormFooter-eXbCTa .Button-hYXUXp'

  def fill_payment_section(attrs)
    name_on_card_field.set attrs[:cardholder_name]
    card_number_field.set attrs[:card_number]
    expare_date_month_field.set attrs[:expare_month]
    expare_date_year_field.set attrs[:expare_year]
    cvv_field.set attrs[:cvv]
  end
end