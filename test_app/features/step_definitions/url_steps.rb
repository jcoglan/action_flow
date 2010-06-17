module ActionFlow
  def define_flows(flow_dsl_string)
    ApplicationController.instance_eval do
    
      ActionFlow.configure do
        instance_eval(flow_dsl_string)
      end
    end
  end
end

World(ActionFlow)

Given "I have the flows:" do |dsl|
  define_flows(dsl)
end

When /^(?:|I )visit "([^\"]+)"$/ do |url|
  visit(url)
end

Then /^I should be at "([^\"]+)"$/ do |url|
  URI.parse(current_url).path.should == url
end