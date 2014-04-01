
export Line, Ray, Segment, LINETYPE
 
export slope, invslope, yint, xint, isequal, isparallel,  isin, displayPath, bounded, bounds, closed, area, perimeter, convert, flip, distance, length

# general representation of a line that avoids problems with infinite slope
#   at the cost of storing three values instead of just slope and intercept
immutable Line{T<:Number} <: G2dCompoundObject
    startpoint::Point{T} # an arbitrary point on the line
    theta::T        # the angle of the line to the x-axis, in radians [0,2 pi)

    # remember this creates inner constructer Line{T}     
    function Line(point::Point{T}, theta::T)
        if theta < -pi/2
            while theta < -pi/2
                theta += pi 
            end
        elseif theta > pi/2
            while theta > pi/2
                theta -= pi
            end
        end 
        return new(point, theta)
    end
end
Line{T<:Number}(point::Point{T}, theta::T) = Line{T}(point, theta)
Line{T<:Number, S<:Number}(point::Point{T}, theta::S) = Line(convert(Point{promote_type(T,S)}, point), convert(promote_type(T,S),theta) )
function Line{T<:Number, S<:Number}(yint::T, slope::S) 
    if ~isfinite(yint)
        error("y intercept must be finite")
    end
    if ~isfinite(slope)
        error("slope intercept must be finite")
    end
    return Line( Point(0,yint), atan(slope) )
end
function Line{T<:Number}(p1::Point{T}, p2::Point{T})
    tmp = p2 - p1
    slope = tmp.y/tmp.x
    return Line(p1, atan(slope))
end
Line{T<:Number, S<:Number}(p1::Point{T}, p2::Point{S}) = Line(promote(p1,p2)...)


immutable Ray{T<:Number} <: G2dCompoundObject
    startpoint::Point{T}
    direction::Vect{T}
end
Ray{T<:Number, S<:Number}(startpoint::Point{T}, direction::Vect{S}) = Ray(promote(startpoint, direction)...)


immutable Segment{T<:Number} <: G2dCompoundObject
    startpoint::Point{T}
    endpoint::Point{T}

    # remember this creates inner constructer Segment{T}
    function Segment(startpoint::Point{T},  endpoint::Point{T})
        # always have the points lexicographically sorted,
        #   which makes comparisons and slope calculations easier
        if startpoint.x < endpoint.x 
            return new(startpoint, endpoint)
        elseif startpoint.x > endpoint.x
            return new(endpoint, startpoint)
        elseif startpoint.y < endpoint.y
            return new(startpoint, endpoint)
        elseif startpoint.y > endpoint.y
            return new(endpoint, startpoint)           
        else 
            error("the two points must be distinct")
        end
   end
end
Segment{T<:Number}(startpoint::Point{T}, endpoint::Point{T}) = Segment{T}(promote(startpoint, endpoint)...)
Segment{T<:Number, S<:Number}(startpoint::Point{T}, endpoint::Point{S}) = Segment(promote(startpoint, endpoint)...)

# could have done this with an abstract type above the three, but wanted to try out Unions
LINETYPE = Union(Line, Ray, Segment)

# lots of alternate representations we could build constructors for
#    ray constructed using two points (with one as start), or point and a slope (and + or -)
#    segment constructed with point, and direction, and distance
#

# automated promotion and conversion rules
promote_rule{T<:Number,S<:Number}(::Type{Line{T}}, ::Type{Line{S}})  = Line{promote_type(T,S)}
promote_rule{T<:Number,S<:Number}(::Type{Ray{T}}, ::Type{Ray{S}})  = Ray{promote_type(T,S)}
promote_rule{T<:Number,S<:Number}(::Type{Segment{T}}, ::Type{Segment{S}})  = Segment{promote_type(T,S)}


# need some more here

copy(l::Line) = Line(l.startpoint, l.theta) 
copy(r::Ray) = Ray(r.startpoint, r.direction)
copy(s::Segment) = Segment(s.startpoint, s.endpoint)


