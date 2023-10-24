@enum Phase BeginningPhase PreCombatMainPhase CombatPhase PostCombatMainPhase EndingPhase

@enum Step UntapStep UpkeepStep DrawStep BeginningOfCombatStep DeclareAttackersStep DeclareBlockersStep CombatDamageStep EndOfCombatStep EndStep CleanupStep

@component struct TurnStructure
    turn_count::Int
    active_player::Overseer.AbstractEntity
    phase::Phase
    step::Step
end

const PHASES = (BeginningPhase, PreCombatMainPhase, CombatPhase, PostCombatMainPhase, EndingPhase)
const STEPS = (
    BeginningPhase => (UntapStep, UpkeepStep, DrawStep),
    PreCombatMainPhase => (),
    CombatPhase => (BeginningOfCombatStep, DeclareAttackersStep, DeclareBlockersStep, CombatDamageStep, EndOfCombatStep),
    PostCombatMainPhase => (),
    EndingPhase => (EndStep, CleanupStep),
)
