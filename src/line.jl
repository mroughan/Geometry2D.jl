
export Line, Ray, Segment

export slope, invslope, yint, xint, isequal, isparallel, intersection, isin, SegmentRand, displayPath

# general representation of a line that avoids problems with infinite slope
#   at the cost of storing three values instead of just slope and intercept
immutable Line{T<:Number} <: G2dCompoundObject
    point::Point{T} # an arbitrary point on the line
    theta::T        # the angle of the line to the x-axis, in radians [0,2 pi)

    function Line(point::Point{T}, theta::T)
        if theta<-pi/2 || theta>pi/2
            error("theta must be the angle of the line to the x-axis, in radians [pi/2, -pi/2]")
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

    # rememeber this creates inner constructer Segment{T}
    function Segment(startpoint,  endpoint)
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
SegmentRand() = Segment(Point(rand(),rand()), Point(rand(),rand()))

# lots of alternate representations we could build constructors for
#    ray constructed using two points (with one as start), or point and a slope (and + or -)
#    segment constructed with point, and direction, and distance
#

# automated promotion rules for Lines
promote_rule{T<:Integer,S<:FloatingPoint}(::Type{Line{T}}, ::Type{Line{S}} ) = Line{S}
promote_rule{T<:Integer}(::Type{Line{Rational{T}}}, ::Type{Line{T}}) = Line{Rational{T}}
promote_rule{T<:Integer,S<:Integer}(::Type{Line{Rational{T}}}, ::Type{Line{S}}) = Line{Rational{promote_type(T,S)}}
promote_rule{T<:Integer,S<:Integer}(::Type{Line{Rational{T}}}, ::Type{Line{Rational{S}}}) = Line{Rational{promote_type(T,S)}}
promote_rule{T<:Integer,S<:FloatingPoint}(::Type{Line{Rational{T}}}, ::Type{Line{S}})  = Line{promote_type(T,S)}

# automated promotion rules for Rays
promote_rule{T<:Integer,S<:FloatingPoint}(::Type{Ray{T}}, ::Type{Ray{S}} ) = Ray{S}
promote_rule{T<:Integer}(::Type{Ray{Rational{T}}}, ::Type{Ray{T}}) = Ray{Rational{T}}
promote_rule{T<:Integer,S<:Integer}(::Type{Ray{Rational{T}}}, ::Type{Ray{S}}) = Ray{Rational{promote_type(T,S)}}
promote_rule{T<:Integer,S<:Integer}(::Type{Ray{Rational{T}}}, ::Type{Ray{Rational{S}}}) = Ray{Rational{promote_type(T,S)}}
promote_rule{T<:Integer,S<:FloatingPoint}(::Type{Ray{Rational{T}}}, ::Type{Ray{S}})  = Ray{promote_type(T,S)}

# automated promotion rules for Segments
promote_rule{T<:Integer,S<:FloatingPoint}(::Type{Segment{T}}, ::Type{Segment{S}} ) = Segment{S}
promote_rule{T<:Integer}(::Type{Segment{Rational{T}}}, ::Type{Segment{T}}) = Segment{Rational{T}}
promote_rule{T<:Integer,S<:Integer}(::Type{Segment{Rational{T}}}, ::Type{Segment{S}}) = Segment{Rational{promote_type(T,S)}}
promote_rule{T<:Integer,S<:Integer}(::Type{Segment{Rational{T}}}, ::Type{Segment{Rational{S}}}) = Segment{Rational{promote_type(T,S)}}
promote_rule{T<:Integer,S<:FloatingPoint}(::Type{Segment{Rational{T}}}, ::Type{Segment{S}})  = Segment{promote_type(T,S)}

# useful functions
slope(p::Line) = ( tan(p.theta) )
slope(p::Ray) = ( p.direction.y / p.direction.x )
slope(p::Segment) = ( (p.endpoint.y-p.startpoint.y) / (p.endpoint.x-p.startpoint.x) )
invslope(p::Line) = ( cot(p.theta) )
invslope(p::Ray) = ( p.direction.x / p.direction.y )
invslope(p::Segment) = ( (p.endpoint.x-p.startpoint.x) / (p.endpoint.y-p.startpoint.y) )