# promote_rule{T<:Integer,S<:FloatingPoint}(::Type{Line{T}}, ::Type{Line{S}} ) = Line{S}
# promote_rule{T<:Integer}(::Type{Line{Rational{T}}}, ::Type{Line{T}}) = Line{Rational{T}}
# promote_rule{T<:Integer,S<:Integer}(::Type{Line{Rational{T}}}, ::Type{Line{S}}) = Line{Rational{promote_type(T,S)}}
# promote_rule{T<:Integer,S<:Integer}(::Type{Line{Rational{T}}}, ::Type{Line{Rational{S}}}) = Line{Rational{promote_type(T,S)}}
# promote_rule{T<:Integer,S<:FloatingPoint}(::Type{Line{Rational{T}}}, ::Type{Line{S}})  = Line{promote_type(T,S)}

# promote_rule{T<:Integer,S<:FloatingPoint}(::Type{Ray{T}}, ::Type{Ray{S}} ) = Ray{S}
# promote_rule{T<:Integer}(::Type{Ray{Rational{T}}}, ::Type{Ray{T}}) = Ray{Rational{T}}
# promote_rule{T<:Integer,S<:Integer}(::Type{Ray{Rational{T}}}, ::Type{Ray{S}}) = Ray{Rational{promote_type(T,S)}}
# promote_rule{T<:Integer,S<:Integer}(::Type{Ray{Rational{T}}}, ::Type{Ray{Rational{S}}}) = Ray{Rational{promote_type(T,S)}}
# promote_rule{T<:Integer,S<:FloatingPoint}(::Type{Ray{Rational{T}}}, ::Type{Ray{S}})  = Ray{promote_type(T,S)}

# promote_rule{T<:Integer,S<:FloatingPoint}(::Type{Segment{T}}, ::Type{Segment{S}} ) = Segment{S}
# promote_rule{T<:Integer}(::Type{Segment{Rational{T}}}, ::Type{Segment{T}}) = Segment{Rational{T}}
# promote_rule{T<:Integer,S<:Integer}(::Type{Segment{Rational{T}}}, ::Type{Segment{S}}) = Segment{Rational{promote_type(T,S)}}
# promote_rule{T<:Integer,S<:Integer}(::Type{Segment{Rational{T}}}, ::Type{Segment{Rational{S}}}) = Segment{Rational{promote_type(T,S)}}
# promote_rule{T<:Integer,S<:FloatingPoint}(::Type{Segment{Rational{T}}}, ::Type{Segment{S}})  = Segment{promote_type(T,S)}

# conversion of one type to another: note though that these loose information
convert{T<:Number}(::Type{Ray}, s::Segment{T}) = Ray(s.startpoint, s.endpoint-s.startpoint)
convert{T<:Number}(::Type{Line}, s::Segment{T}) = Line(s.startpoint, atan( (s.endpoint.y-s.startpoint.y)/(s.endpoint.x-s.startpoint.x) ) ) 
convert{T<:Number}(::Type{Line}, r::Ray{T}) = Line(r.startpoint, atan(r.direction.y / r.direction.x) )
# can't convert back the other way without providing extra information

convert(::Type{Segment{Float64}}, s::Segment) = Segment(convert(Point{Float64},s.startpoint), convert(Point{Float64},s.endpoint))
 
# useful functions
slope(l::Line) = ( tan(l.theta) )
slope(r::Ray) = ( r.direction.y / r.direction.x )
slope(s::Segment) = ( (s.endpoint.y-s.startpoint.y) / (s.endpoint.x-s.startpoint.x) )
invslope(l::Line) = ( cot(l.theta) )
invslope(r::Ray) = ( r.direction.x / r.direction.y )
invslope(s::Segment) = ( (s.endpoint.x-s.startpoint.x) / (s.endpoint.y-s.startpoint.y) )

xint(l::Line) = ( l.startpoint.x - l.startpoint.y * cot(l.theta) )
yint(l::Line) = ( l.startpoint.y - l.startpoint.x * tan(l.theta) )

