require 'selenium-webdriver'
require 'nokogiri'
require 'capybara'
require 'pathname'
require 'pry'


DOWNLOAD_PATH = Pathname.new('headless-downloads')
USER_DIR = Pathname.new('chrome-dir')
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
  '--new-window',
  '--no-sandbox',
  '--disable-dev-shm-usage',
  "--user-data-dir=#{USER_DIR}"
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

def configure
  FileUtils.rm_rf(DOWNLOAD_PATH)

  Capybara::Driver::Base.class_eval { def status_code; 'unknown'.freeze; end }
  Capybara.default_max_wait_time = 10

  Capybara.register_driver :headless do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: chrome_options).tap do |driver|
      driver.browser.download_path = DOWNLOAD_PATH
    end
  end

  Capybara.default_driver = :headless
  Capybara.javascript_driver = :headless
  Capybara.current_driver = :headless
  Selenium::WebDriver.logger.level = :warn
end

def list_files
  puts "Listing files in DOWNLOAD_PATH:"
  puts Dir[DOWNLOAD_PATH.join('*')].join("\n")
end

configure
