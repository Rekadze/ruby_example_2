shared_context 'Registration data' do
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

  given(:verify_phone_code) { '1234' }

  given(:login_data) { {
      country_code_number: '+357',
      phone_number: '96101149'
  } }
end

shared_context 'Registration data with payment' do
  include_context 'Registration data'

  given(:payment_data) { {
      cardholder_name: 'John Appleas',
      card_number: '4111 1111 1111 1111',
      expare_month: '01',
      expare_year: '2020',
      cvv: '111'
  } }
end