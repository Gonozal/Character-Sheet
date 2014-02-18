class FeatsController < ApplicationController
  def show
    @feat = Feat.find(prams[:id])
  end
end
