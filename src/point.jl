
export Point, Vect, PointArray

export origin, originF

export points_x, points_y, isfinite, isinf, isnan, eltype, isless, isequal, convert, cmp, angle, abs, distance, distance2, ones, zeros, quadrant, sign, print, bounded, displayPath, displayPoints, closed, inner, length, acute, polar, polar2
export PointRand, PointArrayRand 

# define a "point" temporarily with "type" instead of "immutable" to avoid a bug
type Point{T<:Number} <: G2dSimpleObject
    x::T
    y::T
end
# convenience constructor
Point{T<:Number, S<:Number}(x::T, y::S) = Point(promote(x,y)...)
PointRand() = Point(rand(), rand())

# various ways of constructing the origin
const originF =  Point(0.0,0.0) # for using in defaults for keyword arguments
origin() = Point(0,0) # default to the exact origin
origin(T::DataType) = Point(convert(T,0),  convert(T,0))
origin{T<:Number}(::Point{T}) = Point(convert(T,0),  convert(T,0))

# at the moment I'm not making a distinction between a point and vector
#   just have the alias to make some nomenclature easier
typealias Vect Point

# automated promotion rules for Points
promote_rule{T<:Integer,S<:FloatingPoint}(::Type{Point{T}}, ::Type{Point{S}} ) = Point{S}
promote_rule{T<:Integer}(::Type{Point{Rational{T}}}, ::Type{Point{T}}) = Point{Rational{T}}
promote_rule{T<:Integer,S<:Integer}(::Type{Point{Rational{T}}},::Type{Point{S}}) = Point{Rational{promote_type(T,S)}}
promote_rule{T<:Integer,S<:Integer}(::Type{Point{Rational{T}}},::Type{Point{Rational{S}}}) = Point{Rational{promote_type(T,S)}}
promote_rule{T<:Integer,S<:FloatingPoint}(::Type{Point{Rational{T}}}, ::Type{Point{S}})  = Point{promote_type(T,S)}
# should probably put something in here for complex numbers too

# don't seem to need these?
# convert{T<:FloatingPoint}(::Type{Point{T}}, p::Point) = Point(convert(T,p.x), convert(T,p.y))
# convert{T<:Integer}(::Type{Point{Rational{T}}}, p::Point) = Point(convert(Rational{T},p.x), convert(Rational{T},p.y))
# convert{T<:Integer}(::Type{Point{T}}, p::Point) = Point(convert(T,p.x), convert(T,p.y))

# arithmetic
+(z::Number, p1::Point) = Point(p1.x+z, p1.y+z)
+(p1::Point, z::Number) = Point(p1.x+z, p1.y+z)
+(p1::Point, p2::Point) = Point(p1.x+p2.x, p1.y+p2.y)
-(p1::Point, p2::Point) = Point(p1.x-p2.x, p1.y-p2.y)
-(p::Point) = Point(-p.x, -p.y)
*(k::Number, p2::Point) = Point(k * p2.x, k * p2.y)
*(p2::Point, k::Number) = Point(k * p2.x, k * p2.y)
/(p2::Point, k::Number) = Point(p2.x/k, p2.y/k)
.*(k::Number, p2::Point) = Point(k * p2.x, k * p2.y)
.*(p2::Point, k::Number) = Point(k * p2.x, k * p2.y)
.*(p1::Point, p2::Point) = Point(p1.x * p2.x, p1.y * p2.y)
./(p2::Point, k::Number) = Point(p2.x/k, p2.y/k)
^{T<:Number}(p::Point{T},e::Integer) = Point(p.x^e, p.y^e)
^{T<:Number}(p::Point{T},e::Real) = Point(p.x^e, p.y^e)
inner(p1::Point, p2::Point) = p1.x * p2.x    +     p1.y * p2.y

