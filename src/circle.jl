export Circle, Arc

export isequal, center, radius, area, perimeter, isin, bounded, approxpoly, displayPath, closed, distance

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
    clockwise = ccw(a, b, c)
    if abs(clockwise) <= tolerance
        error("input points are close to colinear")
        # NB: this includes the case that two points are the same point
    end
    
    # figure(100)
    # hold(false)
    # plot(0,0)
    # hold(true)
    # plot(a; color="red", marker="o")
    # plot(b; color="red", marker="o")
    # plot(c; color="red", marker="o")

    # compute mid-points
    mid_ab = (a+b)/2
    mid_ac = (a+c)/2
    mid_bc = (b+c)/2
    # plot(mid_ab; color="green", marker="o")
    # plot(mid_ac; color="green", marker="o")
    # plot(mid_bc; color="green", marker="o")

    # find thetas of right-angles to chords between the points
    theta_ab = atan( - (b.x-a.x) / (b.y-a.y))
    theta_ac = atan( - (c.x-a.x) / (c.y-a.y))
    theta_bc = atan( - (c.x-b.x) / (c.y-b.y))

    # create one line for each
    line_ab = Line(mid_ab, theta_ab)
    line_ac = Line(mid_ac, theta_ac)
    line_bc = Line(mid_bc, theta_bc)
    # bnd = [[0 0], [3 3]]
    # plot(line_ab; bounds=bnd)
    # plot(line_ac; bounds=bnd)
    # plot(line_bc; bounds=bnd)

    # find intersection points of the chords
    i_bc,c_bc = intersection(line_ab, line_ac)
    i_ac,c_ac = intersection(line_ab, line_bc)
    i_ab,c_ab = intersection(line_ac, line_bc)
    # plot(c_ab; color="orange", marker="o")
    # plot(c_ac; color="orange", marker="o")
    # plot(c_bc; color="orange", marker="o")

    # check that all three give the same point
    d1 = distance2(c_ab,c_ac)
    d2 = distance2(c_ab,c_bc)
    d3 = distance2(c_ac,c_bc)
    # println("d1 = $d1, d2=$d2, d3=$d3")
    if d1>tolerance || d2>tolerance || d3>tolerance
        error("incompatible center point calculations")
    end
    center = (c_ab+c_ac+c_bc)/3

    # calculate the radius
    radius_a = distance(a, center)
    radius_b = distance(b, center)
    radius_c = distance(c, center)
    # println("radius_a=$radius_a, radius_b=$radius_b, radius_c=$radius_c")
    radius = (radius_a + radius_b + radius_c)/3
 
    return Circle(center, radius)
end

# promotion/conversion functions?

# utility functions
isequal(c1::Circle, c2::Circle) = c1.center==c2.center && c1.radius==c2.radius 
center(c::Circle) = c.center
radius(c::Circle) = c.radius
area(c::Circle) = pi*c.radius*c.radius
perimeter(c::Circle) = 2*pi*c.radius
function isin(p::Point, c::Circle; tolerance=1.0e-12)
    d = distance(p, c.center)
    if distance < radius - tolerance
        return true, false
    elseif distance <= radius + tolerance
        return true, true
    end
end 
bounded(c::Circle) = true
bounds(c::Circle) = Bounds(c.center.y+c.radius, c.center.y-c.radius, c.center.x-c.radius, c.center.x+c.radius)

# does the shape define an "inside" and "outside" of the plane
closed(::Circle) = true


# approximate as a regular polygon
function approxpoly(c::Circle, n::Integer)
    dtheta = 2.0*pi/n
    theta = dtheta*[0:n]
    x = c.center.x + c.radius * cos(theta)
    y = c.center.y + c.radius * sin(theta)
    return PointArray(x,y)
end

# function for plotting
function displayPath(c::Circle; n=100)
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
Arc(circle::Circle, theta0, theta1) = Arc( circle.center, circle.radius, theta0, theta1 )

# are the points on the curve bounded
bounded(a::Arc) = true

# does the shape define an "inside" and "outside" of the plane
closed(::Arc) = true

# for completeness
area(::Arc) = Inf
perimeter(a::Arc) = (theta1-theta0)*a.radius

# approximate as a set of points
function approxpoly(a::Arc, n::Integer)
    dtheta = a.theta1 - a.theta0
    theta = theta0 + dtheta*[0:n]
    x = a.radius * cos(theta)
    y = a.radius * sin(theta)
    return PointArray(x,y)
end

function distance(p::Point, c::Circle)
    d = distance(p,c.center)
    if (d - c.radius > 0)
        direction = p - c.center
        p = c.center + (c.radius/d)*direction
        return d - c.radius, p
    else
        return zero(d),d
    end
end

# function for plotting
function displayPath(a::Arc; n=100)
    P = approxpoly(a, n)
end

