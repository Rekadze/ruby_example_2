class BasePage < SitePrism::Page
  def find_section(sections, field, field_value)
    sections.find do |section|
      section.send(field).text == field_value
    end
  end
end