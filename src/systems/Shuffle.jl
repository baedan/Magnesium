using Random

struct Shuffle <: System end
Overseer.requested_components(::Shuffle) = (ContainingObjectsComponent, ShuffleComponent{Top}, 
    ShuffleComponent{Bottom}, ShuffleDeckComponent, IsZoneComponent{UnownedZoneType}, IsZoneComponent{OwnedZoneType})

function Overseer.update(::Shuffle, m::AbstractLedger)
    for zone in @entities_in(m, (IsZoneComponent{OwnedZoneType} || IsZoneComponent{UnownedZoneType}) && ShuffleDeckComponent)
        Random.shuffle!(zone[ContainingObjectsComponent].o)
        @info "Player $(zone[IsZoneComponent].owner)'s $(zone[IsZoneComponent].zone_type) is shuffled."
    end
    for zone in @entities_in(m, (IsZoneComponent{OwnedZoneType} || IsZoneComponent{UnownedZoneType}) && (ShuffleComponent{Top} || ShuffleComponent{Bottom}))
        card_count = length(zone[ContainingObjectsComponent].o)
        shuffle_count = zone[ShuffleComponent{Top}].n
        card_count < shuffle_count && @error "Cannot shuffle $shuffle_count cards when there's only $card_count cards in the zone."
        if zone in ShuffleComponent{Top}
            Random.shuffle!(view(zone[ContainingObjectsComponent].o, 1:zone[ShuffleComponent{Top}].n))
        elseif zone in ShuffleComponent{Bottom}
            Random.shuffle!(view(zone[ContainingObjectsComponent].o, 1:zone[ShuffleComponent{Top}].n))
        end

    end
    for zone in @entities_in(m, (IsZoneComponent{OwnedZoneType} || IsZoneComponent{UnownedZoneType}) && ShuffleComponent{Top})
        
        Random.shuffle!(view(zone[ContainingObjectsComponent].o, 1:length(zone[ContainingObjectsComponent].o)))
    end

end

function shuffle!(z::Entity, shuffle_component::T, m::AbstractLedger) where {T<:AbstractShuffleDeckComponent}
    shuffle!(m[z][ContainingObjectsComponent], shuffle_component)
end

function shuffle!(z::ContainingObjectsComponent, shuffle_component::AbstractShuffleDeckComponent) end

shuffle!(z::ContainingObjectsComponent, ::ShuffleDeckComponent) = Random.shuffle!(z.o)

function shuffle!(z::ContainingObjectsComponent, shuffle_component::ShuffleComponent{T<:PileOrientation})
    card_count = length(z.o)
    shuffle_count = shuffle_component.n
    card_count < shuffle_count && @error "Cannot shuffle $shuffle_count cards when there's only $card_count cards in the zone."
    if T isa Type{Top}
        Random.shuffle!(view(z.o, 1:shuffle_count))
    else
        Random.shuffle!(view(z.o, card_count-shuffle_count+1:card_count))
    end
end