# comparisons (perform lexicographically)
isequal(p1::Point, p2::Point) = ( p1.x==p2.x && p1.y==p2.y )
isless(p1::Point, p2::Point) = ( p1.x<p2.x || (p1.x==p2.x && p1.y<p2.y) )
!=(p1::Point, p2::Point) = !isequal(p1, p2)
< (p1::Point, p2::Point) = isless(p1,p2)
> (p1::Point, p2::Point) = p2<p1
# isequal{T<:FloatingPoint}(p1::Point{T}, p2::Point{T}) = ( abs(p1-p2) <= Point(tolerance, tolerance))
# isequal{T<:Number, S<:Number}(p1::Point{T}, p2::Point{S}) = isequal(promote(p1,p2)...) 
==(p1::Point, p2::Point) = isequal(p1, p2)
.< (p1::Point, p2::Point) = p1<p2
.> (p1::Point, p2::Point) = p2<p1
.>=(p1::Point, p2::Point) = p1<=p2
.<=(p1::Point, p2::Point) = p2<=p1
cmp(p1::Point, p2::Point) = p1<p2 ? -1 : p2<p1 ? 1 : 0


# utility functions
isfinite(p::Point) = isfinite(p.x) & isfinite(p.y)
isinf(p::Point) = !isfinite(p)
isnan(p::Point) = isnan(p.x) | isnan(p.y)
eltype{T<:Number}(p::Point{T}) = T
convert{T<:Number, S<:Number}(::Type{Point{T}}, p::Point{S}) = Point(convert(T,p.x), convert(T,p.y))
bounded(p::Point) = true
length(p::Point) = 1 # just for convenience

# does the shape define an "inside" and "outside" of the plane
closed(::Point) = false

abs(p::Point) = Point(abs(p.x), abs(p.y))
sign(p::Point) = Point(sign(p.x), sign(p.y))
function quadrant(p::Point) # output the correct quadrant (1=++, 2=-+, 3=--, 4=+-)
    s = sign(p)
    if s.x==1 && s.y==1
        return 1
    elseif s.x==-1 && s.y==1
        return 2
    elseif s.x==-1 && s.y==-1
        return 3
    elseif s.x==1 && s.y==-1
        return 4
    else 
        return 0 # if it is on one of the axes, return zero
    end
end

# mathsy functions, NB: these don't necessarily return the type of the input

# angle WRT x-axis, as implied b the (potentially user defined) origin "o"
angle(p::Point, o::Point) = atan2( p.y-o.y, p.x-o.x )
angle(p::Point) = angle(p, origin(p)) # default is o=(0,0)
# angle between three points
function angle(p1::Point, p2::Point, p3::Point)
    v1 = p2-p1
    v2 = p2-p3
    d1 = distance(v1)
    d2 = distance(v2)
    tmp = inner(v1,v2) / (d1*d2)
    tmp = minimum([tmp one(tmp)])
    tmp = maximum([tmp -one(tmp)])
    return acos( tmp )
end
# often don't need the actual angle, just whether it is accute, or obtuse
#   this function returns 1 if the angle is acute, and 0 for a rightangle and -1 for obtuse
function acute(p1::Point, p2::Point, p3::Point)
    v1 = p2-p1
    v2 = p2-p3
    d1 = distance(v1)
    d2 = distance(v2)
    tmp = inner(v1,v2)
    # println(  " angle=$(angle(p1,p2,p3)/(pi/2)), acute=$(sign(tmp))")
    return sign( tmp )
end

# distance and distance squared (default is distance from the origin) 
distance2(p1::Point) = p1.x^2 + p1.y^2
distance(p1::Point) = sqrt( distance2(p1) )
distance2(p1::Point, p2::Point) = distance2(p2 - p1)
distance(p1::Point, p2::Point) = sqrt( distance2(p1,p2) )

# polar coordinates
polar2(p::Point) = [ angle(p), distance(p) ]
function polar(p::Point; tolerance=1.0e-12)
    a,d = polar2(p)
    if abs(d) < tolerance
        return 0.0, 0.0
    elseif abs(a-pi/2) < tolerance 
        return pi/2, d
    elseif abs(a+pi/2) < tolerance 
        return pi/2, -d
    elseif a>pi/2
        return a-pi, -d
    elseif a<-pi/2
        return a+pi, -d 
    else
        return a,d
    end
