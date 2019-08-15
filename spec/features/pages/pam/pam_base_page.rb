class PamBasePage < BasePage
  set_url 'https://pam-test1.ote01.tixey.com'

  section :header_menu, '#top-nav' do
    element :logo, 'img.logo'
    element :menu_button, '.burger'

    elements :menu_rows, '.burger-menu ul li'
  end
end