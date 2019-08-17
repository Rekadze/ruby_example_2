feature 'Purchase event in web app' do
  given(:pam_login_page) { PamLoginPage.new }
  given(:pam_event_page) { PamEventPage.new }

  given(:kim_login_page) { KimLoginPage.new }
  given(:kim_event_dashboard_page) { KimEventDashboardPage.new }

  given(:app_event_page) { AppEventPage.new }

  given(:pam_user) { {email: 'admin@dice.fm', password: 'admin'} }

  given(:kim_event_for_booking) { 'RXZlbnQ6MTE4' }
  given(:pam_event_for_booking) { '5c7e88753b8f9500014b3ba1' }
  given(:web_event_for_booking) { 'z98n' }

  given(:kim_event_for_waiting) { 'RXZlbnQ6MTIx' }
  given(:pam_event_for_waiting) { '5c826aba0a033900016472a7' }
  given(:web_event_for_waiting) { 'jedo' }

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

    kim_app = open_new_window

    within_window kim_app do
      kim_event_dashboard_page.load(event_id: kim_event_for_booking)
      kim_login_page.login_as({email: pam_user[:email], password: pam_user[:password]})

      kim_event_dashboard_page.wait_until_graph_section_visible

      @sold_before_from_graph = kim_event_dashboard_page.graph_section.sold_ticket_count.text
      @sold_before_from_allocation = kim_event_dashboard_page.ticket_allocation_section.sold_ticket_count.text
      @sold_before_from_breakdown = kim_event_dashboard_page.app_sales_breakdown_section.sold_ticket_count.text
    end

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

    within_window kim_app do
      page.refresh

      sold_after_from_graph = kim_event_dashboard_page.graph_section.sold_ticket_count.text
      sold_after_from_allocation = kim_event_dashboard_page.ticket_allocation_section.sold_ticket_count.text
      sold_after_from_breakdown = kim_event_dashboard_page.app_sales_breakdown_section.sold_ticket_count.text

      expect(sold_after_from_graph.to_i).to eq @sold_before_from_graph.to_i + 1
      expect(sold_after_from_allocation.to_i).to eq @sold_before_from_allocation.to_i + 1
      expect(sold_after_from_breakdown.to_i).to eq @sold_before_from_breakdown.to_i + 1
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

    kim_app = open_new_window

    within_window kim_app do
      kim_event_dashboard_page.load(event_id: kim_event_for_booking)
      kim_login_page.login_as({email: pam_user[:email], password: pam_user[:password]})

      kim_event_dashboard_page.wait_until_graph_section_visible

      @sold_before_from_graph = kim_event_dashboard_page.graph_section.sold_ticket_count.text
      @sold_before_from_allocation = kim_event_dashboard_page.ticket_allocation_section.sold_ticket_count.text
      @sold_before_from_breakdown = kim_event_dashboard_page.app_sales_breakdown_section.sold_ticket_count.text
    end

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

    within_window kim_app do
      page.refresh

      sold_after_from_graph = kim_event_dashboard_page.graph_section.sold_ticket_count.text
      sold_after_from_allocation = kim_event_dashboard_page.ticket_allocation_section.sold_ticket_count.text
      sold_after_from_breakdown = kim_event_dashboard_page.app_sales_breakdown_section.sold_ticket_count.text

      expect(sold_after_from_graph.to_i).to eq @sold_before_from_graph.to_i + 1
      expect(sold_after_from_allocation.to_i).to eq @sold_before_from_allocation.to_i + 1
      expect(sold_after_from_breakdown.to_i).to eq @sold_before_from_breakdown.to_i + 1
    end

    page.refresh
    sold_after_buying_in_header = pam_event_page.sold_tickets_count_in_header.text
    sold_after_buying_by_types = pam_event_page.tickets_count_by_types.text

    expect(sold_after_buying_in_header).to be > sold_before_buying_in_header
    expect(sold_after_buying_by_types).to be > sold_before_buying_by_types

    expect(sold_after_buying_in_header.to_i).to eq sold_before_buying_in_header.to_i + 1
  end

  scenario 'Check adding event to waiting list as a new customer' do
    pam_event_page.load(event_id: pam_event_for_waiting)
    pam_login_page.login_as({email: pam_user[:email], password: pam_user[:password]})
    pam_event_page.wait_until_sold_tickets_count_in_header_visible

    wait_tickets_before_buying = pam_event_page.waiting_tickets_count.text
    wait_fans_before_buying = pam_event_page.waiting_fans_count.text

    kim_app = open_new_window

    within_window kim_app do
      kim_event_dashboard_page.load(event_id: kim_event_for_waiting)
      kim_login_page.login_as({email: pam_user[:email], password: pam_user[:password]})

      kim_event_dashboard_page.wait_until_graph_section_visible

      @wait_tickets_before_graph = kim_event_dashboard_page.graph_section.waiting_tickets_count.text
      @wait_fans_before_graph = kim_event_dashboard_page.graph_section.waiting_individuals_count.text
      @wait_tickets_before_allocation = kim_event_dashboard_page.ticket_allocation_section.waiting_tickets_count.text
    end

    web_app = open_new_window

    within_new_window web_app do
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

    within_window kim_app do
      page.refresh

      wait_tickets_after_graph = kim_event_dashboard_page.graph_section.waiting_tickets_count.text
      wait_fans_after_graph = kim_event_dashboard_page.graph_section.waiting_individuals_count.text
      wait_tickets_after_allocation = kim_event_dashboard_page.ticket_allocation_section.waiting_tickets_count.text

      expect(wait_tickets_after_graph.to_i).to eq @wait_tickets_before_graph.to_i + 1
      expect(wait_fans_after_graph.to_i).to eq @wait_fans_before_graph.to_i + 1
      expect(wait_tickets_after_allocation.to_i).to eq @wait_tickets_before_allocation.to_i + 1
    end

    page.refresh
    wait_tickets_after_buying = pam_event_page.waiting_tickets_count.text
    wait_fans_after_buying = pam_event_page.waiting_fans_count.text

    expect(wait_tickets_after_buying.to_i).to eq wait_tickets_before_buying.to_i + 1
    expect(wait_fans_after_buying.to_i).to eq wait_fans_before_buying.to_i + 1
  end

  scenario 'Check adding event to waiting list as a existing customer' do
    pam_event_page.load(event_id: pam_event_for_waiting)
    pam_login_page.login_as({email: pam_user[:email], password: pam_user[:password]})
    pam_event_page.wait_until_sold_tickets_count_in_header_visible

    wait_tickets_before_buying = pam_event_page.waiting_tickets_count.text
    wait_fans_before_buying = pam_event_page.waiting_fans_count.text

    kim_app = open_new_window

    within_window kim_app do
      kim_event_dashboard_page.load(event_id: kim_event_for_waiting)
      kim_login_page.login_as({email: pam_user[:email], password: pam_user[:password]})

      kim_event_dashboard_page.wait_until_graph_section_visible

      @wait_tickets_before_graph = kim_event_dashboard_page.graph_section.waiting_tickets_count.text
      @wait_fans_before_graph = kim_event_dashboard_page.graph_section.waiting_individuals_count.text
      @wait_tickets_before_allocation = kim_event_dashboard_page.ticket_allocation_section.waiting_tickets_count.text
    end

    web_app = open_new_window

    within_new_window web_app do
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

    within_window kim_app do
      page.refresh

      wait_tickets_after_graph = kim_event_dashboard_page.graph_section.waiting_tickets_count.text
      wait_fans_after_graph = kim_event_dashboard_page.graph_section.waiting_individuals_count.text
      wait_tickets_after_allocation = kim_event_dashboard_page.ticket_allocation_section.waiting_tickets_count.text

      expect(wait_tickets_after_graph.to_i).to eq @wait_tickets_before_graph.to_i + 1
      expect(wait_fans_after_graph.to_i).to eq @wait_fans_before_graph.to_i + 1
      expect(wait_tickets_after_allocation.to_i).to eq @wait_tickets_before_allocation.to_i + 1
    end

    page.refresh
    wait_tickets_after_buying = pam_event_page.waiting_tickets_count.text
    wait_fans_after_buying = pam_event_page.waiting_fans_count.text

    expect(wait_tickets_after_buying.to_i).to eq wait_tickets_before_buying.to_i + 1
    expect(wait_fans_after_buying.to_i).to eq wait_fans_before_buying.to_i + 1
  end
end