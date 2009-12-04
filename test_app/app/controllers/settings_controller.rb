class SettingsController < ApplicationController
  
  def intro
    flow[:text] = params[:id]
    @in_process = in_flow?(:process)
  end
  
  def outro
  end
  
  %w[one two three four five six seven eight].each do |number|
    define_method number do
      skip = next_in_flow(:process) if in_flow?(:process) and params[:skip]
      skip or render(:partial => 'step')
    end
  end
  
end

