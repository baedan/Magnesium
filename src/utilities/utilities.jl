module Utilities
export players, zone, game_info, active_player, next_player
using ..Concepts, Overseer

players(m::AbstractLedger) = [player for player in @entities_in(m, PlayerComponent)]

game_info(m::AbstractLedger) = Entity(m[GameInfo], 1)

function zone(m::AbstractLedger, type::ZoneType, owner::Union{Overseer.AbstractEntity, Nothing}=nothing) end
function zone(m::AbstractLedger, type::UnownedZoneType, ::Nothing)
    shortcut = m[game_info(m)][ZoneShortcut{UnownedZoneType}]
    return (shortcut.zone_shortcut)[type]
end
function zone(m::AbstractLedger, type::OwnedZoneType, owner::Overseer.AbstractEntity)
    shortcut = m[owner][ZoneShortcut{OwnedZoneType}]
    return (shortcut.zone_shortcut)[type]
end

active_player(m::AbstractLedger) = m[game_info(m)][ActivePlayerComponent].ap

next_player(m::AbstractLedger) = iterate(m[game_info(m)][PlayOrder], active_player(m))
end