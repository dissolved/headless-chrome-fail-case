require 'selenium-webdriver'
require 'nokogiri'
require 'capybara'
require 'pathname'
require 'pry'


DOWNLOAD_PATH = Pathname.new('headless-downloads')
USER_DIR = Pathname.new('chrome-dir')

def configure
  FileUtils.rm_rf(DOWNLOAD_PATH)

  Capybara.register_driver :headless do |app|
    options = Selenium::WebDriver::Chrome::Options.new
  
    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-gpu')
    options.add_argument('--disable-popup-blocking')
    options.add_argument('--window-size=1366,768')
  
    options.add_preference(:download, directory_upgrade: true,
                                      prompt_for_download: false,
                                      default_directory: DOWNLOAD_PATH)
  
    options.add_preference(:browser, set_download_behavior: { behavior: 'allow' })
  
    driver = Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  
    bridge = driver.browser.send(:bridge)
  
    path = '/session/:session_id/chromium/send_command'
    path[':session_id'] = bridge.session_id
  
    bridge.http.call(:post, path, cmd: 'Page.setDownloadBehavior',
                                  params: {
                                    behavior: 'allow',
                                    downloadPath: DOWNLOAD_PATH
                                  })
  
    driver
  end
end

def list_files
  puts "Listing files in DOWNLOAD_PATH:"
  puts Dir[DOWNLOAD_PATH.join('*')].join("\n")
end

configure
