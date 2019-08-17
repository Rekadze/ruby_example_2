feature 'Add event to waiting list' do
  include_context 'Registration data'

  given(:pam_login_page) { PamLoginPage.new }
  given(:pam_event_page) { PamEventPage.new }

  given(:kim_login_page) { KimLoginPage.new }
  given(:kim_event_dashboard_page) { KimEventDashboardPage.new }

  given(:app_event_page) { AppEventPage.new }

  given(:admin_user) { {email: 'admin@dice.fm', password: 'admin'} }

  given(:kim_event_for_waiting) { 'RXZlbnQ6MTIx' }
  given(:pam_event_for_waiting) { '5c826aba0a033900016472a7' }
  given(:web_event_for_waiting) { 'jedo' }

  scenario 'Check adding event to waiting list as a new customer' do
    pam_event_page.load(event_id: pam_event_for_waiting)
    pam_login_page.login_as(admin_user)
    pam_event_page.wait_until_sold_tickets_count_in_header_visible

    wait_tickets_before_buying = pam_event_page.waiting_tickets_count.text
    wait_fans_before_buying = pam_event_page.waiting_fans_count.text

    kim_app = open_new_window

    within_window kim_app do
      kim_event_dashboard_page.load(event_id: kim_event_for_waiting)
      kim_login_page.login_as(admin_user)

      kim_event_dashboard_page.wait_until_graph_section_visible

      @wait_tickets_before_graph = kim_event_dashboard_page.graph_section.waiting_tickets_count.text
      @wait_fans_before_graph = kim_event_dashboard_page.graph_section.waiting_individuals_count.text
      @wait_tickets_before_allocation = kim_event_dashboard_page.ticket_allocation_section.waiting_tickets_count.text
    end

    web_app = open_new_window

    within_window web_app do
      app_event_page.load(event_code: web_event_for_waiting)
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
    pam_login_page.login_as(admin_user)
    pam_event_page.wait_until_sold_tickets_count_in_header_visible

    wait_tickets_before_buying = pam_event_page.waiting_tickets_count.text
    wait_fans_before_buying = pam_event_page.waiting_fans_count.text

    kim_app = open_new_window

    within_window kim_app do
      kim_event_dashboard_page.load(event_id: kim_event_for_waiting)
      kim_login_page.login_as(admin_user)

      kim_event_dashboard_page.wait_until_graph_section_visible

      @wait_tickets_before_graph = kim_event_dashboard_page.graph_section.waiting_tickets_count.text
      @wait_fans_before_graph = kim_event_dashboard_page.graph_section.waiting_individuals_count.text
      @wait_tickets_before_allocation = kim_event_dashboard_page.ticket_allocation_section.waiting_tickets_count.text
    end

    web_app = open_new_window

    within_new_window web_app do
      app_event_page.load(event_code: web_event_for_waiting)
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