end

# functions to get x and y coordinates
points_x(p::Point) = p.x
points_y(p::Point) = p.y

# IO
print(p::Point) = print("x=$(p.x), y=$(p.y)")

# function for plotting
displayPoints(p::Point) = p


###############################################################
# tools to deal with general array of points
#    this doesn't help??? typealias PointArray{T<:Number} Array{Point{T}}

# constructor for arrays of points
function PointArray{T<:Number}(x::Array{T}, y::Array{T})
    if size(x) != size(y)
        error(" size of x must be the same as size y.")
    end
    if ndims(x)==1
        return [ Point(x[i], y[i]) for i=1:length(x) ]
    else
        return reshape([ Point(x[i], y[i]) for i=1:length(x) ], size(x))
    end
end
PointArray{T<:Number, S<:Number}(x::Array{T}, y::Array{S}) = PointArray(promote(x,y)...)
PointArray() = Array(Point{Float64},0)
PointArray(n::Integer) = PointArray(ones(n)*NaN, ones(n)*NaN)
PointArray(n::Integer, m::Integer) = PointArray(ones(n,m)*NaN, ones(n,m)*NaN)
zeros{T<:Number}(x::Array{Point{T}}) = PointArray(zeros(T,size(x)), zeros(T,size(x)))
ones{T<:Number}(x::Array{Point{T}}) = PointArray(ones(T,size(x)), ones(T,size(x)))
# could have "nans" and "infs" as well?

# create a set of random points
PointArrayRand(n::Integer, m::Integer) = PointArray(rand(n,m), rand(n,m))
PointArrayRand(n::Integer) = PointArray(rand(n), rand(n))

# return x or y coordinates
points_x{T<:Number}(p::Array{Point{T},1}) = [p[i].x for i=1:length(p)]
points_y{T<:Number}(p::Array{Point{T},1}) = [p[i].y for i=1:length(p)]
points_x{T<:Number}(p::Array{Point{T}}) = reshape( [p[i].x for i=1:length(p)], size(p) )
points_y{T<:Number}(p::Array{Point{T}}) = reshape( [p[i].y for i=1:length(p)], size(p) )

# bounds of an array of points
bounds{T<:Number}(p::Array{Point{T}}) = Bounds( maximum(points_y(p)), minimum(points_y(p)), minimum(points_x(p)), maximum(points_x(p)) )

# extend functions on a Point, to an array of Points
for f in (:abs, :sign, :quadrant, :angle, :distance2, :distance, )
    @eval begin
        function ($f){T<:Number}(p::Array{Point{T},1})
            return reshape( [($f)(p[i]) for i=1:length(p)], size(p) )
        end
    end
end

for f in (:angle, :distance, :distance2, :+, :-, :.*, :inner, :cmp, :isless, :isequal)
    @eval begin
        function ($f){T<:Number,S<:Number}(p1::Array{Point{T},1}, p2::Array{Point{S},1})
            if size(p1) != size(p2)
                error("arrays must be the same size")
            end
            return reshape( [($f)(p1[i],p2[i]) for i=1:length(p1)], size(p1) )
        end
        function ($f){T<:Number,S<:Number}(p1::Point{T}, p2::Array{Point{S},1})
            return reshape( [($f)(p1,p2[i]) for i=1:length(p2)], size(p2) )
        end
        function ($f){T<:Number,S<:Number}(p1::Array{Point{T},1}, p2::Point{S})
            return reshape( [($f)(p1[i],p2) for i=1:length(p1)], size(p1) )
        end
    end
end

eltype{T<:Number}(p::Array{Point{T}}) = Point{T}

#  function for plotting
displayPath(P::Array{Point}) = P
displayPoints(P::Array{Point}) = P
