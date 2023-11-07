export PlayersHavePassedPriorityInSuccession, ConsecutivePriorityPassing
@component struct PlayersHavePassedPriorityInSuccession end

@component struct Priority
    player::Union{Entity, Nothing}
end

@component struct ConsecutivePriorityPassing
    players::Vector{Entity}
end

popfirst!(p::ConsecutivePriorityPassing) = popfirst!(p.players)
isempty(p::ConsecutivePriorityPassing) = isempty(p.players)
first(p::ConsecutivePriorityPassing) = first(p.players)
