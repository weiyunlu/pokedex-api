require 'csv'

Pokemon.destroy_all

seeds_file = CSV.read('config/pokemon.csv')

def str_to_bool(s)
	s == 'True'
end

(1..seeds_file.length - 1).each do |line|
    pkmn = seeds_file[line]

    # some pokemon have multiple forms with same pokedex_id in the CSV file
    # we will disambiguate by incrementing form_id in this case
    if Pokemon.find_by(pokedex_id: pkmn[0])
        form_id = Pokemon.last.form_id + 1
    else
        form_id = 0
    end

    Pokemon.create(
        pokedex_id: pkmn[0],
        form_id: form_id,
        name: pkmn[1],
        type1: pkmn[2],
        type2: pkmn[3],
        hp: pkmn[5].to_i,
        attack: pkmn[6].to_i,
        defense: pkmn[7].to_i,
        sp_atk: pkmn[8].to_i,
        sp_def: pkmn[9].to_i,
        speed: pkmn[10].to_i,
        generation: pkmn[11].to_i,
        legendary: str_to_bool(pkmn[12])
    )
end
