feature 'Purchase event in web app' do
  given(:pam_login_page) { PamLoginPage.new }
  given(:pam_event_page) { PamEventPage.new }

  given(:app_event_page) { AppEventPage.new }

  given(:pam_user) { {email: 'admin@dice.fm', password: 'admin'} }

  given(:pam_event_for_booking) { '5c7e88753b8f9500014b3ba1' }
  given(:web_event_for_booking) { 'z98n' }

  given(:web_event_for_waiting_list) { 'jedo' }

  given(:verify_phone_code) { '1234' }

  given(:login_data) { {
      country_code_number: '+357',
      phone_number: '96101149'
  } }

  given(:registration_data) { {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      day_of_birth: Faker::Number.between(from: 1, to: 28),
      month_of_birth: Faker::Number.between(from: 1, to: 12),
      year_of_birth: Faker::Number.between(from: 1950, to: 2010),
      email: Faker::Internet.email,
      country_code_number: '+7',
      phone_number: '927'+ Faker::Number.number(digits: 7).to_s
  } }

  given(:payment_data) { {
      cardholder_name: 'John Appleas',
      card_number: '4111 1111 1111 1111',
      expare_month: '01',
      expare_year: '2020',
      cvv: '111'
  } }

  scenario 'Book event as new customer' do
    pam_event_page.load(event_id: pam_event_for_booking)
    pam_login_page.login_as({email: pam_user[:email], password: pam_user[:password]})
    pam_event_page.wait_until_sold_tickets_count_in_header_visible

    sold_before_buying_in_header = pam_event_page.sold_tickets_count_in_header.text
    sold_before_buying_by_types = pam_event_page.tickets_count_by_types.text

    web_app = open_new_window

    within_window web_app do
      app_event_page.load(event_code: web_event_for_booking)
      app_event_page.wait_until_book_now_button_visible
      expect(app_event_page.book_now_button.text).to eq 'BOOK NOW'

      app_event_page.book_now_button.click
      app_event_page.wait_until_purchase_section_visible

      app_event_page.purchase_section.checkout_button.click
      app_event_page.purchase_section.wait_until_registration_tab_visible

      app_event_page.purchase_section.registration_tab.fill_registration_form(registration_data)

      app_event_page.purchase_section.registration_tab.continue_button.click
      app_event_page.purchase_section.wait_until_verify_phone_field_visible

      app_event_page.purchase_section.verify_phone_field.set verify_phone_code
      app_event_page.purchase_section.wait_until_payment_section_visible

      app_event_page.purchase_section.payment_section.fill_payment_section payment_data
      app_event_page.purchase_section.payment_section.purchase_ticket_button.click
      app_event_page.purchase_section.wait_until_confirmation_section_visible(wait: 20)

      expect(app_event_page.purchase_section.confirmation_section).to have_ticket_preview
      expect(app_event_page.purchase_section.confirmation_section).to have_download_button
    end

    page.refresh
    sold_after_buying_in_header = pam_event_page.sold_tickets_count_in_header.text
    sold_after_buying_by_types = pam_event_page.tickets_count_by_types.text

    expect(sold_after_buying_in_header).to be > sold_before_buying_in_header
    expect(sold_after_buying_by_types).to be > sold_before_buying_by_types

    expect(sold_after_buying_in_header.to_i).to eq sold_before_buying_in_header.to_i + 1
  end

  scenario 'Book event as existing customer' do
    pam_event_page.load(event_id: pam_event_for_booking)
    pam_login_page.login_as({email: pam_user[:email], password: pam_user[:password]})
    pam_event_page.wait_until_sold_tickets_count_in_header_visible

    sold_before_buying_in_header = pam_event_page.sold_tickets_count_in_header.text
    sold_before_buying_by_types = pam_event_page.tickets_count_by_types.text

    web_app = open_new_window
    within_window web_app do
      app_event_page.load(event_code: web_event_for_booking)
      app_event_page.wait_until_book_now_button_visible
      expect(app_event_page.book_now_button.text).to eq 'BOOK NOW'

      app_event_page.book_now_button.click
      app_event_page.wait_until_purchase_section_visible

      app_event_page.purchase_section.checkout_button.click
      app_event_page.purchase_section.wait_until_registration_tab_visible

      app_event_page.purchase_section.login_tab_button.click
      app_event_page.purchase_section.wait_until_login_tab_visible

      app_event_page.purchase_section.login_tab.phone_section.set_phone(login_data[:country_code_number], login_data[:phone_number])
      app_event_page.purchase_section.login_tab.verify_phone_button.click
      app_event_page.purchase_section.wait_until_verify_phone_field_visible

      app_event_page.purchase_section.verify_phone_field.set verify_phone_code
      app_event_page.purchase_section.wait_until_payment_section_visible

      app_event_page.purchase_section.payment_section.fill_payment_section payment_data
      app_event_page.purchase_section.payment_section.purchase_ticket_button.click
      app_event_page.purchase_section.wait_until_confirmation_section_visible(wait: 20)

      expect(app_event_page.purchase_section.confirmation_section).to have_ticket_preview
      expect(app_event_page.purchase_section.confirmation_section).to have_download_button
    end

    page.refresh
    sold_after_buying_in_header = pam_event_page.sold_tickets_count_in_header.text
    sold_after_buying_by_types = pam_event_page.tickets_count_by_types.text

    expect(sold_after_buying_in_header).to be > sold_before_buying_in_header
    expect(sold_after_buying_by_types).to be > sold_before_buying_by_types

    expect(sold_after_buying_in_header.to_i).to eq sold_before_buying_in_header.to_i + 1
  end

  scenario 'Check adding event to waiting list as a new customer' do
    app_event_page.load(event_code: web_event_for_waiting_list)
    app_event_page.wait_until_book_now_button_visible
    expect(app_event_page.book_now_button.text).to eq 'JOIN THE WAITING LIST'

    app_event_page.book_now_button.click
    app_event_page.wait_until_purchase_section_visible

    app_event_page.purchase_section.checkout_button.click
    app_event_page.purchase_section.wait_until_registration_tab_visible

    app_event_page.purchase_section.registration_tab.fill_registration_form(registration_data)

    app_event_page.purchase_section.registration_tab.continue_button.click
    app_event_page.purchase_section.wait_until_verify_phone_field_visible

    app_event_page.purchase_section.verify_phone_field.set verify_phone_code
    app_event_page.purchase_section.wait_until_waiting_list_confirmation_section_visible

    expect(app_event_page.purchase_section.waiting_list_confirmation_section).to have_confirmation_icon
    expect(app_event_page.purchase_section.waiting_list_confirmation_section).to have_confirmation_text
    expect(app_event_page.purchase_section.waiting_list_confirmation_section).to have_confirmation_description
    expect(app_event_page.purchase_section.waiting_list_confirmation_section).to have_download_button

    expect(app_event_page.purchase_section.waiting_list_confirmation_section.confirmation_text.text).to eq 'YOU’RE ON THE WAITING LIST'
  end

  scenario 'Check adding event to waiting list as a existing customer' do
    app_event_page.load(event_code: web_event_for_waiting_list)
    app_event_page.wait_until_book_now_button_visible
    expect(app_event_page.book_now_button.text).to eq 'JOIN THE WAITING LIST'

    app_event_page.book_now_button.click
    app_event_page.wait_until_purchase_section_visible

    app_event_page.purchase_section.checkout_button.click
    app_event_page.purchase_section.wait_until_registration_tab_visible

    app_event_page.purchase_section.login_tab_button.click
    app_event_page.purchase_section.wait_until_login_tab_visible

    app_event_page.purchase_section.login_tab.phone_section.set_phone(login_data[:country_code_number], login_data[:phone_number])
    app_event_page.purchase_section.login_tab.verify_phone_button.click
    app_event_page.purchase_section.wait_until_verify_phone_field_visible

    app_event_page.purchase_section.verify_phone_field.set verify_phone_code
    app_event_page.purchase_section.wait_until_waiting_list_confirmation_section_visible

    expect(app_event_page.purchase_section.waiting_list_confirmation_section).to have_confirmation_icon
    expect(app_event_page.purchase_section.waiting_list_confirmation_section).to have_confirmation_text
    expect(app_event_page.purchase_section.waiting_list_confirmation_section).to have_confirmation_description
    expect(app_event_page.purchase_section.waiting_list_confirmation_section).to have_download_button

    expect(app_event_page.purchase_section.waiting_list_confirmation_section.confirmation_text.text).to eq 'YOU’RE ON THE WAITING LIST'
  end
end