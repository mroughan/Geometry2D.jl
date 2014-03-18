# 
# An assortment of routines related to polygons
#
export Polygon, ComplexPolygon
export PolygonType, ConvexPoly, ConcavePoly, SimplePoly, AlmostSimplePoly, ComplexPoly
export PolygonRegular, Pentagon, Hexagon, Octagon, PolygonStar, PolygonSimpleStar, Pentagram, Octogram
export isin, bounded, bounds, area, perimeter, displayPath, closed, isregular, isconvex, issimple, closepoly, length,  nearvertex, copy, simplify, centroid, distance, edge, average
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
                return new(ConvexPoly, points)
            elseif c==-1
                return new(ConvexPoly, flipud(points))
            else
                error("points entered don't form a convex polygon")
            end 
        elseif class == SimplePoly
            # check its simple
            if issimple(points)
                return new(SimplePoly, points)
            else
                error("points entered don't form a simple polygon")
            end
        elseif class == AlmostSimplePoly 
            # really need a proper check here
            return new(AlmostSimplePoly, points) 
        elseif class == Concave
            error("please give the specific type of concave polygon: SimplePoly, AlmostSimple, or complex as seprarate object")
        else
            error("unsupported polygon class (NB: complex polygons should be type ComplexPoly)")
        end
    end
end

#####################################3
# constructors
Polygon{T<:Number}(class::DataType, points::Vector{Point{T}}) = Polygon{T}(class::DataType, points::Vector{Point{T}})
function Polygon{T<:Number}(points::Vector{Point{T}})
    # this constructor works out the correct class
    if (length(points) < 3)
        error("polygons must have at least three vertices")
    end
     
    # make sure the points are closed, i.e., first point equals the last
    points = closepoly(points)
    
    if isconvex(points) != 0
        return Polygon{T}(ConvexPoly, points)
    elseif issimple(points)
        return Polygon{T}(SimplePoly, points)
    else 
        return Polygon{T}(AlmostSimplePoly, points)
    end
end
# NB: Array{Point{T<:Number},1} isn't a supertype of Array{Point{Float64},1} 
#   so we need a constructor here for when an abstract Array{Point} is passed in
#   and here we are just converting them into floating point, though perhaps there is a better approach
Polygon(points::Vector{Point}) = Polygon( convert(Array{Point{Float64}, 1}, points) )
Polygon{T<:Number,S<:Number}(x::Vector{T}, y::Vector{S}) = Polygon(PointArray(x,y))
copy{T<:Number}(p::Polygon{T}) = Polygon( copy(p.points) )
Polygon(b::Bounds) = Polygon([b.left, b.right, b.right, b.left], [b.bottom, b.bottom, b.top, b.top])
Polygon(t::Triangle) = Polygon(t.points)
convert{T<:Number}(::Type{Polygon}, b::Bounds{T}) = Polygon(b)
convert{T<:Number}(::Type{Polygon}, t::Triangle{T}) = Polygon(t)

# make sure it is closed, i.e., first point equals the last
function closepoly{T<:Number}( points::Vector{Point{T}}; tolerance=1.0e-12 )
    if distance2(points[1], points[end]) < tolerance
        return points
    else
        return [points, points[1]]
    end
end

# create a simple polygon from an almost simple one
function simplify(poly::Polygon; tolerance=1.0e-12)
    # look for all the intersection points, which should include vertices

    # classify the intersection points as internal, or on the edge

    # rebuild the polygon around the edge points
    #    getting the order right is tricky
    

end

# generate certain types of polygon
function PolygonRegular(n::Integer; scale=1, center=originF, theta0=0)
    # n is the number of vertices
    if n<3
        error("a regular polygon must have at least 3 vertices")
    end
    theta = theta0 + [0:n-1]*2.0*pi/n
    x = center.x + scale*cos(theta)
    y = center.y + scale*sin(theta)
    return Polygon(x,y)
end
Pentagon(; scale=1, center=originF, theta0=0) = PolygonRegular(5; scale=scale, center=center, theta0=theta0)
Hexagon(; scale=1, center=originF, theta0=0) = PolygonRegular(6; scale=scale, center=center, theta0=theta0)
Octagon(; scale=1, center=originF, theta0=0) = PolygonRegular(8; scale=scale, center=center, theta0=theta0)

