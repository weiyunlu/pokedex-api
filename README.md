# README

This is a Pokédex API using https://gist.github.com/armgilles/194bcff35001e7eb53a2a8b441e8b2c6 as seed data.

**Some design choices**

* `total` is a computed value (sum of other stats) rather than its own column in the database.
* We use the `pokedex_id` instead of the database object id as the `:id` parameter for API endpoints.
* Some pokemon have alternate forms with the same `pokedex_id`, so we differentiate with a `alternate_form_id`.  For example, Venusaur has `pokedex_id = 3, alternate_form_id = 0` and Mega Venusaur has `pokedex_id = 3, alternate_form_id = 1`.  This pair is unique.
* The returned JSON is an entity which obscures the database object id, but exposes the computed `total` stat.
* We validate that `type1` and `type2` (if it is present) must be one of the currently existing 18 Pokémon types.  Note that presently this is case sensitive following convention in the seed data (must start with capital letter, followed by lower case letters - e.g. `Flying` is good, but `flying` and `FLYING` are not.).

***

### Endpoints available

pokemon_params = `{ :pokedex_id, :alternate_form_id, :name, :type1, :type2, :hp, :attack, :defense, :sp_atk, :sp_def, :speed, :generation, :legendary }`

* `get /api/pokemon` will return a paginated list of Pokémon.  Optional params `limit` and `offset` with default 10 and 0.  Sorted by ascending `[pokedex_id, alternate_form_id]`.
* `get /api/pokemon/:id` will return Pokémon with `[pokedex_id, alternate_form_id]` equal to `[:id, params[:alternate_form_id]]` (with default of 0 for `params[:alternate_form_id]`).
* `post /api/pokemon` will create a new Pokémon, with params `{ pokemon: pokemon_params }`.  All the `pokemon_params` are required except for `alternate_form_id` (default 0) and `type2` (default nil).
* `put /api/pokemon/:id` will update the Pokémon with `[pokedex_id, alternate_form_id]` equal to `[:id, params[:alternate_form_id]]` (with default of 0 for `params[:alternate_form_id]`).  Any values provided in params `{ pokemon: pokemon_params }` will be updated, rest will be unchanged.
* `delete /api/pokemon/:id` will delete the Pokémon with `[pokedex_id, alternate_form_id]` equal to `[:id, params[:alternate_form_id]]` (with default of 0 for `params[:alternate_form_id]`).