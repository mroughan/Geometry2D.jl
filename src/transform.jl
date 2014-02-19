# 
# An assortment of functions related to standard transforms of 2D geometrical objects
#

export translate, scale, rotate, shear, reflect
export +, -

### maybe should also have objects here???

### probably should have better type checking and promotion here as well

### translation functions
translate(p::Point, d::Vect) = p + d
translate{T<:Number}(P::Array{Point{T}}, d::Vect) = reshape( [(P[i]+d) for i=1:length(P)], size(P) )
translate(c::Circle, d::Vect) = Circle(c.center+d, c.radius)
translate(a::Arc, d::Vect) = Arc(a.center+d, a.radius, a.theta0, a.theta1)
translate(l::Line, d::Vect) = Line(l.point+d, l.theta)
translate(r::Ray, d::Vect) = Ray(r.startpoint+d, r.direction)
translate(s::Segment, d::Vect) = Segment(s.startpoint+d, s.endpoint+d)
translate(t::Triangle, d::Vect) = Triangle(translate(t.points,d))
translate(p::Polygon, d::Vect) = Polygon(translate(p.points,d))
# + operator performs translation, .+ operator performs on arrays
for object in (Circle, Arc, Line, Ray, Segment, Triangle, Polygon)
    @eval begin
        +(p::Point,o::$(object)) = translate(o, p)
        +(o::$(object),p::Point) = translate(o, p)
        -(o::$(object),p::Point) = translate(o, -p)
    end
end
# and for arrays, including arrays of points?


### scale around a point p, with the default being the origin
scale(q::Point, scale::Float64) = Point(scale*q.x, scale*q.y )
scale(q::Point, p::Point, angle::Float64) = scale(q-p, angle) + p
# * and / operators scale (about the origin)

### rotate counter-clockwise around a point p, with the default being the origin
rotate(q::Point, angle::Float64) = Point(cos(angle)*q.x + sin(angle)*q.y, -sin(angle)*q.x + cos(angle)*q.y )
rotate(q::Point, p::Point, angle::Float64) = rotate(q-p, angle) + p
# no equivalent operator

### shear functions
# no equivalent operator


### reflection
###    about a point (default the origin)
###    about a line (default y axis)



