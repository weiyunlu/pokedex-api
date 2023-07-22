class Pokemon < ApplicationRecord
    validates :pokedex_id, :name, :type1, :total, :hp, :attack, :defense, :sp_atk, :sp_def, 
        :speed, :generation, presence: true
    validates_uniqueness_of :pokedex_id, scope: :form_id
    validates_uniqueness_of :name

    def total
        (hp || 0) + (attack || 0) + (defense || 0) + (sp_atk || 0) + (sp_def || 0) + (speed || 0)
    end

    # exposed entity obscures database object_id and shows computed total stat
    def entity
        {
            pokedex_id: pokedex_id,
            form_id: form_id,
            name: name,
            type1: type1,
            type2: type2,
            total: total,
            hp: hp,
            attack: attack,
            defense: defense,
            sp_atk: sp_atk,
            sp_def: sp_def,
            speed: speed,
            generation: 1,
            legendary: false
        }
    end
end
