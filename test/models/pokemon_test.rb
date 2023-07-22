require "test_helper"

class PokemonTest < ActiveSupport::TestCase
  test 'is valid with all fields' do
    pokemon = Pokemon.new(pokedex_id: '1', name: 'Bulbasaur', type1: 'Grass', type2: 'Poison', total: 318, 
      hp: 45, attack: 49, defense: 49, sp_atk: 65, sp_def: 65, speed: 45, generation: 1, legendary: false)
    assert pokemon.valid?
  end

  test 'is valid without type2' do
    pokemon = Pokemon.new(pokedex_id: '1', name: 'Bulbasaur', type1: 'Grass', total: 318, 
      hp: 45, attack: 49, defense: 49, sp_atk: 65, sp_def: 65, speed: 45, generation: 1, legendary: false)
    assert pokemon.valid?
  end

  test 'is invalid without pokedex_id' do
    pokemon = Pokemon.new(name: 'Bulbasaur', type1: 'Grass', type2: 'Poison', total: 318, 
      hp: 45, attack: 49, defense: 49, sp_atk: 65, sp_def: 65, speed: 45, generation: 1, legendary: false)
    refute pokemon.valid?
  end

  test 'is invalid without name' do
    pokemon = Pokemon.new(pokedex_id: '1', type1: 'Grass', type2: 'Poison', total: 318, 
      hp: 45, attack: 49, defense: 49, sp_atk: 65, sp_def: 65, speed: 45, generation: 1, legendary: false)
    refute pokemon.valid?
  end

  test 'is invalid when name is not unique' do
    Pokemon.create(pokedex_id: '1', name: 'Bulbasaur', type1: 'Grass', type2: 'Poison', total: 318, 
      hp: 45, attack: 49, defense: 49, sp_atk: 65, sp_def: 65, speed: 45, generation: 1, legendary: false)

    pokemon = Pokemon.new(pokedex_id: '2', name: 'Bulbasaur', type1: 'Grass', type2: 'Poison', total: 318, 
      hp: 45, attack: 49, defense: 49, sp_atk: 65, sp_def: 65, speed: 45, generation: 1, legendary: false)

    refute pokemon.valid?
  end

  test 'is invalid when alternate form pokedex_id is not unique' do
    Pokemon.create(pokedex_id: '3', name: 'Venusaur', type1: 'Grass', type2: 'Poison', total: 525, 
      hp: 80, attack: 82, defense: 83, sp_atk: 100, sp_def: 100, speed: 80, generation: 1, legendary: false)

    pokemon = Pokemon.new(pokedex_id: '3', name: 'VenusaurMega Venusaur', type1: 'Grass', type2: 'Poison',
      total: 625, hp: 80, attack: 100, defense: 123, sp_atk: 122, sp_def: 120, speed: 80, generation: 1, legendary: false)

    refute pokemon.valid?
  end

  test 'is valid when alternate form pokedex_id differs by a letter' do
    Pokemon.create(pokedex_id: '3', name: 'Venusaur', type1: 'Grass', type2: 'Poison', total: 525, 
      hp: 80, attack: 82, defense: 83, sp_atk: 100, sp_def: 100, speed: 80, generation: 1, legendary: false)

    pokemon = Pokemon.new(pokedex_id: '3A', name: 'VenusaurMega Venusaur', type1: 'Grass', type2: 'Poison',
      total: 625, hp: 80, attack: 100, defense: 123, sp_atk: 122, sp_def: 120, speed: 80, generation: 1, legendary: false)

    assert pokemon.valid?
  end

  test 'is invalid without any of type1, total, hp, attack, defense, sp_atk, sp_def, speed, generation' do
    params = {
      pokedex_id: '1', name: 'Bulbasaur', type1: 'Grass', type2: 'Poison', total: 318, 
      hp: 45, attack: 49, defense: 49, sp_atk: 65, sp_def: 65, speed: 45, generation: 1, legendary: false
    }

    %w[type1 total hp attack defense sp_atk sp_def speed generation].each do |field|
      updated_params = params.merge({ field.to_sym => nil })
      pokemon = Pokemon.new(updated_params)
      refute pokemon.valid?
    end
  end
end