xint(p::Line) = ( p.point.x - p.point.y * cot(p.theta) )
yint(p::Line) = ( p.point.y - p.point.x * tan(p.theta) )

bounded(p::Line) = false
bounded(p::Ray) = false
bounded(p::Segment) = true

# comparisons
isequal(p1::Line, p2::Line) = ( p1.point==p2.point && p1.theta==p2.theta )
isequal(p1::Ray, p2::Ray) = ( p1.startpoint==p2.startpoint && p1.direction==p2.direction )
isequal(p1::Segment, p2::Segment) = ( p1.startpoint==p2.startpoint && p1.endpoint==p2.endpoint )

isparallel(p1::Line, p2::Line) = ( p1.theta == p2.theta )  
isparallel(p1::Ray, p2::Ray) = ( p1.direction == p2.direction )
isparallel(p1::Segment, p2::Segment) = ( slope(p1) == slope(p2) )

# inclusion tests: return true if a point is on a Line, Ray or Segment, repectively
#     not that tolerance specifies a distance from the object that is allowed
#     for bounded cases (Ray or Segment) the parameter "closed" allows you to specify whether
#         you want the closed set (including boundary) or the open set (not including it)
#         this is confusing in conjunction with tolerance which effectively makes the boundary have a width
function isin(p::Point, line::Line; tolerance=1.0e-12, closed=true)
    r = 1
    if (abs(line.theta) <= pi/4)
        y = yint(line) + p.x * slope(line)
        r = p.y - y
    else
        x = xint(line) + p.y * invslope(line)
        r = p.x - x
    end
    return abs(r) < tolerance
end

function isin(p::Point, r::Ray; tolerance=1.0e-12, closed=true)
    error("not implemented yet")
end

function isin(p::Point, s::Segment; tolerance=1.0e-12, closed=true)
    if (abs(slope(s)) < 1)
        # for segments that are closer to horizontal
        
    else
        # for segments that are closer to vertical

    end
end


# intersection of lines
function intersection( line1::Line, line2::Line; tolerance=1.0e-12)
    #OUTPUTS: 
    #   intersect = 0 means segments don't intersect (i.e, they are parallel)
    #             = 1 means 1 intersection
    #             = 2 means they overlap (infinite intersections) 
    #   point     = the intersection point if it exists
    #                  if they don't intersect then return "nothing"
    #                  if they are the same, then return the Line

    # if neither line is near vertical
    if abs(line1.slope - line2.slope)  < tolerance
        # lines are parallel
        if abs(line1.yint - line2.yint)  < tolerance
            # lines are the same
            return 2, line1
        else
            return 0, nothing 
        end
    else
        x = (line1.yint - line2.yint) / (line2.slope - line1.slope)
        y = line1.yint + line1.slope * x
        return 1, Point(x,y)
    end

end

# intersection of segments
function intersection( segment1::Segment, segment2::Segment; tolerance=1.0e-12 )
    #OUTPUTS: 
    #   intersect = 0 means segments don't intersect
    #             = 1 means 1 intersection
    #             = 2 means they overlap (infinite intersections) 
    #             = 3 means they are co-linear or parallel segments but with zero intersections
    #   point     = the intersection point if it exists
    #                  if they don't intersect then return "nothing"
    #                  if the segments overlap then return the overlapping Segment
    #               note that for floating point calculations we could be a little more sophisticated
    #               about these tests, but at the moment just test equality with respect to tolerance

    epsilon = 1.0e-9
    delta = 1.0e-12 # for finding "almost" intersections with end-points
    

    # different cases
    #   one line is near vertical
    


    return intersect, point
end

# prolly should add intersections of Rays
# prolly should add Ray-Line, Ray-Segment, and Line-Segment intersections as well


# function for plotting
function displayPath(s::Segment)
    return [s.startpoint, s.endpoint]
end

