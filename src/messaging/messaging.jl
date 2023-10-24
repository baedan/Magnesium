module Messaging
export MessagingComponent
using ..Concepts
using Overseer


@component struct MessagingComponent{T}
    payload::T
    referent::Union{Vector{Entity}, Nothing}
end

MessagingComponent{T}(payload::T) where {T} = MessagingComponent{T}(payload, nothing)

include("StartTurnStructure.jl")

end