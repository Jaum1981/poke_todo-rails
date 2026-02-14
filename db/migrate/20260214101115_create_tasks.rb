class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.integer :difficulty, default: 0 # 0 será easy, 1 medio e 2 dificil
      t.boolean :completed, default: false
      t.boolean :points_claimed, default: false # essa é minha trava de segurança para não abusarem dos pontos gerados
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
