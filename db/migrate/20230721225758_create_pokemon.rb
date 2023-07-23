class CreatePokemon < ActiveRecord::Migration[7.0]
  def change
    create_table :pokemon do |t|
      t.integer :pokedex_id, null: false
      t.integer :alternate_form_id, null: false, default: 0
      t.string :name, null: false, unique: true
      t.string :type1, null: false
      t.string :type2
      t.integer :hp, null: false
      t.integer :attack, null: false
      t.integer :defense, null: false
      t.integer :sp_atk, null: false
      t.integer :sp_def, null: false
      t.integer :speed, null: false
      t.integer :generation, null: false
      t.boolean :legendary, null: false, default: false

      t.timestamps

      t.index [:pokedex_id, :alternate_form_id], unique: true
      t.index :name, unique: true
    end
  end
end
