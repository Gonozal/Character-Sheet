class ImportsController < ApplicationController
  def index
    Import.import
  end
end