function PolygonStar(n::Integer, m::Integer; scale=1, center=originF, theta0=0)
    # generate a star polygon with Schlafli symbol (n/m), where n specifies the number of outer
    # vertices, and m-1 specifies the number of skipped vertices between each adjacent vertex
    #    http://en.wikipedia.org/wiki/Star_polygon
    #    http://en.wikipedia.org/wiki/Schl%C3%A4fli_symbol
    #    http://en.wikipedia.org/wiki/List_of_regular_polytopes#Two-dimensional_regular_polytopes
    # see also  "Stellation", e.g., http://en.wikipedia.org/wiki/Stellation
    if n<3
        error("a regular polygon must have at least 3 vertices")
    end

    # note that n/m star is the same as n/(n-m), so always use smaller M
    if m > n/2
        m = n-m
    end
    r = gcd(n,m) # number of unconnected (n/r) / (m/r) polygons
    N = int(n/r)
    M = int(m/r)

    # calculate the internal angles
    int_angle = pi*(n-2*m)/n

    # angles WRT to origin of each point
    theta = theta0 + [0:n-1]*2.0*pi/n
    x = center.x + scale*cos(theta)
    y = center.y + scale*sin(theta)
    P = Array(Polygon, r)
    for i=1:r 
        ind = Array(Int64, N)
        for j=1:N
            ind[j] = mod1(i + (j-1)*m, n)
        end
        tmpx = x[ind] 
        tmpy = y[ind]
        P[i] = Polygon(tmpx, tmpy)
    end
    return P
end
Pentagram(; scale=1, center=originF, theta0=0) = PolygonStar(5,2;scale=scale, center=center, theta0=theta0)
Octogram(; scale=1, center=originF, theta0=0) = PolygonStar(8,3;scale=scale, center=center, theta0=theta0)

function PolygonSimpleStar(n::Integer, m::Integer; scale=1, center=originF, theta0=0)
    # simplified version of the stars created in StarPolygon

    # create a set of star polygons (but these are complex)
    star = PolygonStar(n, m; scale=scale, center=center, theta0=theta0)
    r = length(star)
    N = int(n/r)

#    println(" n=$n, m=$m, r=$r, N=$N")

    # find intersections between pairs of edges
    pu = []
    for i=1:r
        star1 = star[i].points
        for j=i:r
            star2 = star[j].points
            for k=1:N
                for l=1:N
                    if i==j && k==l
                        # don't compare a line segment with itself
                    else
                        # println("  i=$i, j=$j, k=$k, l=$l, $(length(star1)), $(length(star2))") 
                        # dump(star1)
                        # dump(star2)

                        s1 = edge(star[i], k) 
                        s2 = edge(star[j], l)
                        I,pI = intersection(s1, s2)
                        if I==1
                            pu = [pu,pI]
                        end
                    end
                end
            end
        end
    end

    # the following code snippetsegfaults ????
    # d = distance2(center, points)
    # println("d = $d")
    # dump(d)
    # maxd = maximum(d) 
    # maxd2 = maximum( d[ d .< maxd - 1.0e-6 ] )
    # k = d .> maxd2 - 1.0e-6
    # points = points[k]
 
    # take the outmost points, and the next level as well
    points = unique(pu)
    maxd = 0.0
    for i=1:length(points)
        d = distance2(points[i], center)
        if d > maxd
            maxd = d
        end
    end
    maxd2 = 0.0
    for i=1:length(points)
        d = distance2(points[i], center)
        if d > maxd2 && d < maxd-1.0e-6
            maxd2 = d
        end
    end
    d = distance2(center, points)
    k = d .> maxd2 - 1.0e-6
    points = points[k]

    a = angle(points, center)
    k = sortperm(a)
    points = points[k]

    # only include the outermost intersections

    # sort their vertices, and intersections in angular order

    # create a polygon from the result

    return Polygon(points)
end

###########################################################
#   tests

