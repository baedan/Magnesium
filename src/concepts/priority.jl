export PlayersHavePassedPriorityInSuccession
@component struct PlayersHavePassedPriorityInSuccession end

@component struct Priority
    player::Union{Entity, Nothing}
end