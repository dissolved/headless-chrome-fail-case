require 'selenium-webdriver'
require 'nokogiri'
require 'capybara'
require 'pathname'
require 'pry'

DOWNLOAD_PATH = Pathname.new('headless-downloads')
SWITCHES = [
  '--window-size=1280,1024',
  '--disable-bundled-ppapi-flash',
  '--disable-extensions',
  '--disable-java',
  '--disable-plugins',
  '--disable-plugins-discovery',
  '--ignore-certificate-errors',
  '--headless',
  '--disable-gpu',
  '--incognito',
  '--new-window'
]
def chrome_options
  Selenium::WebDriver::Chrome::Options.new.tap do |options|
    options.add_preference('pdfjs.disabled', true)
    options.add_preference('plugins.always_open_pdf_externally', true)
    options.add_preference(
      'plugins.plugins_disabled',
      [
        'Chrome PDF Viewer',
        'Adobe Flash Player',
        'Widevine Content Decryption Module',
        'Native Client'
      ]
    )

    options.add_preference(
      :download,
      directory_upgrade: true,
      prompt_for_download: false,
      default_directory: DOWNLOAD_PATH
    )
    options.add_preference(:browser, set_download_behavior: { behavior: 'allow' })

    SWITCHES.each do |switch|
      options.add_argument(switch)
    end
  end
end

def list_files
  puts "Listing files in DOWNLOAD_PATH:"
  puts Dir[DOWNLOAD_PATH.join('*')].join("\n")
end

# Configurations
Capybara.register_driver :headless do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: chrome_options).tap do |driver|
    driver.browser.download_path = DOWNLOAD_PATH
  end
end
Capybara.javascript_driver = :chrome
Capybara.configure do |config|
  config.default_max_wait_time = 10 # seconds
  config.default_driver = :headless
end

FileUtils.rm_rf(DOWNLOAD_PATH)
session = Capybara.current_session
session.driver.browser

list_files

session.visit "http://www.gutenberg.org/ebooks/6168"
link_node = session.all('table.files a.link').detect{|n|n.text == "EPUB (with images)"}
puts "Clicking link"
link_node.click
puts "Waiting a few seconds"
sleep 3
list_files
