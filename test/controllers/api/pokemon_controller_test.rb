require "test_helper"

class Api::PokemonControllerTest < ActionDispatch::IntegrationTest
  def pokemon_params(pokedex_id = 999, form_id = 0, name = "Missingno")
    {
      pokedex_id: pokedex_id,
      form_id: form_id,
      name: name,
      type1: 'Flying',
      type2: 'Normal',
      hp: 100,
      attack: 100,
      defense: 100,
      sp_atk: 100,
      sp_def: 100,
      speed: 100,
      generation: 100,
      legendary: false
    }
  end
  
  # index

  # show
  test '#show finds pokemon with default form when form_id not passed' do
    pokemon = Pokemon.create(pokemon_params)

    get '/api/pokemon/999'

    assert_equal response.body, pokemon.entity.to_json
    assert_response 200
  end

  test '#show finds pokemon with specified form when form_id passed' do
    pokemon = Pokemon.create(pokemon_params)
    pokemon_alt = Pokemon.create(pokemon_params(999, 1, "MissingnoAlt"))

    get '/api/pokemon/999', params: { form_id: 1 }

    assert_equal response.body, pokemon_alt.entity.to_json
    assert_response 200
  end

  test '#show returns 404 error when pokemon cannot be found' do
    get '/api/pokemon/1'
    assert_response 404
  end

  # create
  test '#create creates pokemon with 201 status when successful' do
    
  end

  test '#create returns 400 error when pokemon could not be created' do
  end

  # update
  test '#update updates pokemon with 200, only on provided parameters, when successful' do
  end

  test '#update returns 400 error when update unsuccessful' do
  end

  # destroy
  test '#destroy destroys pokemon with 200, when found' do
  end

  test '#destroy returns 404 error when pokemon cannot be found' do
  end
end
