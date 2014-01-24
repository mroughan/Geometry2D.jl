
export Point, PointSet, OrderedPair, PS, Triangle, TriangleC

export vecx, vecy

export isfinite, isinf, isnan, isempty, length, eltype, copy, sort, sort!, union, addpoint, rmpoint, pop, push, swap!, swap, isequal, PSx, PSy, randP

# define a "point"
#    at the moment I'm not making a distinction between a point and vector
immutable Point{T<:Number} <: G2dSimpleObject
    x::T
    y::T
end
# convenience constructor
Point{T<:Number, S<:Number}(x::T, y::S) = Point(promote(x,y)...);
 
vecx(p::Point) = p.x
vecy(p::Point) = p.y

+(z::Number, p1::Point) = Point(p1.x+z, p1.y+z)
+(p1::Point, z::Number) = Point(p1.x+z, p1.y+z)
+(p1::Point, p2::Point) = Point(p1.x+p2.x, p1.y+p2.y)
-(p1::Point, p2::Point) = Point(p1.x-p2.x, p1.y-p2.y)
*(k::Number, p2::Point) = Point(k * p2.x, k * p2.y)
*(p2::Point, k::Number) = Point(k * p2.x, k * p2.y)
/(p2::Point, k::Number) = Point(p2.x/k, p2.y/k)

type PointSet{T<:Number} <: G2dSimpleObject
    n::Int64
    x::Vector{T} # equivalent to Array{T,1}
    y::Vector{T}
    function PointSet(n::Int64,x::Vector{T},y::Vector{T})
        if length(x)==length(y)==n
            return new(n,x,y) 
        else
            error("vectors must have length n")
        end
    end 
    # NB: https://groups.google.com/forum/#!msg/julia-users/LWgATl9Pd64/VMQhVaEJSZUJ
    # the inner constructor creates methods of "PointSet{T}(...)" for each possible T
end
# main constructor to use
function PointSet{T<:Number}(x::Array{T,1},y::Array{T,1})
    if length(x)==length(y)
        n = length(x)
        return PointSet{T}(n,x,y) # T = eltype(x)
    else
        error("vectors must be the same length")
    end
end 
# convenience constructor
PointSet{T<:Number, S<:Number}(x::Array{T,1}, y::Array{S,1}) = PointSet(promote(x,y)...)
# default type will be Float64
PointSet() = PointSet(Array(Float64,0), Array(Float64,0))
PointSet(n::Integer) = PointSet(Array(Float64, n),  Array(Float64, n))

# generic functions
isfinite(p::PointSet) = isfinite(p.x) & isfinite(p.y)
isinf(p::PointSet) = !isfinite(p)
isnan(p::PointSet) = isnan(p.x) | isnan(p.y)
isempty(p::PointSet) = p.n==0
length(p::PointSet) = p.n
eltype{T}(p::PointSet{T}) = T
copy(p::PointSet) = PointSet(p.x, p.y)
function sort!(p::PointSet; algorithm=QuickSort)
    order = [1:p.n]
    function cmp(i, j)
        if p.x[i] < p.x[j]-tolerance
            return true
        elseif p.x[i] > p.x[j]+tolerance
            return false
        else
            return p.y[i]<p.y[j] ? true : false
        end
    end
    sort!(order, lt=cmp, alg=algorithm)
    p.x = p.x[order]
    p.y = p.y[order]
    return p
end 
sort(p::PointSet) = sort!(copy(p))
function push!{T}(p::PointSet{T}, x::T, y::T) 
    # add a point on the end
    p.n += 1
    push(p.x, x)
    push(p.y, y)
    return p
end
function pop!{T}(p::PointSet{T}, n::Integer) 
    # pop n points off the end
    #     but don't actually reallocate memory, as that could be slow
    if (n<=p.n)
        p.n -= n
    end
    return p
end