# check if a set of vertices forms a convex polygon
function isconvex{T<:Number}( points::Vector{Point{T}}; tolerance=1.0e-12  ) 
    # points could be in clockwise or counter-clockwise order
    # return -1 for clockwise, 1 for counter-clockwise, and 0 if not convex
    # assumes the 1st point = the last point
    # it doesn't currently allow colinear points as this is slightly tricky
    if !issimple(points)
        return 0
    end

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
isconvex(poly::Polygon) = isconvex(poly.points) # could interogate the class, but I use this for debugging

# check if a set of vertices forms a simple polygon
function issimple{T<:Number}( points::Vector{Point{T}}; tolerance=1.0e-12  )
    # see if any pair of vertices intersect
    n = length(points)-1
    for i=1:n-1
        for j=i+1:n
            # println("   i=$i, j=$j, isequal=$(isequal(points[i],points[j]))")
            if isequal(points[i],points[j])
                return false
            end
        end
    end
    # see if adjacent edges overlap
    for i=1:n-1
        I,E = intersection( Segment(points[i],points[i+1]), Segment(points[i+1],points[i+2]) )
        # println("   i=$i, i+1=$(i+1), overlap=$I")
        if I==2
            return false
        end
    end
    # see if any pair of (non-adjacent) edges intersect
    for i=1:n-1
        for j=i+2:n
            if (i==1 && j==n)
                # this is another adjacent case
            else
                I,E = intersection( Segment(points[i],points[i+1]), Segment(points[j],points[j+1]) )
                # println("   i=$i, j=$j, I=$I")
                if I>0
                    return false
                end
            end
        end
    end   
    return true
end
issimple(poly::Polygon) = issimple(poly.points) # could interogate the class, but I use this for debugging

function isregular(poly::Polygon; tolerance=1.0e-12 )
    # at the moment just checking that all the internal angles are the same -- is this enough?
    a = angles(poly)
    n = length(poly)
    for i=1:n
        if abs(a[1] - [i]) > tolerance
            return false
        end
    end
    return true
end

function nearvertex(p::Point, poly::Polygon; tolerance=1.0e-12)
    n = length(poly)
    for i=1:n
        if distance2(p, poly.points[i]) < tolerance
            return true
        end
    end
    return false 
end

# isin using a couple of different approaches
function isin(p::Point, poly::Polygon; test="winding", tolerance=1.0e-12)
    # use winding numbers I think, as its easier to deal with points near vertices
    n = length(poly)

    # check if we are on the boundary
    for i=1:n
        I,E = isin(p, edge(poly, i); tolerance=tolerance)
        if I
            return true, true
        end
    end 

    # if not on the boundary do the test
    if test=="winding"
        if abs(windingNumber(p, poly; tolerance=tolerance)) > 0
            return true, false
        end
    # elseif test=="scanline"
    #     if isodd(scanLineNumber(translate(poly, -p); tolerance=tolerance))
    #         return true, false
    #     end
    else 
        error("only test defined is the 'winding' number")
    end

    return false, false
end

# see for instance: http://geomalgorithms.com/a03-_inclusion.html
function windingNumber(p::Point, poly::Polygon; tolerance=1.0e-12)
    n = length(poly)

    # quick check
    I,E = isin(p, bounds(poly))
    if !I
        return 0
    end

    R = Ray(p, Vect(1,0)) # horizontal ray from the point

    # check the last edge for intersection to correctly set its direction
    S = edge(poly, n) 
    I,pi = intersection( S, R ; tolerance=tolerance )
    if I==1 && pi.x > p.x
        if     poly.points[n+1].y > poly.points[n].y + tolerance
            direction = 1
        elseif poly.points[n+1].y < poly.points[n].y - tolerance
            direction = -1
        else
            direction = 0
        end 
    else
        direction = 0
    end
    
    # count the number of upward - downwards transitions into Q1
    count = 0
    for i=1:n
        S = edge(poly, i) 
        I,pi = intersection( S, R ; tolerance=tolerance )
        if I==1 && pi.x > p.x
            if     poly.points[i+1].y > poly.points[i].y + tolerance && direction != 1
                direction = 1
            elseif poly.points[i+1].y < poly.points[i].y - tolerance && direction != -1
                direction = -1
            else
                direction = 0
            end 
            count += direction
        else
            direction = 0
        end
    end

    return count
