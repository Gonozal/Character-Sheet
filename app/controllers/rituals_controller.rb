class RitualsController < ApplicationController
  def show
    @ritual = Ritual.find(prams[:id])
  end
end
