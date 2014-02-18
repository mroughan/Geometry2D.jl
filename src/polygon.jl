# 
# An assortment of routines related to polygons
#
export Polygon, ComplexPolygon
export PolygonType, ConvexPoly, ConcavePoly, SimplePoly, AlmostSimplePoly, ComplexPoly
export PolygonRand, isin, bounded, bounds, area, perimeter, displayPath, closed, isregular, isconvex, issimple, closepoly

abstract ComplexPolygon <: G2dCompoundObject
# we need a second type for this (as yet unimplemented) as it can have multiple curves

abstract PolygonType
abstract ConvexPoly <: PolygonType
abstract ConcavePoly <: PolygonType
abstract SimplePoly <: ConcavePoly
abstract AlmostSimplePoly <: ConcavePoly
abstract ComplexPoly <: ConcavePoly

type Polygon{T<:Number} <:  G2dCompoundObject
    class::DataType # NB: this is set and checked at the start, but could break if polygon changes
    points::Vector{Point{T}}

    function Polygon(class::DataType, points::Vector{Point{T}})
        if (length(points) < 3)
            error("polygons must have at least three vertices")
        end

        # make sure the points are closed, i.e., first point equals the last
        points = closepoly(points)

        # classification specific processing
        if class <: ConvexPoly
            # check its convex, and make sure points are stored in counter-clockwise order
            c = isconvex(points)
            if c==1
                return new(Convex, points)
            elseif c==-1
                return new(Convex, flipud(points))
            else
                error("points entered don't form a convex polygon")
            end 
        elseif class == SimplePoly
            # check its simple
            if issimple(points)
                return new(Simple, points)
            else
                error("points entered don't form a simple polygon")
            end
        elseif class == AlmostSimplePoly 
            # really need a proper check here
            return new(AlmostSimple, points)
        elseif class == Concave
            error("please give the specific type of concave polygon: SimplePoly, AlmostSimple, or complex as seprarate object")
        else
            error("unsupported polygon class (NB: complex polygons should be type ComplexPoly)")
        end
    end
end
Polygon{T <: Number}(class::DataType, points::Vector{Point{T}}) = Polygon{T}(class::DataType, points::Vector{Point{T}})
function Polygon{T <: Number}(points::Vector{Point{T}})
    # this constructor works out the correct class
    if (length(points) < 3)
        error("polygons must have at least three vertices")
    end
    
    # make sure the points are closed, i.e., first point equals the last
    points = closepoly(points)
    
    if isconvex(points)
        return Polygon(ConvexPoly, points)
    elseif issimple(points)
        return Polygon(SimplePoly, points)
    else 
        return Polygon(AlmostSimplePoly, points)
    end
end

# make sure it is closed, i.e., first point equals the last
function closepoly( points::Vector{Point}; tolerance=1.0e-12 )
    if distance2(points[1], points[end]) < tolerance
        return points
    else
        return [points, points[1]]
    end
end

# check if a set of vertices forms a convex polygon
function isconvex( points::Vector{Point}; tolerance=1.0e-12  ) 
    # points could be in clockwise or counter-clockwise order
    # return -1 for clockwise, 1 for counter-clockwise, and 0 if not convex
    # assumes the 1st point = the last point
    # it doesn't currently allow colinear points as this is slightly tricky
    n = length(points)
    direction = int(sign(ccw( points[1], points[2], points[3] )))
    for i=2:n-1
        c = int(sign(ccw( points[i], points[i+1], points[mod1(i+2,n-1)] )))
        if direction*c < 0
            return 0
        end
    end
    return direction
end

# check if a set of vertices forms a simple polygon
function issimple( points::Vector{Point}; tolerance=1.0e-12  )
    # see if any pair of vertices intersect
    n = length(points)-1
    for i=1:n-1
        for j=i+1:n
            if isequal(points[i],points[j])
                return false
            end
        end
    end
    # see if any pair of edges intersect
     for i=1:n-1
        for j=i+1:n
            I,E = intersection( Segment(points[i],points[i+1]), Segment(points[j],points[j+1]) )
            if I>0
                return false
            end
        end
    end   
    return true
end

# utilities
bounded(poly::Polygon) = true
function isin(p::Point, poly::Polygon; tolerance=1.0e-12)
    # use winding numbers I think, as its easier to deal with points near vertices
    n = length(points)-1
    if poly.class == ConvexPoly

    elseif poly.class == SimplePoly

    else 
        error("can't currently calculate isin for non-simple polygons, as I haven't decided which meaning for it to have")
    end 
end
function area(poly::Polygon)
    # http://mathworld.wolfram.com/PolygonArea.html
    # note that this will return a positive value if the points are in 
    # counter-clockwise order, and negative otherwise
    #   all convex polys should be in ccw order, so that's easy
    if poly.class == ConvexPoly || poly.class == SimplePoly
        result = 0
        n = length(points)-1
        for i=1:n
            A = [[poly.points[i].x poly.points[i+1].y],[poly.points[i].y poly.points[i+1].y]]
            result += det(A)
        end
        return result/2
    else
        error("can't currently calculate areas of non-simple polygons")
    end 
end
function perimeter(poly::Polygon)
    if poly.class == ConvexPoly || poly.class == SimplePoly
        result = 0
        n = length(points)-1
        for i=1:n
            result += distance(poly.points[i],poly.points[i+1])
        end
        return result
    else
        error("can't currently calculate perimeter of non-simple polygons")
    end 
end
function angles(poly::Polygon)
    if poly.class == ConvexPoly     
        n = length(points)-1
        a = Array{Float,n}
        for i=1:n
            a[i] = angle( points[mod1(i-1,n)], points[i], points[mod1(i+1,n)]  )
        end
        return a
    else
        error("might not give sensible results for non-convex polygons")
    end
end

bounds(poly::Polygon) = Bounds(poly.points)

# does the shape define an "inside" and "outside" of the plane
closed(::Polygon) = true

# function for plotting
displayPath(poly::Polygon) = [poly.points]
displayPoints(poly::Polygon) = [poly.points[1:end-1]]

