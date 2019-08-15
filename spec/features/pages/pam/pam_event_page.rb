class PamEventPage < PamBasePage
  set_url PamBasePage.url + '/events/{event_id}'

  element :sold_tickets_count_in_header, '.sales-eventdetails li:nth-of-type(2) span:nth-of-type(1)'
  element :tickets_count_by_types, '.ticketlist-list-item .ticketlist-text--bold'
end