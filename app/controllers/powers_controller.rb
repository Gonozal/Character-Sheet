class PowersController < ApplicationController
  def show
    @power = Power.find(params[:id])
    redirect_to current_user unless current_user == @power.character.user
  end

  def update
    @power = Power.find params[:id]
    if current_user == @power.character.user
      case params[:power][:action]
      when "increase_usage"
        @power.increase_usage
      when "decrease_usage"
        @power.decrease_usage
      end
      if @power.save
        @character = @power.character
        render 'update.json.jbuilder'
      else
        render nothing: true
      end
    else
      redirect_to current_user unless current_user == @power.character.user
    end
  end
end
