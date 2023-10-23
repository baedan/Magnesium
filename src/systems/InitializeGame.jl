using Overseer

export InitializeGame

struct InitializeGame <: System end
Overseer.requested_components(::InitializeGame) = (PlayerInfo,)

function Overseer.update(::InitializeGame, m::AbstractLedger)
    game_ledger = Ledger()

    for t in (ZoneShortcut{UnownedZoneType}, ZoneShortcut{OwnedZoneType},
        ContainingObjectsComponent)
        Overseer.ensure_component!(game_ledger, t)
    end
    
    game_info = Entity(game_ledger,GameInfo())

    for player_info in @entities_in(m, PlayerInfo)
        player = Entity(game_ledger, 
            PlayerComponent(player_info.player_name,20,false,false))
        shortcut = create_zones_and_shortcuts(game_ledger,OwnedZoneType,player)
        game_ledger[player] = ZoneShortcut(shortcut)
        game_ledger[shortcut[Library]] = 
            ContainingObjectsComponent(initialize_list(player_info.decklist))
    end

    shortcut = create_zones_and_shortcuts(game_ledger,UnownedZoneType)
    game_ledger[game_info] = ZoneShortcut(shortcut)
    return game_ledger
end

function create_zones_and_shortcuts(m::AbstractLedger, t::Type{T}, owner::Union{Entity,Nothing}=nothing) where T<:ZoneType
    shortcut = Dict{t, Entity}()
    for zone_type in instances(t)
        zone = Entity(m, IsZoneComponent(zone_type,owner))
        shortcut[zone_type] = zone
    end
    shortcut
end