using Overseer

struct InitializeGame <: System end
Overseer.requested_components(::InitializeGame) = (PlayerInfo,)

function Overseer.update(::InitializeGame, m::AbstractLedger)
    game_ledger = Ledger()

    for t in (ZoneShortcut{UnownedZoneType}, ZoneShortcut{OwnedZoneType})
        Overseer.ensure_component!(game_ledger, t)
    end
    
    game_info = Entity(game_ledger,GameInfo())

    for player_info in @entities_in(m, PlayerInfo)
        player = Entity(game_ledger, 
            PlayerComponent(player_info.player_name,20,false,false))
        shortcut = create_zones_and_shortcuts(OwnedZoneType,player,game_ledger)
        game_ledger[player] = ZoneShortcut(shortcut)
    end

    shortcut = create_zones_and_shortcuts(UnownedZoneType,nothing,game_ledger)
    game_ledger[game_info] = ZoneShortcut(shortcut)
    return game_ledger
end

function create_zones_and_shortcuts(t::Type{T}, owner, m::AbstractLedger) where T<:ZoneType
    shortcut = Dict{t, Entity}()
    for zone_type in instances(t)
        zone = Entity(m, IsZoneComponent(zone_type,owner))
        shortcut[zone_type] = zone
    end
    shortcut
end