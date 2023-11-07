struct PriorityKeeper <: System end
Overseer.requested_components(::PriorityKeeper) = ()

function Overseer.update(::PriorityKeeper, m::AbstractLedger)
    # player passes priority
    gi = game_info(m)
    if m[Priority][gi].player in m[PassPriority]
        popfirst!(m[ConsecutivePriorityPassing][gi])
        # player loses priority
        m[Priority][gi] = Priority(nothing)
        # all players have passed priority consecutively
        if isempty(m[ConsecutivePriorityPassing][gi])
            m[gi][PlayersHavePassedPriorityInSuccession] = PlayersHavePassedPriorityInSuccession()
        else
            # not all players have passed priority consecutively
            # then create a MessagingComponent to give the next player priority
            p = first(m[ConsecutivePriorityPassing][gi])
            Entity(m, MessagingComponent{ReceivePriority}(ReceivePriority(p)))
        end
    end
end