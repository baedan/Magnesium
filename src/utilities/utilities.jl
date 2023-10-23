module Utilities
export players, zone
using ..Concepts, Overseer

players(m::AbstractLedger) = [player for player in @entities_in(m, PlayerComponent)]

function zone(m::AbstractLedger, type::ZoneType, owner::Union{Entity, Nothing}=nothing) end
function zone(m::AbstractLedger, type::UnownedZoneType, ::Nothing)
    game_info = Entity(m[GameInfo], 1)
    shortcut = m[game_info][ZoneShortcut{UnownedZoneType}]
    return shortcut[type]
end
function zone(m::AbstractLedger, type::OwnedZoneType, owner::Entity)
    shortcut = m[owner][ZoneShortcut{OwnedZoneType}]
    return shortcut[type]
end
end