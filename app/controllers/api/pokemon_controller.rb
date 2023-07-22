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
        @pokemon = Pokemon.new(pokemon_params.merge({form_id: form_id}))

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
            if @pokemon.update(pokemon_params)
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
