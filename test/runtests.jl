using Aqua
using Magnesium
using Magnesium.Concepts
using Magnesium.Systems
using Magnesium.Utilities
using Test
using Overseer

@testset "Magnesium.jl" begin
#=     @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(Magnesium)
    end =#
    # Write your tests here.


end

@testset "Initialize Game" begin
    function test_InitializeGame(players::AbstractArray{PlayerInfo})
        l = Ledger()
        for player in players
            Entity(l, player)
        end
        return Overseer.update(InitializeGame(), l)
    end

    @testset let h = test_InitializeGame(
            [PlayerInfo(DeckList(), "Malatesta")])
        @test h[first(players(h))][PlayerComponent] == PlayerComponent("Malatesta")
    end

end

