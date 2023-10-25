struct TurnKeeper <: System end
Overseer.requested_components(::TurnKeeper) = (PlayersHavePassedPriorityInSuccession, TurnStructure, ExtraTurns, AdditionalPhases)

function Overseer.update(::TurnKeeper, m::AbstractLedger)
    # next step/phase
    gi = game_info(m)
    if !in(gi, m[PlayersHavePassedPriorityInSuccession])
        return
    end

    ts = m[gi][TurnStructure]
    turn_count, phase, step = ts.turn_count, ts.phase, ts.step
    ap = active_player(m)

    # additional phases
    if is_end_of_phase(ts) && gi in m[AdditionalPhases]
        phase = popfirst!(m[gi][AdditionalPhases].phases)
        # delete AdditionalPhases component if it's empty
        isempty(m[gi][AdditionalPhases].phases) && pop!(m[AdditionalPhases], gi)
        ts = TurnStructure(turn_count, phase)
        Entity(m, MessagingComponent{StartTurnStructure}(StartTurnStructure(ts, ap)))
        return
    end

    # extra turns
    if is_end_of_turn(ts) && gi in m[ExtraTurns]
        turn = popfirst!(m[gi][ExtraTurns].turns)
        # delete ExtraTurns component if it's empty
        isempty(m[gi][ExtraTurns].turns) && pop!(m[ExtraTurns], gi)
        # TODO referent
        ts = TurnStructure(turn_count + 1, first(PHASES))
        Entity(m, MessagingComponent{StartTurnStructure}(StartTurnStructure(ts, turn.player)))
        return
    end

    # as usual
    Entity(m, MessagingComponent{StartTurnStructure}(StartTurnStructure(next(ts), next_player(m))))
    return
end