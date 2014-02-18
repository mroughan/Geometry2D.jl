# 
# An assortment of routines related to triangles
#
export Triangle
export TriangleRand, isin, bounded, bounds, area, perimeter, angles, displayPath, closed, distance

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
perimeter(t::Triangle) = distance(t.points[1],t.points[2]) + distance(t.points[2],t.points[3]) + distance(t.points[3],t.points[1]) 

bounds(t::Triangle) = Bounds(t.points)
function angles(t::Triangle)
    a = Array{Float,3}
    a[1] = angle( t.points[3], t.points[1], t.points[2]  )
    a[2] = angle( t.points[1], t.points[2], t.points[3]  )
    a[3] = angle( t.points[2], t.points[3], t.points[1]  )
end

# does the shape define an "inside" and "outside" of the plane
closed(::Triangle) = true

# distance from point to Triangle
function distance(p::Point, t::Triangle)
    n = 3

    # compute the distance to each vertex
    d = Array(Float64,n)
    for i=1:n
        d[i] = distance(p, t.points[i])
    end
    Id = indmin(d)

    # compute distance to each edge, and take the smallest
    s = Array(Float64,n)
    p = PointArray(3)
    for i=1:n
      s[i],p[i] = distance(p, Segment(t.points[i],t.points[mod1(i+1,n)]) )  
    end
    Is = indmin(s)

    # take the smallest one
    if d[Id] <= s[Is]
        return d[Id], t.points[Id]
    else
        return s[Is], p[Is]
    end
end

# function for plotting
displayPath(t::Triangle) = [t.points, t.points[1]]
displayPoints(t::Triangle) = [t.points]

