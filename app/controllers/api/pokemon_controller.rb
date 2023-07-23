class Api::PokemonController < ApplicationController
    def index
        limit = params[:limit] || 10
        offset = params[:offset] || 0

        @pokemon_list = Pokemon.order(pokedex_id: :asc, alternate_form_id: :asc).limit(limit).offset(offset)

        render json: @pokemon_list.map { |pokemon| pokemon.entity }
    end

    def show
        alternate_form_id = params[:alternate_form_id] || 0
        @pokemon = Pokemon.find_by(pokedex_id: params[:id], alternate_form_id: alternate_form_id)

        if @pokemon
            render json: @pokemon.entity
        else
            render json: "Pokemon with pokedex_id #{params[:id]}, alternate_form_id #{alternate_form_id} was not found.", status: 404
        end
    end

    def create
        alternate_form_id = pokemon_params[:alternate_form_id] || 0
        @pokemon = Pokemon.new(pokemon_params.merge({alternate_form_id: alternate_form_id}))

        if @pokemon.save
            render json: @pokemon.entity, status: 201
        else
            render json: "Errors creating pokemon: #{@pokemon.errors.details}", status: 400
        end
    end

    def update
        alternate_form_id = params[:alternate_form_id] || 0
        @pokemon = Pokemon.find_by(pokedex_id: params[:id], alternate_form_id: alternate_form_id)

        if @pokemon
            if @pokemon.update(pokemon_params)
                render json: @pokemon.entity
            else
                render json: "Errors updating pokemon with pokedex_id #{params[:id]}, alternate_form_id #{alternate_form_id}: #{@pokemon.errors.details}",
                    status: 400
            end
        else
            render json: "Pokemon with pokedex_id #{params[:id]} was not found.", status: 404
        end
    end

    def destroy
        alternate_form_id = params[:alternate_form_id] || 0
        @pokemon = Pokemon.find_by(pokedex_id: params[:id], alternate_form_id: alternate_form_id)

        if @pokemon
            @pokemon.destroy
            render json: "Pokemon with pokedex_id #{params[:id]}, alternate_form_id #{alternate_form_id} was deleted."
        else
            render json: "Pokemon with pokedex_id #{params[:id]}, alternate_form_id #{alternate_form_id} was not found.", status: 404
        end
    end

    private

    def pokemon_params
        params.require(:pokemon).permit([
            :pokedex_id,
            :alternate_form_id,
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
