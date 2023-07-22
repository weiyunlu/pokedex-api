class Pokemon < ApplicationRecord
    validates :pokedex_id, :name, :type1, :total, :hp, :attack, :defense, :sp_atk, :sp_def, 
        :speed, :generation, presence: true
    validates_uniqueness_of :pokedex_id
    validates_uniqueness_of :name
end
