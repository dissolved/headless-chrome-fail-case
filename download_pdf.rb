require_relative 'scrapppy'

session = Capybara::Session.new(:headless)
# session.driver.browser

list_files

puts "First click on a newtab_link"
session.visit "http://localhost:8000/"
link_node = session.find_link(id: "newtab_link")
puts "Clicking link"
link_node.click
puts "Waiting a few seconds"
sleep 3
list_files

puts "Now click on a normal link"
link_node = session.find_link(id: "normal_link")
puts "Clicking link"
link_node.click
puts "Waiting a few seconds"
sleep 3
list_files
