# 
# An assortment of routines related to triangles
#
export Triangle
export TriangleRand, isin, bounded, bounds, area, displayPath

immutable Triangle{T<:Number} <:  G2dCompoundObject
    points::Vector{Point{T}}

    function Triangle(points::Vector{Point{T}})
        if (length(points) != 3)
            error(" triangles have three vertices")
        end
        c = ccw(points)
        if c>0
            return new(points)
        elseif c<0
            return new(flipud(points))
        else
            error("points appear to be colinear")
        end 
    end
end
Triangle{T<:Number}(points::Vector{Point{T}}) = Triangle{T}(points)
function Triangle{T<:Number}(x::Vector{T}, y::Vector{T})
    if length(x) != 3
        error("x should have 3 elements")
    end
    if length(y) != 3
        error("y should have 3 elements")
    end
    return Triangle(PointArray(x, y))
end
Triangle{T<:Number, S<:Number}(x::Vector{T}, y::Vector{S}) = Triangle(promote(x,y)...)
Triangle() = PointArray(3)
TriangleRand(n::Integer) = Triangle(rand(3,1), rand(3,1))

# promotion/conversion functions

# utilities
bounded(t::Triangle) = true
function isin(p::Point, t::Triangle; tolerance=1.0e-12)
    # points on the triangle should always be in CCW direction, 
    # so just need to check p_{i},p_{i+1},p are in CCW order
    c1 = ccw(t.points[1],t.points[2],p)
    c2 = ccw(t.points[2],t.points[3],p)
    c3 = ccw(t.points[3],t.points[1],p)

    if c1>tolerance && c2>tolerance && c3>tolerance
        return true, false
    elseif c1>=-tolerance && c2>=-tolerance && c3>=-tolerance
        return true, true
    else
        return false, false
    end
end
function area(t::Triangle)
    a = t.points[1]
    b = t.points[2]
    c = t.points[3]
    
    return ( a.x*b.y - a.y*b.x
            + a.y*c.x - a.x*c.y
            + b.x*c.y - b.y*c.x
            ) / 2.0
end
bounds(t::Triangle) = Bounds(t.points)

# function for plotting
displayPath(t::Triangle) = [t.points, t.points[1]]

