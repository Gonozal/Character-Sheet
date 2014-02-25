class CharactersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @character = Character.find(params[:id])
    redirect_to current_user unless current_user == @character.user
  end

  def update
    @character = Character.find(params[:id])
    if current_user == @character.user
      hp_change = params[:character][:hp_change].to_i
      hs_change = params[:character][:hs_change].to_i
      if params.has_key? :heal
        @character.heal(hp_change, hs_change)
        @character.save
        render :update_hp
      elsif params.has_key? :damage
        @character.damage(hp_change)
        @character.save
        render :update_hp
      elsif params.has_key? :temp_hp
        @character.set_temp_hp(hp_change)
        @character.save
        render :update_hp
      elsif params.has_key? :short_rest
        @character.short_rest(hp_change, hs_change)
        @character.save
        render :update_rested
      elsif params.has_key? :long_rest
        @character.long_rest params[:character]
        @character.save
        @character = Character.find(params[:id])
        render :update_extended_rest
      end
    else
      redirect_to current_user
    end
  end
end
