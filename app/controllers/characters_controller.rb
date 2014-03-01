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
      elsif params.has_key? :character and params[:character].has_key? :items_attributes
        @character.update_attributes item_params
        if @character.save
          render "update_items.js.coffee"
        end
      else
        @character.update_attributes coin_params
        if @character.save
          respond_to do |format|
            format.html { redirect_to( @character )}
            format.json { render :update_coins }
          end
        end
      end
    else
      redirect_to current_user
    end
  end

  def destroy
    @character = Character.find(params[:id])
    if current_user == @character.user
      @character.destroy
    end
    redirect_to current_user
  end

  private
  def coin_params
    params.require(:character).permit(*COIN_DENOMINATIONS)
  end

  def item_params
    params.require(:character).permit(:name, items_attributes: [:id, :text, :_destroy])
  end
end
