class SettingsController < ApplicationController
  
  def intro
    flow[:text] = params[:id]
    @in_process = in_flow?(:process)
  end
  
  def outro
  end
  
  %w[one two three four five six seven eight].each do |number|
    define_method number do
      render :partial => 'step'
    end
  end
  
end

