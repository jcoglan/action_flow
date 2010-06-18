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

Then /^I am at the end of the "([^\"]+)" flow$/ do |_|
  Then 'I should not see "Next"'
end