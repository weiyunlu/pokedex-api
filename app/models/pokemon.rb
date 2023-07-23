class Pokemon < ApplicationRecord
    validates :pokedex_id, :name, :type1, :total, :hp, :attack, :defense, :sp_atk, :sp_def, 
        :speed, :generation, presence: true
    validates_uniqueness_of :pokedex_id, scope: :alternate_form_id
    validates_uniqueness_of :name
    
    VALID_TYPES = %w[Normal Fire Water Grass Electric Ice Fighting Poison Ground Flying Psychic Bug
                     Rock Ghost Dark Dragon Steel Fairy]

    validates :type1, inclusion: VALID_TYPES
    validates :type2, inclusion: VALID_TYPES, allow_blank: true

    def total
        (hp || 0) + (attack || 0) + (defense || 0) + (sp_atk || 0) + (sp_def || 0) + (speed || 0)
    end

    # entity for APIs obscures database object id and exposes computed total stat
    def entity
        {
            pokedex_id: pokedex_id,
            alternate_form_id: alternate_form_id,
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
            generation: generation,
            legendary: legendary
        }
    end
end