bounded(::Line) = false
bounded(::Ray) = false
bounded(::Segment) = true
bounds(s::Segment) = Bounds(s.endpoint.y, s.startpoint.y, s.startpoint.x, s.endpoint.x)
bounds(::Line) = Bounds(Inf, Inf, Inf, Inf)
function bounds(r::Ray)
    if quadrant(direction)==1
        return Bounds(Inf,r.startpoint.y,r.startpoint.x,Inf) # top bottom left right
    elseif quadrant(direction)==2
        return Bounds(Inf,r.startpoint.y,-Inf,r.startpoint.x)
    elseif quadrant(direction)==3
        return Bounds(r.startpoint.y,-Inf,r.startpoint.x,Inf)
    elseif quadrant(direction)==4
        return Bounds(r.startpoint.y,-Inf,-Inf,r.startpoint.x)
    end
end

# does the shape define an "inside" and "outside" of the plane
closed(::Line) = false
closed(::Ray) = false
closed(::Segment) = false

# include area/perimeter functions for completeness
area(::Line) = 0
area(::Ray) = 0
area(::Segment) = 0
perimeter(::Line) = Inf
perimeter(::Ray) = Inf
perimeter(s::Segment) = distance( s.startpoint, s.endpoint )
length(s::Segment) = distance( s.startpoint, s.endpoint )

# comparisons
isequal(l1::Line, l2::Line) = ( l1.startpoint==l2.startpoint && l1.theta==l2.theta )
isequal(r1::Ray, r2::Ray) = ( r1.startpoint==r2.startpoint && r1.direction==r2.direction )
isequal(s1::Segment, s2::Segment) = ( s1.startpoint==s2.startpoint && s1.endpoint==s2.endpoint )

isparallel(l1::Line, l2::Line) = ( l1.theta == l2.theta )  
isparallel(r1::Ray, r2::Ray) = ( r1.direction == r2.direction )
isparallel(s1::Segment, s2::Segment) = ( slope(s1) == slope(s2) )

# distance returns the distance to the nearest point on the object, and that point
function distance(p::Point, line::Line)
    if abs( abs(line.theta) - pi/2 ) < tolerance
        # vertical line
        return abs(p.x - line.startpoint.x), Point(line.startpoint.x,p.y)
    elseif  abs(line.theta) < tolerance
        # horizontal line
        return abs(p.y - line.startpoint.y), Point(p.x,line.startpoint.y)
    end
    s1 = (p.x - line.startpoint.x) / cos(line.theta)
    s2 = (p.y - line.startpoint.y) / sin(line.theta)
    s = abs(s1 - s2)
    d = s*cos(line.theta)*sin(line.theta)
    if (s1 <= s2)
        ss = s1 + s*sin(line.theta)*sin(line.theta)
    else
        ss = s2 + s*cos(line.theta)*cos(line.theta)        
    end
    ps = line.startpoint + ss*Point(cos(line.theta), sin(line.theta))
    return abs(d), ps  # should check why I need to get abs distances?
end
distance2(p::Point, line::Line) = distance(p, line)[1]^2 # this isn't more efficient, but to be consistent with point distances

function distance(p::Point, r::Ray)
    if acute( r.startpoint+r.direction, r.startpoint, p) > 0
        # distance from p to equivalent line
        return distance(p, convert(Line, r))
    else
        # distance from p to the startpoint of the ray
        d = distance(p, r.startpoint)
        return d, r.startpoint
    end
end
distance2(p::Point, r::Ray) = distance(p, r::Ray)[1]^2 # this isn't more efficient, but to be consistent with point distances

function distance(p::Point, s::Segment)
    a1 = acute( p, s.startpoint, s.endpoint)
    a2 = acute( p, s.endpoint, s.startpoint)
    if a1 > 0 && a2 > 0
        # distance from p to equivalent line
        return distance(p, convert(Line, s))
    elseif a1 >= 0
        d = distance(p, s.endpoint)
        return d, s.endpoint
    elseif a2 >= 0
        d = distance(p, s.startpoint)
        return d, s.startpoint
    else
        error("something went wrong here: angles are $a1, and $a2, input point is $p, segment is $s")
    end
