class CreateCapturedPokemons < ActiveRecord::Migration[7.0]
  def change
    create_table :captured_pokemons do |t|
      t.string :name
      t.integer :poke_api_id
      t.string :sprite_url
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
