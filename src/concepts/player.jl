export PlayerComponent, ControllerComponent, OwnerComponent, ActivePlayerComponent, PlayOrder

"""
An `Entity` with a `PlayerComponent` *is* a player.
"""
@component struct PlayerComponent
    player_name::String
    player_life_total::Int
    player_has_won_the_game::Bool
    player_has_lost_the_game::Bool
end

PlayerComponent(name::String) = PlayerComponent(name, 20, false, false)

"""
An `Entity` with a `ControllerComponent` *has* a controller.
"""
@component struct ControllerComponent
    controller::Entity
end

"""
An `Entity` with an `OwnerComponent` *has* an owner.
"""
@component struct OwnerComponent
    owner::Entity
end

@component struct ActivePlayerComponent
    ap::Entity
end

@component struct PlayOrder
    order::Vector{Entity}
end

iterate(po::PlayOrder) = isempty(po.order) ? nothing : (first(po.order), first(po.order))
function iterate(po::PlayOrder, state::Entity)
        !in(state, po.order) && throw(ArgumentError("Player is not in the play order."))
        ind = findfirst(isequal(state), po.order)
        new_s = length(po.order) == ind ? first(po.order) : po.order[ind+1]
        return new_s, new_s
end

"""
    specify(io::IO, player_component::PlayerComponent, ::AbstractLedger)

Print a description of a player to `io`.

# Example
```jldoctest
using Magnesium, Overseer
m = Ledger()
e = Entity(m, Concepts.PlayerComponent("Malatesta"))
Concepts.specify(m[e][PlayerComponent], m)

# output

"Player Malatesta"
```
"""
specify(io::IO, player_component::PlayerComponent, ::AbstractLedger) = print(io, "Player $(player_component.player_name)")