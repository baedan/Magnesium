export OwnedZoneType, Hand, Library, Graveyard, Exile, Sideboard
export UnownedZoneType, Battlefield, Stack
export ZoneType
export IsZoneComponent
export InZoneComponent
export ContainingObjectsComponent
export ZoneShortcut

@enum OwnedZoneType::UInt8 Hand Library Graveyard Exile Sideboard
@enum UnownedZoneType::UInt8 Battlefield Stack
const ZoneType = Union{OwnedZoneType, UnownedZoneType}

"""
An `Entity` with a `IsZoneComponent` component is a zone entity.

# Example
```
# this zone is Entity(1)'s hand
IsZoneComponent{OwnedZone}(Hand, Entity(1))

# this zone is the stack
IsZoneComponent{UnownedZone}(Stack, nothing)
```
"""
@component struct IsZoneComponent{T<:ZoneType}
    zone_type::T
    owner::Union{Entity, Nothing}
    IsZoneComponent{T}(z,o) where {T<:ZoneType} = new(z,o)
    IsZoneComponent{OwnedZoneType}(z,::Nothing) =
        @error "Cannot create zone $z without an owner."
    IsZoneComponent{UnownedZoneType}(z,::Entity) =
        @error "Cannot create zone $z with an owner."
end

IsZoneComponent(z::T,o::S) where {T<:ZoneType, S<:Union{Entity,Nothing}} =
    IsZoneComponent{T}(z,o)

"""
An `Entity` with an `InZoneComponent` component is in a zone.
"""
@component struct InZoneComponent
    in_zone::Entity
end

@component struct ContainingObjectsComponent
    contained_objects::Vector{Entity}
end

@component struct ZoneShortcut{T<:ZoneType}
    zone_shortcut::Dict{T, Entity}
end

function specify(io::IO, zone::IsZoneComponent{OwnedZoneType}, m::AbstractLedger)
    specify(io, zone.owner::Entity, m)
    print(io, "'s $(zone.zone_type)")
end

specify(io::IO, zone::IsZoneComponent{UnownedZoneType}, m::AbstractLedger) = print(io, "The $(zone.zone_type)")