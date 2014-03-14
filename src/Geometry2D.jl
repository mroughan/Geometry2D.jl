module Geometry2D

using PyPlot 
import PyPlot: plot, fill, polar

import Base: convert, length, promote, promote_rule, sort, sort!, sortperm, unique, isfinite, isnan, copy, Array, eltype, abs, isequal, isless, ones, zeros, angle, sign, print, rationalize
import Base: !, !=, $, %, .%, &, *, +, -, .!=, .+, .-, .*, ./, .<, .<=, .==, .>,
    .>=, .\, .^, /, //, <, <:, <<, <=, ==, >, >=, >>, .>>, .<<, >>>,
    <|, |>, \, ^, |, ~, !==, >:, colon, hcat, vcat, hvcat, getindex, setindex!,
    transpose, ctranspose

export G2dObject, G2dTransform, G2dSimpleObject, G2dCompoundObject
export tolerance
 
abstract G2dObject

# abstract G2dTransform <: G2dObject
abstract G2dSimpleObject <: G2dObject # objects for which area,perimeter,isin, make no sense
abstract G2dCompoundObject <: G2dObject

# automated promotion rules for arrays of numbers
promote_rule{T<:Integer,S<:FloatingPoint}(::Type{Array{T,1}}, ::Type{Array{S,1}} ) = Array{S,1}
promote_rule{T<:Integer}(::Type{Array{Rational{T},1}}, ::Type{Array{T,1}}) = Array{Rational{T},1}
promote_rule{T<:Integer,S<:Integer}(::Type{Array{Rational{T},1}}, ::Type{Array{S,1}}) = Array{Rational{promote_type(T,S)},1}
promote_rule{T<:Integer,S<:Integer}(::Type{Array{Rational{T},1}}, ::Type{Array{Rational{S},1}}) = Array{Rational{promote_type(T,S)},1}
promote_rule{T<:Integer,S<:FloatingPoint}(::Type{Array{Rational{T},1}}, ::Type{Array{S,1}})  = Array{promote_type(T,S), 1}
# should probably put something in here for complex numbers too

tolerance = eps() # global variable for tolerance of many operations in floating point

# various parts of the package
include("point.jl")
include("bounds.jl")
include("utilities.jl")
include("line.jl")
include("triangle.jl")
include("circle.jl")
include("ellipse.jl")
include("polygon.jl")
include("transform.jl")
include("intersection.jl")
include("plot.jl")
# include("convexhull.jl")

include("vectorize.jl")


end # module
