class BasePage < SitePrism::Page
  def find_section(sections, field, field_value)
    sections.find do |section|
      section.send(field).text == field_value
    end
  end

  def login_as(user)
    email_field.set user[:email]
    password_field.set user[:password]

    login_button.click
  end
end