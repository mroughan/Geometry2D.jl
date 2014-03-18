# 
# An assortment of routines related to triangles
#
export Triangle
export isin, bounded, bounds, area, perimeter, angles, displayPath, closed, distance, centroid, incircumcircle

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
Triangle{T<:Number}(p1::Point{T}, p2::Point{T}, p3::Point{T}) = Triangle( [p1,p2,p3] )
 
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
function incircumcircle(p::Point, t::Triangle; tolerance=1.0e-12)
    A = [[t.points[1].x t.points[1].y distance2(t.points[1]) 1.0],
         [t.points[2].x t.points[2].y distance2(t.points[2]) 1.0],
         [t.points[3].x t.points[3].y distance2(t.points[3]) 1.0],
         [p.x           p.y           distance2(p) 1.0]
         ]
    return det(A) > 0
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
centroid(t::Triangle) = (t.points[1] + t.points[2] + t.points[3])/3.0

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

    if isin(p,t)[1]
        return 0,p
    end

    # compute distance to each edge, and take the smallest
    s = Array(Float64,n)
    ps = PointArray(n)
    for i=1:n
      s[i],ps[i] = distance(p, Segment(t.points[i],t.points[mod1(i+1,n)]) )  
    end
    Is = indmin(s)
    return  s[Is], ps[Is]
end

# function for plotting
displayPath(t::Triangle) = [t.points, t.points[1]]
displayPoints(t::Triangle) = [t.points]

