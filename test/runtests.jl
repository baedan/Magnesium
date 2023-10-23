using Aqua
using Magnesium
using Magnesium.Concepts
using Magnesium.Systems
using Magnesium.Utilities
using Test
using Overseer

function test_InitializeGame(players::AbstractArray{PlayerInfo})
    l = Ledger()
    for player in players
        Entity(l, player)
    end
    return Overseer.update(InitializeGame(), l)
end

@testset "Magnesium.jl" begin
#=     @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(Magnesium)
    end =#
    # Write your tests here.


end

@testset "Initialize Game" begin
    h = test_InitializeGame(
        [PlayerInfo(DeckList(), "Malatesta")])

    @test h[first(players(h))][PlayerComponent] == PlayerComponent("Malatesta")
    @testset "zone $z" for z in instances(OwnedZoneType)
        @test h[IsZoneComponent{OwnedZoneType}][zone(h, z, h[first(players(h))])].zone_type == z
        @test h[IsZoneComponent{OwnedZoneType}][zone(h, z, h[first(players(h))])].owner == first(players(h))
    end
    @testset "zone $z" for z in instances(UnownedZoneType)
        @test h[IsZoneComponent{UnownedZoneType}][zone(h, z)].zone_type == z
        @test h[IsZoneComponent{UnownedZoneType}][zone(h, z)].owner === nothing
    end
end

@testset "Display" begin
    h = test_InitializeGame([PlayerInfo(DeckList(), "Malatesta")])
    buf = IOBuffer()
    specify(buf, h[first(players(h))], h)
    @test String(take!(buf)) == "Player Malatesta"
    @testset "zone $z" for z in instances(OwnedZoneType)
        specify(buf, zone(h, z, h[first(players(h))]),h)
        @test String(take!(buf)) == "Player Malatesta's $z"
    end
    @testset "zone $z" for z in instances(UnownedZoneType)
        specify(buf, zone(h, z),h)
        @test String(take!(buf)) == "The $z"
    end
end

