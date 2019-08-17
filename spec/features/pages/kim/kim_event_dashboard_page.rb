class KimEventDashboardPage < KimBasePage
  set_url KimBasePage.url + '/client/events/{event_id}/dashboard'

  section :graph_section, '.graph' do
    element :sold_ticket_count, '.EventDashboardContainer__EventStats-qa7apo-0 .Puff__Container-sc-1yqy342-0:nth-of-type(3) .cSqObL'
    element :waiting_tickets_count, '.EventAdvancedStatsContainer__EventStats-sc-1gn14nl-0 .Puff__Container-sc-1yqy342-0:nth-of-type(3) .Puff__Content-sc-1yqy342-2.cSqObL'
    element :waiting_individuals_count, '.EventAdvancedStatsContainer__EventStats-sc-1gn14nl-0 .Puff__Container-sc-1yqy342-0:nth-of-type(4) .Puff__Content-sc-1yqy342-2.cSqObL'
  end

  section :ticket_allocation_section, '.Section__Container-sc-269gbi-0:nth-of-type(1)' do
    element :sold_ticket_count, '.ticketTypeSold'
    element :waiting_tickets_count, '.ticketTypeWlTickets'
  end

  section :app_sales_breakdown_section, '.Section__Container-sc-269gbi-0:nth-of-type(2)' do
    element :sold_ticket_count, '.breakdownTicketTicketsSold'
  end
end