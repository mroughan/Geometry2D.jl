module Geometry2D

using PyPlot
import PyPlot: plot
import Base: convert, length, promote, promote_rule, sort, sort!, unique

export G2dObject, G2dTransform, G2dSimpleObject, G2dCompoundObject
 
abstract G2dObject

abstract G2dTransform <: G2dObject
abstract G2dSimpleObject <: G2dObject
abstract G2dCompoundObject <: G2dObject

# automated promotion rules, for use primarily in constructors
promote_rule{T<:Integer,S<:FloatingPoint}(::Type{Array{T,1}}, ::Type{Array{S,1}} ) = Array{S,1}
promote_rule{T<:Integer}(::Type{Array{Rational{T},1}}, ::Type{Array{T,1}}) = Array{Rational{T},1}
promote_rule{T<:Integer,S<:Integer}(::Type{Array{Rational{T},1}}, ::Type{Array{S,1}}) = Array{Rational{promote_type(T,S)},1}
promote_rule{T<:Integer,S<:Integer}(::Type{Array{Rational{T},1}}, ::Type{Array{Rational{S},1}}) = Array{Rational{promote_type(T,S)},1}
promote_rule{T<:Integer,S<:FloatingPoint}(::Type{Array{Rational{T},1}}, ::Type{Array{S,1}})  = Array{promote_type(T,S), 1}
# should probably put something in here for complex numbers too

tolerance = eps() # global variable for tolerance of many operations in floating point

# various parts of the package
include("point.jl")
# include("utilities.jl")
# include("plots.jl")
# include("convexhull.jl")

end # module