class CharactersController < ApplicationController
  def index
    @characters = Character.all
  end

  def show
    @character = Character.find(params[:id])
  end

  def update
    @character = Character.find(params[:id])
    hp_change = params[:character][:hp_change].to_i
    hs_change = params[:character][:hs_change].to_i
    if params.has_key? :heal
      @character.heal(hp_change, hs_change)
      render :update_hp
    elsif params.has_key? :damage
      @character.damage(hp_change)
      render :update_hp
    elsif params.has_key? :temp_hp
      @character.set_temp_hp(hp_change)
      render :update_hp
    elsif params.has_key? :short_rest
      @character.short_rest(hp_change, hs_change)
      render :update_rested
    elsif params.has_key? :long_rest
      @character.long_rest
      render :update_extended_rest
    end
    @character.save
  end
end
