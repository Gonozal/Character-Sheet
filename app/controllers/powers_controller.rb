class PowersController < ApplicationController
  def show
    @power = Power.find(params[:id])
  end
end
