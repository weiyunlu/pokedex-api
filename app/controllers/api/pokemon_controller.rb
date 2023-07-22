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
    end

    def update
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
end
