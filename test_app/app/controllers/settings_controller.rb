class SettingsController < ApplicationController
  
  def intro
    flow[:text] = params[:id]
    @in_process = in_flow?(:process)
  end
  
  def outro
  end
  
  def one
    render :partial => 'step'
  end
  
  def two
    render :partial => 'step'
  end
  
  def three
    render :partial => 'step'
  end
  
end

