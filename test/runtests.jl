using Magnesium
using Test
using Aqua

@testset "Magnesium.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(Magnesium)
    end
    # Write your tests here.
end
