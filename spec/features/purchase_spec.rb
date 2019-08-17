feature 'Purchase event in web app' do
  include_context 'Registration data with payment'

  given(:pam_login_page) { PamLoginPage.new }
  given(:pam_event_page) { PamEventPage.new }

  given(:kim_login_page) { KimLoginPage.new }
  given(:kim_event_dashboard_page) { KimEventDashboardPage.new }

  given(:app_event_page) { AppEventPage.new }

  given(:admin_user) { {email: 'admin@dice.fm', password: 'admin'} }

  given(:kim_event_for_booking) { 'RXZlbnQ6MTE4' }
  given(:pam_event_for_booking) { '5c7e88753b8f9500014b3ba1' }
  given(:web_event_for_booking) { 'z98n' }

  scenario 'Book event as new customer' do
    pam_event_page.load(event_id: pam_event_for_booking)
    pam_login_page.login_as(admin_user)
    pam_event_page.wait_until_sold_tickets_count_in_header_visible

    sold_before_buying_in_header = pam_event_page.sold_tickets_count_in_header.text
    sold_before_buying_by_types = pam_event_page.tickets_count_by_types.text

    kim_app = open_new_window

    within_window kim_app do
      kim_event_dashboard_page.load(event_id: kim_event_for_booking)
      kim_login_page.login_as(admin_user)

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
    pam_login_page.login_as(admin_user)
    pam_event_page.wait_until_sold_tickets_count_in_header_visible

    sold_before_buying_in_header = pam_event_page.sold_tickets_count_in_header.text
    sold_before_buying_by_types = pam_event_page.tickets_count_by_types.text

    kim_app = open_new_window

    within_window kim_app do
      kim_event_dashboard_page.load(event_id: kim_event_for_booking)
      kim_login_page.login_as(admin_user)

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
end