end


# function scanLineNumber(poly::Polygon; tolerance=1.0e-12)
#     # assumes we translated the polygon, so the point of interest is the origin
#     #    need to be careful about vertices as these cases are different
#     # 
#     #          \                 /\
#     #           \               /  \
#     #           /              /    \
#     #          /             count as 2
#     #     count as 1          
#     count = 0
#     error("no implemented yet")
#     return count
# end



###########################################################
#   useful functions

edge(poly, i) = Segment(poly.points[i], poly.points[i+1])
length(poly::Polygon) = length(poly.points) - 1
bounded(poly::Polygon) = true
function area(poly::Polygon)
    # http://mathworld.wolfram.com/PolygonArea.html
    # note that this will return a positive value if the points are in 
    #   counter-clockwise order, and negative otherwise
    #   all convex polys should be in ccw order, so that's easy
    if poly.class == ConvexPoly || poly.class == SimplePoly
        result = 0
        n = length(poly)
        for i=1:n
            A = [[poly.points[i].x poly.points[i+1].x], [poly.points[i].y poly.points[i+1].y]]
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
        n = length(poly)
        for i=1:n
            result += distance(poly.points[i], poly.points[i+1])
        end
        return result
    else
        error("can't currently calculate perimeter of non-simple polygons")
    end 
end
function centroid(poly::Polygon)
    if poly.class == ConvexPoly || poly.class == SimplePoly
        area = 0.0
        p = Point(0.0,0.0)
        n = length(poly)
        for i=1:n
            A = [[poly.points[i].x poly.points[i+1].x], [poly.points[i].y poly.points[i+1].y]]
            a = det(A) 
            area += a/2.0
            p += a * Point((poly.points[i].x + poly.points[i+1].x),
                           (poly.points[i].y + poly.points[i+1].y) )
        end
        return p/(6.0*area)
    else
        error("can't currently calculate centroid of non-simple polygons")
        # could exploit decomposition
        #   centroid(X) = weightedcentroid(  centroids(x_i) )
        # http://en.wikipedia.org/wiki/Centroid
    end 
end 

# averaging as in the sense of
#   "FROM RANDOM POLYGON TO ELLIPSE: AN EIGENANALYSIS"
#    ADAM N. ELMACHTOUB AND CHARLES F. VAN LOAN
#    www.cs.cornell.edu/cv/ResearchPDF/PolygonSmoothingPaper.pdf
function average{T<:Number}(poly::Polygon{T})
    n = length(poly)
    c = mean(poly.points[1:n])
    p = similar(poly.points, n)
    for i=1:n
        p[i] = (poly.points[i]+poly.points[i+1]) / (2*one(T)) - c
    end
    xnorm = sqrt( sum( points_x( p ).^2 ) )
    ynorm = sqrt( sum( points_y( p ).^2 ) )
    for i=1:n
        p[i] = Point( p[i].x/xnorm, p[i].y/ynorm )
    end
    return Polygon(p+c)
end

# internal angles of the polygon
function angles(poly::Polygon)
    n = length(poly)
    a = Array(Float64,n)
    for i=1:n
        a[i] = angle( poly.points[mod1(i-1,n)], poly.points[i], poly.points[mod1(i+1,n)]  )
    end
    return a
end

bounds(poly::Polygon) = Bounds(poly.points)

# distance from point to Polygon
#    should be possible to do this faster for a big convex polygon, by searching
function distance(p::Point, poly::Polygon)
    n = length(poly)

    if isin(p,poly)[1]
        return 0,p
    end

    # compute distance to each edge, and take the smallest
    s = Array(Float64,n)
    ps = PointArray(n)
    for i=1:n
      s[i],ps[i] = distance(p, edge(poly, i) )  
    end
    Is = indmin(s)
    return  s[Is], ps[Is]
end

# does the shape define an "inside" and "outside" of the plane
closed(::Polygon) = true

# function for plotting
displayPath(poly::Polygon) = [poly.points]
displayPoints(poly::Polygon) = [poly.points[1:end-1]]

