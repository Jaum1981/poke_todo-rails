class LootboxController < ApplicationController
  before_action :authenticate_user!

  def index
    @new_pokemon = current_user.captured_pokemons.find_by(id: params[:new_pokemon_id]) if params[:new_pokemon_id]
  end

  def open
    cost = 100

    if current_user.points < cost
      redirect_to lootbox_path, alert: "Você precisa de #{cost} XP para jogar!"
      return
    end

    pokemon_data = PokemonService.catch_random

    if pokemon_data
      ActiveRecord::Base.transaction do
        current_user.decrement!(:points, cost)

        @new_pokemon = current_user.captured_pokemons.create!(
          name: pokemon_data[:name],
          poke_api_id: pokemon_data[:poke_api_id],
          sprite_url: pokemon_data[:sprite_url]
        )
      end

      redirect_to lootbox_path(new_pokemon_id: @new_pokemon.id)
    else
      redirect_to lootbox_path, alert: "A máquina travou (Erro na API). Tente de novo, seus pontos não foram gastos."
    end
  end
end
