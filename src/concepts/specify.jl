export specify

"""
    specify([io::IO = stdout], e::Entity, m::AbstractLedger)

Print a description that specifies `e` to `io`.
"""
function specify(io::IO, e::Overseer.AbstractEntity, m::AbstractLedger)
    # specify zone
    if e in m[IsZoneComponent{OwnedZoneType}]
        specify(io, m[e][IsZoneComponent{OwnedZoneType}], m)
        return
    end
    if e in m[IsZoneComponent{UnownedZoneType}]
        specify(io, m[e][IsZoneComponent{UnownedZoneType}], m)
        return
    end
    if e in m[PlayerComponent]
        specify(io, m[e][PlayerComponent], m)
        return
    end
end

specify(e::Overseer.AbstractEntity, m::AbstractLedger) = specify(stdout, e, m)

function specify(::IO, c, ::AbstractLedger) end