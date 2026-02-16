class PokemonsController < ApplicationController
  before_action :authenticate_user!

  def index
    @pokemons = current_user.captured_pokemons.order(created_at: :desc)
  end

  def show
    
  end

  def destroy
    @pokemon = current_user.captured_pokemons.find(params[:id])
    @pokemon.destroy
    
    redirect_to pokemons_path, notice: "Você libertou #{@pokemon.name} na natureza."
  end
end