class PowersController < ApplicationController
  def show
    @power = Power.find(params[:id])
  end

  def update
    @power = Power.find params[:id]
    puts params[:power].to_yaml
    case params[:power][:action]
    when "increase_usage"
      @power.increase_usage
    when "decrease_usage"
      @power.decrease_usage
    end
    puts @power.to_yaml
    if @power.save
      render json: @power, location: @power
    else
      render nothing: true
    end
  end
end
