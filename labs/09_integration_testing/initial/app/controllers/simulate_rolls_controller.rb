class SimulateRollsController < ApplicationController
  def index
    render_simulation
  end

  def clear
    session[:simulation] = nil
    redirect_to :action => :index
  end

  def simulate
    roll = params[:faces].split(/[ :_,-]+/).map { |s| s.to_i }
    sim_data.push(roll)
    redirect_to :action => :index
  end

  private

  def render_simulation
    if sim_data.empty?
      render :text => "SIMULATION IS OFF"
    else
      render :text => "SIMULATING: #{sim_data.inspect}"
    end
  end

  def sim_data
    session[:simulation] ||= []
  end
end
