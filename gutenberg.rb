require_relative 'scrapppy'

session = Capybara::Session.new(:headless)
# session.driver.browser

list_files

session.visit "http://www.gutenberg.org/ebooks/6168"
link_node = session.all('table.files a.link').detect{|n|n.text == "EPUB (with images)"}
puts "Clicking link"
link_node.click
puts "Waiting a few seconds"
sleep 3
list_files
