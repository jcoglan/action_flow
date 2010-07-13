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
      skip ? redirect_to(skip) : render(:partial => 'step')
    end
  end
  
  def passthrough
    redirect_to next_in_flow(:product => params[:id])
  end
  
  def poison
    session[:flow_status][:process] = :not_a_flow_state
    render :text => 'done'
  end
  
  def delete
    session[:flow_status][:nonexistent] = [1,1,{},false]
    render :text => 'done'
  end
  
end

