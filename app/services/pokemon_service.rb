class PokemonService
  include HTTParty
  base_uri 'https://pokeapi.co/api/v2'

  def self.catch_random
    random_id = rand(1..151)
    response = get("/pokemon/#{random_id}")
    return nil unless response.success?
    {
      name: response['name'].capitalize,
      poke_api_id: response['id'],
      sprite_url: response['sprites']['other']['official-artwork']['front_default'] || response['sprites']['front_default'],
      types: response['types'].map { |t| t['type']['name'] }
    }
  end
end