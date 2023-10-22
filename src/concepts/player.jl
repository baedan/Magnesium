export PlayerComponent, ControllerComponent, OwnerComponent

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