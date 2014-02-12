export Circle, Arc

export isequal, center, radius, area, isin, bounded, approxpoly, displayPath

#################################################################
# Circles

immutable Circle{T<:Number} <: G2dCompoundObject
    center::Point{T} 
    radius::T  

    function Circle(center::Point{T}, radius::T)
        if (radius <= 0)
            error("radius must be positive")
        end
        return new(center, radius)
    end
end
Circle{T<:Number}(center::Point{T}, radius::T) = Circle{T}(center, radius)
Circle{T<:Number, S<:Number}(center::Point{T}, radius::S) = Circle(convert(Point{promote_type(T,S)}, center), convert(promote_type(T,S),radius) )

# also allow construction from three points on the circle
#   this is going to be a floating point calculation, so don't bother subtyping inputs
#   this is probably not the fastest way to solve this, but does a bit of checking
function Circle(a::Point, b::Point, c::Point; tolerance=1.0e-12)
    c = ccw(a, b, c)
    if abs(c) <= tolerance
        error("input points are close to colinear")
        # NB: this includes the case that two points are the same point
    end
    
    # compute mid-points
    mid_ab = (a+b)/2
    mid_ac = (a+c)/2
    mid_bc = (b+c)/2

    # find slopes of right-angles to chords between the points
    #   avoiding cases where one chord is vertical
    if (abs(a.y-b.y) > tolerance)
        slope_ab = - (b.x-a.x)./(b.y-a.y);
    else
        slope_ab = Inf
    end
    if (abs(a.y-c.y) > tolerance)
        slope_ac = - (c.x-a.x)./(c.y-a.y);
    else
        slope_ac = Inf
    end
    if (abs(b.y-c.y) > tolerance)
        slope_bc = - (c.x-b.x)./(c.y-b.y);
    else
        slope_bc = Inf
    end

    # create one line for each
    line_ab = Line(mid_ab, slope_ab)
    line_ac = Line(mid_ac, slope_ac)
    line_bc = Line(mid_bc, slope_bc)

    # find intersection points of the chords
    i_bc,c_bc = intersection(line_ab, line_ac)
    i_ac,c_ac = intersection(line_ab, line_bc)
    i_ab,c_ab = intersection(line_ac, line_bc)

    # check that all three give the same point
    if distance(c_ab,c_ac)>tolerance || 
        distance(c_ab,c_bc)>tolerance ||
        distance(c_ac,c_bc)>tolerance
        error("incompatible center point calculations")
    end

    # calculate the radius
    radius = distance(a, center)
    
    return Circle(center, radius)
end


# utility functions
isequal(c1::Circle, c2::Circle) = c1.center==c2.center && c1.radius==c2.radius 
center(c::Circle) = c.center
radius(c::Circle) = c.radius
area(c::Circle) = pi*c.radius*c.radius
function isin(p::Point, c::Circle; tolerance=1.0e-12, closed=true)
    d = distance(p, c.center)
    if closed
        return distance <= radius + tolerance
    else
        return distance < radius - tolerance
    end
end 
bounded(c::Circle) = true

# approximate as a regular polygon
function approxpoly(c::Circle, n::Integer)
    dtheta = 2.0*pi/n
    theta = dtheta*[0:n]
    x = c.radius * cos(theta)
    y = c.radius * sin(theta)
    return PointArray(x,y)
end

# function for plotting
function displayPath(c::Circle)
    n = 100
    P = approxpoly(c, n)
end

#################################################################
# Arcs

immutable Arc{T<:Number} <: G2dCompoundObject
    center::Point{T} 
    radius::T  
    theta0::T 
    theta1::T

    function Arc(center::Point{T}, radius::T, theta0::T, theta1::T)
        if theta0<-pi/2 || theta0>pi/2 ||
           theta1<-pi/2 || theta1>pi/2
            error("theta must, in radians in the interval [pi/2, -pi/2]")
        end
        if theta0==theta1
            error("theta0 must not be equal to theta1")
        end
        if theta1>theta0
            tmp = theta0
            theta0 = theta1
            theta1 = tmp
        end
        if (radius <= 0)
            error("radius must be positive")
        end
        return new(center, radius, theta0, theta1)
    end
end
Arc{T<:Number}(center::Point{T}, radius::T) = Arc{T}(center, radius, theta0, theta1)
Arc{T<:Number, S<:Number}(center::Point{T}, radius::S, theta0, theta1) = Arc(convert(Point{promote_type(T,S)}, center), convert(promote_type(T,S),radius) )

# utility functions
bounded(a::Arc) = false

# approximate as a set of points
function approxpoly(c::Arc, n::Integer)
    dtheta = theta1-theta0
    theta = theta0 + dtheta*[0:n]
    x = c.radius * cos(theta)
    y = x.radius * sin(theta)
    return PointArray(x,y)
end


