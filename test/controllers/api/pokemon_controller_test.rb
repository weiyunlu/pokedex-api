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

  def create_twenty_missingnos
    (0..19).each do |i|
      Pokemon.create(pokemon_params(999, i, "Missingno Alt#{i}"))
    end
  end
  
  # index
  test '#index returns paginated list with default limit of 10, offset of 0' do
    create_twenty_missingnos

    get '/api/pokemon'

    parsed_response = JSON.parse(response.body)
    assert_equal 10, parsed_response.size
    assert_equal 0, parsed_response.first['form_id']
  end

  test '#index returns limited/offset paginated list when params passed' do
    create_twenty_missingnos

    get '/api/pokemon', params: { limit: 5, offset: 10 }

    parsed_response = JSON.parse(response.body)
    assert_equal 5, parsed_response.size
    assert_equal 10, parsed_response.first['form_id']
  end

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
  test '#create creates pokemon and returns entity with 201 status when successful' do
    post '/api/pokemon', params: { pokemon: pokemon_params }
    assert_response 201

    assert_equal 1, Pokemon.count
    assert_equal response.body, Pokemon.first.entity.to_json
  end

  test '#create returns 400 error when pokemon could not be created' do
    post '/api/pokemon', params: { pokemon: pokemon_params.merge(hp: nil) }
    assert_response 400

    assert_equal 0, Pokemon.count
  end

  # update
  test '#update updates pokemon with 200, when successful' do
    pokemon = Pokemon.create(pokemon_params)
    put '/api/pokemon/999', params: { pokemon: { hp: 120, attack: 120 } }

    pokemon.reload
    assert_equal 120, pokemon.hp
    assert_equal 120, pokemon.attack
    assert_equal pokemon_params[:defense], pokemon.defense
    assert_equal pokemon_params[:speed], pokemon.speed

    assert_response 200
  end

  test '#update updates pokemon with alternate form with 200, when successful' do
    pokemon = Pokemon.create(pokemon_params)
    pokemon2 = Pokemon.create(pokemon_params(999, 1, 'MissingnoAlt'))

    put '/api/pokemon/999', params: { form_id: 1, pokemon: { hp: 120, attack: 120 } }

    pokemon.reload
    pokemon2.reload

    assert_equal 100, pokemon.hp
    assert_equal 100, pokemon.attack
    assert_equal 120, pokemon2.hp
    assert_equal 120, pokemon2.attack

    assert_response 200
  end

  test '#update returns 400 error when update unsuccessful' do
    pokemon = Pokemon.create(pokemon_params)
    pokemon2 = Pokemon.create(pokemon_params(999, 1, 'MissingnoAlt'))

    put '/api/pokemon/999', params: { pokemon: { form_id: 1 }}
    assert_response 400
  end

  # destroy
  test '#destroy destroys pokemon with 200, when found' do
    pokemon = Pokemon.create(pokemon_params)

    delete '/api/pokemon/999'
    assert_equal 0, Pokemon.count
    assert_response 200
  end

  test '#destroy destroys pokemon with alternate form with 200, when found' do
    pokemon = Pokemon.create(pokemon_params)
    pokemon2 = Pokemon.create(pokemon_params(999, 1, 'MissingnoAlt'))

    delete '/api/pokemon/999', params: { form_id: 1 }
    assert_equal 1, Pokemon.count
    assert_equal 0, Pokemon.first.form_id
    assert_response 200
  end

  test '#destroy returns 404 error when pokemon cannot be found' do
    delete '/api/pokemon/1'
    assert_response 404
  end
end
