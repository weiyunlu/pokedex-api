# README

This is a Pokedex API using https://gist.github.com/armgilles/194bcff35001e7eb53a2a8b441e8b2c6 as seed data.

Some design choices

* `total` is a computed value (sum of other stats) rather than its own column in the database.
* We use the `pokedex_id` instead of the databse object id as the `:id` parameter for API endpoints.
* Some pokemon have alternate forms with the same `pokedex_id`, so we differentiate with a `form_id`.  For example, Venusaur has `pokedex_id = 3, form_id = 0` and Mega Venusaur has `pokedex_id = 3, form_id = 1`.  This pair is unique.
* The returned JSON is an entity which obscures the database object id, but exposes the computed `total` stat.

***

Endpoints available

pokemon_params = `:pokedex_id, :form_id, :name, :type1, :type2, :hp, :attack, :defense, :sp_atk, :sp_def, :speed, :generation, :legendary`

* `get /api/pokemon` will return a list of all pokemon.  Optional params `limit` and `offset` with default 10 and 0.
* `get /api/pokemon/:id` will return pokemon with `[pokedex_id, form_id]` equal to `[:id, params[:form_id]]` (with default of 0 for `params[:form_id]`).
* `post /api/pokemon` will create a new pokemon, with params `{pokemon: pokemon_params}`.  All the `pokemon_params` are required except for `form_id` (default 0) and `type2` (default nil).
* `put /api/pokemon/:id` will update the pokemon with `[pokedex_id, form_id]` equal to `[:id, params[:form_id]]` (with default of 0 for `params[:form_id]`).  Any values provided in params `{ pokemon: pokemon_params }` will be updated.
* `destroy /api/pokemon/:id` will delete the pokemon with `[pokedex_id, form_id]` equal to `[:id, params[:form_id]]` (with default of 0 for `params[:form_id]`).