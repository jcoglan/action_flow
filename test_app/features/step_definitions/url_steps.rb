When /^(?:|I )visit "([^\"]+)"$/ do |url|
  visit(url)
end

Then /^I should be at "([^\"]+)"$/ do |url|
  URI.parse(current_url).path.should == url
end