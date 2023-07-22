class Api::PokemonController < ApplicationController
    def index
        limit = params[:limit] || 10
        offset = params[:offset] || 0

        @pokemon_list = Pokemon.order(pokedex_id: :asc, form_id: :asc).limit(limit).offset(offset)

        render json: @pokemon_list.map { |pokemon| pokemon.entity }
    end

    def show
        form_id = params[:form_id] || 0
        @pokemon = Pokemon.find_by(pokedex_id: params[:id], form_id: form_id)

        if @pokemon
            render json: @pokemon.entity
        else
            render json: "Pokemon with pokedex_id #{params[:id]}, form_id #{form_id} was not found.", status: 404
        end
    end

    def create
        form_id = pokemon_params[:form_id] || 0

        @pokemon = Pokemon.new(
            pokedex_id: pokemon_params[:pokedex_id],
            form_id: form_id,
            name: pokemon_params[:name],
            type1: pokemon_params[:type1],
            type2: pokemon_params[:type2],
            hp: pokemon_params[:hp],
            attack: pokemon_params[:attack],
            defense: pokemon_params[:defense],
            sp_atk: pokemon_params[:sp_atk],
            sp_def: pokemon_params[:sp_def],
            speed: pokemon_params[:speed],
            generation: pokemon_params[:generation],
            legendary: pokemon_params[:legendary]
        )

        if @pokemon.save
            render json: @pokemon.entity, status: 201
        else
            render json: "Errors creating pokemon: #{@pokemon.errors.details}", status: 400
        end
    end

    def update
        form_id = params[:form_id] || 0
        @pokemon = Pokemon.find_by(pokedex_id: params[:id], form_id: form_id)

        if @pokemon
            if @pokemon.update(
                pokedex_id: pokemon_params[:pokedex_id] || @pokemon.pokedex_id,
                form_id: pokemon_params[:form_id] || @pokemon.form_id,
                name: pokemon_params[:name] || @pokemon.name,
                type1: pokemon_params[:type1] || @pokemon.type1,
                type2: pokemon_params[:type2] || @pokemon.type2,
                hp: pokemon_params[:hp] || @pokemon.hp,
                attack: pokemon_params[:attack] || @pokemon.attack,
                defense: pokemon_params[:defense] || @pokemon.defense,
                sp_atk: pokemon_params[:sp_atk] || @pokemon.sp_atk,
                sp_def: pokemon_params[:sp_def] || @pokemon.sp_def,
                speed: pokemon_params[:speed] || @pokemon.speed,
                generation: pokemon_params[:generation] || @pokemon.generation,
                legendary: pokemon_params[:legendary] || @pokemon.legendary
            )
                render json: @pokemon.entity
            else
                render json: "Errors updating pokemon with pokedex_id #{params[:id]}, form_id #{form_id}: #{@pokemon.errors.details}",
                    status: 400
            end
        else
            render json: "Pokemon with pokedex_id #{params[:id]} was not found.", status: 404
        end
    end

    def destroy
        form_id = params[:form_id] || 0
        @pokemon = Pokemon.find_by(pokedex_id: params[:id], form_id: form_id)

        if @pokemon
            @pokemon.destroy
            render json: "Pokemon with pokedex_id #{params[:id]}, form_id #{form_id} was deleted."
        else
            render json: "Pokemon with pokedex_id #{params[:id]}, form_id #{form_id} was not found.", status: 404
        end
    end

    private

    def pokemon_params
        params.require(:pokemon).permit([
            :pokedex_id,
            :form_id,
            :name,
            :type1,
            :type2,
            :hp,
            :attack,
            :defense,
            :sp_atk,
            :sp_def,
            :speed,
            :generation,
            :legendary
        ])
    end
end
