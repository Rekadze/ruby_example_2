feature 'Search' do
  given(:app_index_page) { AppIndexPage.new }
  given(:app_search_page) { AppSearchPage.new }
  given(:app_event_page) { AppEventPage.new }

  scenario 'Check search for event and open it' do
    app_index_page.load
    app_index_page.search_field.set 'Paper Event'

    expect(app_search_page).to have_event_cards

    first_event = app_search_page.event_cards[0]
    event_title = first_event.event_title.text
    event_price = first_event.event_price.text

    first_event.book_button.click

    expect(app_event_page.event_title.text).to eq(event_title)
    expect(app_event_page.event_price.text).to eq(event_price)
  end
end