end
distance2(p::Point, s::Segment) = distance(p, s::Segment)[1]^2 # this isn't more efficient, but to be consistent with point distances

# inclusion tests: return true if a point is on a Line, Ray or Segment, repectively
#     tolerance specifies a distance from the object that is allowed
#     the second return value means the point is on the "edge", but the edge here
#        means a bounding points, e.g., the startpoint of a Ray, or the end-points of a Segment
#        maybe not mathematically sound, but this way is useful
function isin(p::Point, line::Line; tolerance=1.0e-12)
    return distance2(p,line) < tolerance, false
end

function isin(p::Point, r::Ray; tolerance=1.0e-12)
    return distance2(p,r) < tolerance, distance2(p,r.startpoint) < tolerance
end

function isin(p::Point, s::Segment; tolerance=1.0e-12)
    if distance2(p, s.startpoint)<tolerance
        return true, true
    elseif distance2(p, s.endpoint)<tolerance
        return true, true
    end
    return distance2(p,s) < tolerance, false
end
 
# function for plotting
function displayPath(line::Line; bounds=default_bounds) 
    # create bounding lines
    p1 = Point(bounds.left, bounds.bottom)
    p2 = Point(bounds.right, bounds.top)
    l1 = Line(p1, 0)
    l2 = Line(p1, pi/2)
    l3 = Line(p2, 0)
    l4 = Line(p2, -pi/2)

    # find intersections
    i1,p1 = intersection(line, l1)
    i2,p2 = intersection(line, l2)
    i3,p3 = intersection(line, l3)
    i4,p4 = intersection(line, l4)
 
    # if the line is parallel to a boundary
    if i1==2
        return [p1, Point(bounds.right, bounds.bottom)]
    elseif i2==2
        return [p1, Point(bounds.left, bounds.top)]
    elseif i3==2
        return [p2, Point(bounds.left, bounds.top)]
    elseif i4==2
        return [p3, Point(bounds.right, bounds.bottom)]
    end

    # if it intersects, then return the intersection points
    # choose the two points that are in the bounding rectangle
    P = []
    if i1==1 && isin(p1, bounds)[1]
        P = [P, p1]
    end
    if i2==1 && isin(p2, bounds)[1]
        P = [P, p2]
    end
    if i3==1 && isin(p3, bounds)[1]
        P = [P, p3]
    end
    if i4==1 && isin(p4, bounds)[1]
        P = [P, p4]
    end
    return unique(P) # doesn't eliminate all possible redundant points because of roundoff errors
end

function displayPoints(r::Ray; bounds=default_bounds)
    if isin(r.startpoint, bounds)[1]
        return [r.startpoint]
    else
        return []
    end
end
function displayPath(r::Ray; bounds=default_bounds) 
    in, edge = isin(r.startpoint, bounds)
    if in && !edge
        # the startpoint is inside the box, so only draw half a line
        P = [r.startpoint, r.startpoint+r.direction]
        
        # NEEDS intersection of ray and line routine
        #   will defer this until we can intersect a polygon and Line or Ray
        #   at which point we just construct quadrilateral polygon for intersections
 
        return  P
    elseif edge
        # startpoint is on the edge, so check if we are pointed in or out
        in2,edge2 = isin(r.startpoint + 1.0e-6*r.direction, bounds) # prolly should do this with angle test
        if in2
            displayPath(convert(Line, r); bounds=bounds) 
        else
            return r.startpoint
        end
    else
        # this is just the line drawing problem
        return displayPath(convert(Line, r); bounds=bounds) 
    end
end
 
displayPoints(s::Segment) = [s.startpoint, s.endpoint]
displayPath(s::Segment) = [s.startpoint, s.endpoint]