# function addpoint{T}(p::PointSet{T}, x::T, y::T, i::Integer) 
#     # add a point at an arbitrary position
#     if i > 1 && i < n
#         return PointSet( [p.x[1:i-1], x, p.x[i:end]], [p.y[1:i-1], y, p.y[i:end]] )
#     elseif i>1
#         return PointSet( [p.x, x], [p.y, y] )
#     elseif
#         return PointSet( [x, p.x], [y, p.y] )
#     end
# end

function rmpoint!{T}(p::PointSet{T}, i::Integer) 
    # remove a point
    #    but don't actually reallocate memory, as that could be slow
    p.x[i:end-1] = p.x[i+1:end]
    p.y[i:end-1] = p.y[i+1:end]
    p.n -= 1
    return p
end

function swap!(p::PointSet, i::Integer, j::Integer)
    tmpx = p.x[i]
    tmpy = p.y[i]
    p.x[i] = p.x[j]
    p.y[i] = p.y[j]
    p.x[j] = tmpx
    p.y[j] = tmpy
    return p
end
swap(p::PointSet, i::Integer, j::Integer) = swap!(copy(p))

function isin{T}(p::Point{T}, q::PointSet{T})
    if (eltype(q) <: FloatingPoint)
        for i=1:q.n
           if abs(p.x-q.x[i]) <= tolerance && abs(p.y-q.y[i]) <= tolerance
               return true
           end
        end
    else # for int and rational data types we can do exact comparisons
        for i=1:q.n
            if p.x==q.x[i] && p.y==q.y[i]
                return true
            end            
        end
    end
    return false
end

+{T<:Number}(p::PointSet{T}, q::PointSet{T}) = PointSet([PSx(p), PSx(q)], [PSy(p), PSy(q)])
+{T<:Number, S<:Number}(p::PointSet{T}, q::PointSet{S}) = PointSet(vcat(promote(PSx(p), PSx(q))), vcat(promote(PSy(p), PSy(q))))
# function union(p::PointSet, q::PointSet)
#     tmp = PointSet([x(p), x(q)], [y(p), y(q)])
#     return unique(tmp)
# end

function isequal(p::PointSet, q::PointSet)
    # have to have the same point, in the same order
    if p.m != q.n
        return false
    end
    if eltype(q) <: FloatingPoint
        for i=1:q.n
           if abs(p.x[i]-q.x[i]) > tolerance || abs(p.y[i]-q.y[i]) > tolerance
               return false
           end
        end
    else # for int and rational data types we can do exact comparisons
        for i=1:q.n
            if p.x[i]!=q.x[i] || p.y[i]!=q.y[i]
                return false
            end            
        end
    end
    return true
end

function PSx(p::PointSet)
    # use this to get x, to avoid cases where more memory is allocated than points
    return p.x[1:p.n]
end

function PSy(p::PointSet) 
    # use this to get y, to avoid cases where more memory is allocated than points
    return p.y[1:p.n]
end

function randP(n::Integer)
    x = rand(n)
    y = rand(n)
    return PointSet(x, y)
end

#################################################################


function Triangle(x,y)
    if length(x)==length(y)==3  
        return PointSet(x,y) 
    else
        error("vectors must be length 3")
    end
end

typealias PointSet3 Set{Point}


# also define a set of points (using an array of points)
#   really, this is just used for playing around with the idea
type PointSet2{T<:Number} <: G2dCompoundObject
    n::Int64
    points::Array{ Point{T}, 1}
end
function PointSet2{T<:Number}(x::Array{T,1}, y::Array{T,1})
    if (length(x) != length(y))
        error("vectors must be the same length")
    end
    if (eltype(x) != eltype(y))
        error("vectors must be made up of the same type")
    end
    n = length(x)
    points = Array{ Point{eltype(x)}, n}
    dump(points)
    for i=1:n
        points[i].x = x[i]
        points[i].y = y[i]
    end
    return  PointSet2(n, points)
end
