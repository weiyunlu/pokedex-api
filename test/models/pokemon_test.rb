require "test_helper"

class PokemonTest < ActiveSupport::TestCase
  # validations

  test 'is valid with all fields, default form_id of 0' do
    pokemon = Pokemon.new(pokedex_id: 1, name: 'Bulbasaur', type1: 'Grass', type2: 'Poison', 
      hp: 45, attack: 49, defense: 49, sp_atk: 65, sp_def: 65, speed: 45, generation: 1, legendary: false)
    assert pokemon.valid?
    assert_equal 0, pokemon.form_id
  end

  test 'is valid without type2' do
    pokemon = Pokemon.new(pokedex_id: 1, name: 'Bulbasaur', type1: 'Grass', 
      hp: 45, attack: 49, defense: 49, sp_atk: 65, sp_def: 65, speed: 45, generation: 1, legendary: false)
    assert pokemon.valid?
  end

  test 'is invalid without pokedex_id' do
    pokemon = Pokemon.new(name: 'Bulbasaur', type1: 'Grass', type2: 'Poison', 
      hp: 45, attack: 49, defense: 49, sp_atk: 65, sp_def: 65, speed: 45, generation: 1, legendary: false)
    refute pokemon.valid?
  end

  test 'is invalid without name' do
    pokemon = Pokemon.new(pokedex_id: 1, type1: 'Grass', type2: 'Poison', 
      hp: 45, attack: 49, defense: 49, sp_atk: 65, sp_def: 65, speed: 45, generation: 1, legendary: false)
    refute pokemon.valid?
  end

  test 'is invalid when name is not unique' do
    Pokemon.create(pokedex_id: 1, name: 'Bulbasaur', type1: 'Grass', type2: 'Poison', 
      hp: 45, attack: 49, defense: 49, sp_atk: 65, sp_def: 65, speed: 45, generation: 1, legendary: false)

    pokemon = Pokemon.new(pokedex_id: 2, name: 'Bulbasaur', type1: 'Grass', type2: 'Poison', 
      hp: 45, attack: 49, defense: 49, sp_atk: 65, sp_def: 65, speed: 45, generation: 1, legendary: false)

    refute pokemon.valid?
  end

  test 'is invalid when pokedex_id + form_id combination is not unique' do
    Pokemon.create(pokedex_id: 3, form_id: 0, name: 'Venusaur', type1: 'Grass', type2: 'Poison', 
      hp: 80, attack: 82, defense: 83, sp_atk: 100, sp_def: 100, speed: 80, generation: 1, legendary: false)

    pokemon = Pokemon.new(pokedex_id: 3, form_id: 0, name: 'VenusaurMega Venusaur', type1: 'Grass', type2: 'Poison',
      hp: 80, attack: 100, defense: 123, sp_atk: 122, sp_def: 120, speed: 80, generation: 1, legendary: false)

    refute pokemon.valid?
  end

  test 'is valid when alternate form has same pokedex_id and different form_id differs by a letter' do
    Pokemon.create(pokedex_id: 3, form_id: 0, name: 'Venusaur', type1: 'Grass', type2: 'Poison', 
      hp: 80, attack: 82, defense: 83, sp_atk: 100, sp_def: 100, speed: 80, generation: 1, legendary: false)

    pokemon = Pokemon.new(pokedex_id: 3, form_id: 1, name: 'VenusaurMega Venusaur', type1: 'Grass', type2: 'Poison',
      hp: 80, attack: 100, defense: 123, sp_atk: 122, sp_def: 120, speed: 80, generation: 1, legendary: false)

    assert pokemon.valid?
  end

  test 'is invalid without any of type1, hp, attack, defense, sp_atk, sp_def, speed, generation' do
    params = {
      pokedex_id: 1, name: 'Bulbasaur', type1: 'Grass', type2: 'Poison', 
      hp: 45, attack: 49, defense: 49, sp_atk: 65, sp_def: 65, speed: 45, generation: 1, legendary: false
    }

    %w[type1 hp attack defense sp_atk sp_def speed generation].each do |field|
      updated_params = params.merge({ field.to_sym => nil })
      pokemon = Pokemon.new(updated_params)
      refute pokemon.valid?
    end
  end

  # total

  test 'total computes the total stats' do
    pokemon = Pokemon.create(pokedex_id: 1, name: 'Bulbasaur', type1: 'Grass', type2: 'Poison', 
      hp: 45, attack: 49, defense: 49, sp_atk: 65, sp_def: 65, speed: 45, generation: 1, legendary: false)

    assert_equal pokemon.total, pokemon.hp + pokemon.attack + pokemon.defense + pokemon.sp_atk + pokemon.sp_def + pokemon.speed
  end

  # entity

  test 'entity returns a json without the database id and with the computed total stat' do
    pokemon = Pokemon.create(pokedex_id: 1, name: 'Bulbasaur', type1: 'Grass', type2: 'Poison', 
      hp: 45, attack: 49, defense: 49, sp_atk: 65, sp_def: 65, speed: 45, generation: 1, legendary: false)

    expected_entity = {
      pokedex_id: pokemon.pokedex_id,
      form_id: pokemon.form_id,
      name: pokemon.name,
      type1: pokemon.type1,
      type2: pokemon.type2,
      total: pokemon.total,
      hp: pokemon.hp,
      attack: pokemon.attack,
      defense: pokemon.defense,
      sp_atk: pokemon.sp_atk,
      sp_def: pokemon.sp_def,
      speed: pokemon.speed,
      generation: pokemon.generation,
      legendary: pokemon.legendary
    }

    assert_equal pokemon.entity, expected_entity
  end
end
