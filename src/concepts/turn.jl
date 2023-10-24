export Phase, BeginningPhase, PreCombatMainPhase, CombatPhase, PostCombatMainPhase, EndingPhase
export Step, UntapStep, UpkeepStep, DrawStep, BeginningOfCombatStep, DeclareAttackersStep, DeclareBlockersStep, CombatDamageStep, EndOfCombatStep, EndStep, CleanupStep
export PHASES, STEPS
export TurnStructure
export next, is_end_of_phase, is_end_of_turn, first_step
export ExtraTurns, AdditionalPhases

@enum Phase BeginningPhase PreCombatMainPhase CombatPhase PostCombatMainPhase EndingPhase

@enum Step UntapStep UpkeepStep DrawStep BeginningOfCombatStep DeclareAttackersStep DeclareBlockersStep CombatDamageStep EndOfCombatStep EndStep CleanupStep

@component struct TurnStructure
    turn_count::Int
    phase::Phase
    step::Union{Step, Nothing}
end

is_end_of_phase(ts::TurnStructure) = isnothing(ts.step) || ts.step == last(STEPS[ts.phase])
is_end_of_turn(ts::TurnStructure) = is_end_of_phase(ts) && findfirst(isequal(ts.phase), PHASES)
first_step(p::Phase) = isempty(STEPS[p]) ? nothing : first(STEPS[p])

TurnStructure(turn_count::Int, phase::Phase) = TurnStructure(turn_count, phase, first_step(phase))

function next(ts::TurnStructure)
    turn_count, phase, step = ts.turn_count, ts.phase, ts.step
    # next phase
    if is_end_of_phase(ts)
        ind = findfirst(isequal(phase), PHASES)
        # next turn
        if ind == length(PHASES)
            turn_count = turn_count + 1
            phase = first(PHASES)
            step = first_step(phase)
            return TurnStructure(turn_count, phase, step)
        else
            # just next phase
            phase = PHASES[ind+1]
            step = isempty(STEPS[phase]) ? nothing : first(STEPS[phase])
            return TurnStructure(turn_count, phase, step)
        end
    else
        # next step
        ind = findfirst(isequal(step), STEPS[phase])
        step = STEPS[phase][ind+1]
        return TurnStructure(turn_count, phase, step)
    end
end

const PHASES = (BeginningPhase, PreCombatMainPhase, CombatPhase, PostCombatMainPhase, EndingPhase)
const STEPS = Dict(
    BeginningPhase => (UntapStep, UpkeepStep, DrawStep),
    PreCombatMainPhase => (),
    CombatPhase => (BeginningOfCombatStep, DeclareAttackersStep, DeclareBlockersStep, CombatDamageStep, EndOfCombatStep),
    PostCombatMainPhase => (),
    EndingPhase => (EndStep, CleanupStep),
)

struct ExtraTurn
    player::Entity
    referent::Vector{Entity}
end

@component struct ExtraTurns
    turns::Vector{ExtraTurn}
end

@component struct AdditionalPhases
    phases::Vector{Phase}
end