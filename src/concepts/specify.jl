"""
    specify([io::IO = stdout], e::Entity, m::AbstractLedger)

Print a description that specifies `e` to `io`.
"""
function specify(io::IO, e::Entity, m::AbstractLedger)
    # specify zone
    if m[e] in IsZoneComponent{OwnedZoneType}
        specify(io, m[e][IsZoneComponent{OwnedZoneType}], m)
        return
    end
    if m[e] in PlayerComponent
        specify(io, m[e][PlayerComponent], m)
        return
    end
end

specify(e::Entity, m::AbstractLedger) = specify(stdout, e, m)

function specify(::IO, c, ::AbstractLedger) end