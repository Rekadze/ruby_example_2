require File.dirname(__FILE__) + '/payment_section'
require File.dirname(__FILE__) + '/phone_section'

class PurchaseSection < BaseSection

  element :remove_one_ticket_button, '.inDnzf'
  element :ticket_quantity, '.TicketSelection__TicketNumber-jsGAXV'
  element :add_one_ticket_button, '.jmSNng'

  element :checkout_button, '.Button-hYXUXp.hFaBCM'

  element :register_tab_button, '.bNlljJ'
  element :login_tab_button, '.eESeVW'

  section :registration_tab, '#registration' do
    element :first_name_filed, '#firstName-anchor input'
    element :last_name_filed, '#lastName-anchor input'

    element :day_of_birth_field, '#dob-anchor .DateField__DayInput-dJWppf'
    element :month_of_birth_field, '#dob-anchor .DateField__MonthInput-dPcwhN'
    element :year_of_birth_field, '#dob-anchor .DateField__YearInput-hqDHqD'

    element :email_filed, '#email-anchor input'

    section :phone_section, PhoneSection, '#tel-anchor'

    element :email_from_dice_yes_button, 'label[for="offers.dice-true"]'
    element :email_from_dice_no_button, 'label[for="offers.dice-false"]'

    element :email_from_event_organisers_yes_button, 'label[for="offers.thirdParty-true"]'
    element :email_from_event_organisers_no_button, 'label[for="offers.thirdParty-false"]'

    element :continue_button, '.Button-hYXUXp.hFaBCM'

    def fill_registration_form(attrs)
      first_name_filed.set attrs[:first_name]
      last_name_filed.set attrs[:last_name]

      day_of_birth_field.set attrs[:day_of_birth]
      month_of_birth_field.set attrs[:month_of_birth]
      year_of_birth_field.set attrs[:year_of_birth]

      email_filed.set attrs[:email]

      phone_section.set_phone(attrs[:country_code_number], attrs[:phone_number])

      email_from_dice_no_button.click
      email_from_event_organisers_no_button.click
    end
  end

  section :login_tab, '#login' do
    section :phone_section, PhoneSection, '#tel-anchor'

    element :verify_phone_button, '.LoginForm__Submit-klmacj'
  end

  element :verify_phone_field, '.SMSCodeInput__Inputs-jZXnlp input'

  section :payment_section, PaymentSection, '#payment'

  section :confirmation_section, '.Confirmation__Wrapper-cQmOih' do
    element :ticket_preview, '.TicketPreview__Frame-gGgjhN'
    element :download_button, '.Button__ButtonLink-fUNqco'
  end
end