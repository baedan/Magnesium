export ShuffleComponent, ShuffleDeckComponent
export PileOrientation, Top, Bottom
export AbstractShuffleDeckComponent

abstract type PileOrientation end
struct Top <: PileOrientation end
struct Bottom <: PileOrientation end

"""
Denotes that a zone entity needs the top or bottom `n` cards shuffled.
"""
@component struct ShuffleComponent{T<:PileOrientation}
    n::Int
end

""" 
Denotes that a zone entity needs to be shuffled.
"""
@component struct ShuffleDeckComponent end

const AbstractShuffleDeckComponent = Union{ShuffleComponent, ShuffleDeckComponent}