class PhoneSection < BaseSection

  element :country_code_select, '.PhoneField__SelectedCode-lmbzVH'

  section :country_dropdown, '.PhoneOverlay__Overlay-cUAcYR' do
    sections :country_row, '.PhoneOverlay__CodeOption-cGhSVs' do
      element :phone_code, '.PhoneOverlay__Code-gzmhiw'
    end
  end

  element :phone_filed, '.PhoneField__PhoneNumber-hvNyZO'

  def find_column_by_name(column_name)
    parent_page.find_section(columns_rows, 'title', column_name)
  end

  def set_phone(country_code, phone_number)
    country_code_select.click
    wait_until_country_dropdown_visible

    country_code_row = parent_page.find_section(country_dropdown.country_row, 'phone_code', country_code)
    country_code_row.phone_code.click

    phone_filed.set phone_number
  end
end