class Api::PokemonController < ApplicationController
    def index
        limit = params[:limit] || 10
        offset = params[:offset] || 0

        @pokemon_list = Pokemon.limit(limit).offset(offset)

        render json: @pokemon_list
    end

    def show
        @pokemon = Pokemon.find_by(pokedex_id: params[:id])

        if @pokemon
            render json: @pokemon
        else
            render json: "Pokemon with pokedex_id #{params[:id]} was not found.", status: 404
        end
    end

    def create
        @pokemon = Pokemon.new(
            pokedex_id: pokemon_params[:pokedex_id],
            name: pokemon_params[:name],
            type1: pokemon_params[:type1],
            type2: pokemon_params[:type2],
            total: pokemon_params[:total],
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
            render json: @pokemon, status: 201
        else
            render json: "Errors creating pokemon: #{@pokemon.errors.details}", status: 400
        end
    end

    def update
        @pokemon = Pokemon.find_by(pokedex_id: params[:id])

        if @pokemon
            if @pokemon.update(
                pokedex_id: pokemon_params[:pokedex_id] || @pokemon.pokedex_id,
                name: pokemon_params[:name] || @pokemon.name,
                type1: pokemon_params[:type1] || @pokemon.type1,
                type2: pokemon_params[:type2] || @pokemon.type2,
                total: pokemon_params[:total] || @pokemon.total,
                hp: pokemon_params[:hp] || @pokemon.hp,
                attack: pokemon_params[:attack] || @pokemon.attack,
                defense: pokemon_params[:defense] || @pokemon.defense,
                sp_atk: pokemon_params[:sp_atk] || @pokemon.sp_atk,
                sp_def: pokemon_params[:sp_def] || @pokemon.sp_def,
                speed: pokemon_params[:speed] || @pokemon.speed,
                generation: pokemon_params[:generation] || @pokemon.generation,
                legendary: pokemon_params[:legendary] || @pokemon.legendary
            )
                render json: @pokemon
            else
                render json: "Errors updating pokemon with pokedex_id #{params[:id]}: #{@pokemon.errors.details}",
                    status: 400
            end
        else
            render json: "Pokemon with pokedex_id #{params[:id]} was not found.", status: 404
        end
    end

    def destroy
        @pokemon = Pokemon.find_by(pokedex_id: params[:id])

        if @pokemon
            @pokemon.destroy
            render json: "Pokemon with pokedex_id #{params[:id]} was deleted."
        else
            render json: "Pokemon with pokedex_id #{params[:id]} was not found.", status: 404
        end
    end

    private

    def pokemon_params
        params.require(:pokemon).permit([
            :pokedex_id,
            :name,
            :type1,
            :type2,
            :total,
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
