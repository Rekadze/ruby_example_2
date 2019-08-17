class PamEventPage < PamBasePage
  set_url PamBasePage.url + '/events/{event_id}'

  element :sold_tickets_count_in_header, '.sales-eventdetails li:nth-of-type(2) span:nth-of-type(1)'

  element :waiting_tickets_count, '.fatlist-item__group:nth-of-type(2) .fatlist-item__bigtext'
  element :waiting_fans_count, '.fatlist-item__group:nth-of-type(2) .fatlist-item__bigtext'

  element :tickets_count_by_types, '.ticketlist-list-item .ticketlist-text--bold'
end