export Ellipse

export isequal, center, radius, area, perimeter, isin, bounded, approxpoly, displayPath, closed, distance, inellipse, centroid, edgeintersection, intersection

#################################################################
# Ellipses

immutable Ellipse{T<:Number} <: G2dCompoundObject 
    center::Point{T} 
    a::T     # semi-major axis length que
    b::T     # semi-minor axis length
    theta::T # angle of major axis to the x-axis
    
    function Ellipse(center::Point{T}, a::T, b::T, theta::T)
        if (a <= 0 || b <= 0)
            error("semi-major and semi-minor axis lengths must be positive")
        end
        if a < b
            tmp = a
            a = b
            b = tmp
        end
        if theta < -pi/2
            while theta < -pi/2
                theta += pi 
            end
        elseif theta > pi/2
            while theta > pi/2
                theta -= pi
            end
        end 
        return new(center, a, b, theta)
    end
end
Ellipse{T<:Number}(center::Point{T}, a::T, b::T, theta::T) = Ellipse{T}(center, a, b, theta)

# promotion/conversion functions?
convert{T<:Number}(::Type{Ellipse}, e::Circle{T}) = Ellipse(e.center, e.radius, e.radius, zero(T))

# utility functions
isequal(e1::Ellipse, e2::Ellipse) = e1.center==e2.center && e1.a==e2.a && e1.b==e2.b && e1.theta==e2.theta
center(e::Ellipse) = e.center
area(e::Ellipse) = pi*e.a*e.b
# perimeter(e::Ellipse) = 4*e.a*Elliptic(eccentricity(e))
centroid(e::Ellipse) = e.center

# specific ellipse functions
semimajor(e::Ellipse) = e.a
semiminor(e::Ellipse) = e.b
focus(e::Ellipse) = sqrt(e.a*e.a - e.b*e.b) # distance from center to a focal point, along major axis
eccentricity(e::Ellipse) = focus(e)/e.a
latusrectum(e::Ellipse) = 2*e.b*e.b/e.a # length of latus rectum, which is the line through the focus at right angles to major axis

function isin(p::Point, e::Ellipse; tolerance=1.0e-12)
    # convert to problem of checking if the point is in the unit circle
    c = Circle(Point(0.0,0.0), 1.0)
    q = scaley(scalex(rotate((p-e.center), -e.theta), 1/e.a), 1/e.b)
    return isin(q,c; tolerance=tolerance)
end
bounded(e::Ellipse) = true
function bounds(e::Ellipse) 
    phix = atan( -e.b*tan(e.theta) / e.a )   
    px = rotate(Point( e.a*cos(phix), e.b*sin(phix) ), e.theta)
    x = abs(px.x)
 
    phiy = atan( -e.b*cot(e.theta) / e.a )
    py = rotate(Point( e.a*cos(phiy), e.b*sin(phiy) ), -e.theta) 
    y = abs(py.y)
 
    return Bounds(e.center.y+y, e.center.y-y, e.center.x-x, e.center.x+x)
end

# does the shape define an "inside" and "outside" of the plane
closed(::Ellipse) = true

# approximate as a regular polygon
function approxpoly(e::Ellipse, n::Integer)
    dtheta = 2.0*pi/n
    theta = dtheta*[0:n]
    x = e.a * cos(theta)
    y = e.b * sin(theta)
    return rotate(PointArray(x,y), e.theta) + e.center
end

# function for plotting
function displayPath(e::Ellipse; n=100)
    P = approxpoly(e, n)
end
function displayPoints(e::Ellipse)
    # output the center, and two foci
    f = focus(e)
    F = Vect( f*cos(e.theta), f*sin(e.theta) )
    return [e.center, e.center + F, e.center - F]
end


#############################
# distance functions

function distance(p::Point, e::Ellipse)
    # rotate so that major axis and x axis align

    # 
    
end
distance2(p::Point, e::Ellipse) = distance(p, c)[1]^2

# function distance(e1::Ellipse, e2::Ellipse)
#     d = distance(e1.center,e2.center)
#     if d - e1.radius - e2.radius >= 0
#         direction = e2.center - e1.center
#         p1 = e1.center + (e1.radius/d)*direction
#         p2 = e2.center - (e2.radius/d)*direction
#         return d - e1.radius - e2.radius, p1, p2
#     else
#         return zero(d),nothing,nothing
#     end
# end
# distance2(e1::Ellipse, e2::Ellipse) = distance(e1,e2)[1]^2


