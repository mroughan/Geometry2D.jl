# 
# An assortment of functions related to standard transforms of 2D geometrical objects
#

export translate, scale, scalex, scaley, rotate, reflect, shear, project
export +, -, *, /

### maybe should also have objects here???

### probably should have better type checking and promotion here as well
###   e.g. scale is only using Float64 scaling factors at the moment

### transformations of an array of objects (have only done scale at the moment)

### translation functions
translate(p::Point, d::Vect) = p + d
translate{T<:Number}(P::Array{Point{T}}, d::Vect) = reshape( [(P[i]+d) for i=1:length(P)], size(P) )
translate(c::Circle, d::Vect) = Circle(c.center+d, c.radius)
translate(e::Ellipse, d::Vect) = Ellipse(e.center+d, e.a, e.b, e.theta)
translate(a::Arc, d::Vect) = Arc(a.center+d, a.radius, a.theta0, a.theta1)
translate(l::Line, d::Vect) = Line(l.startpoint+d, l.theta)
translate(r::Ray, d::Vect) = Ray(r.startpoint+d, r.direction)
translate(s::Segment, d::Vect) = Segment(s.startpoint+d, s.endpoint+d)
translate(t::Triangle, d::Vect) = Triangle(translate(t.points,d))
translate(p::Polygon, d::Vect) = Polygon(translate(p.points,d))
# + operator performs translation
for object in (Circle, Ellipse, Arc, Line, Ray, Segment, Triangle, Polygon)
    @eval begin
        +(p::Point,o::$(object)) = translate(o, p)
        +(o::$(object),p::Point) = translate(o, p)
        -(o::$(object),p::Point) = translate(o, -p)
    end
end


### scale the object (except Line, Ray and Segment) around the origin
scale(p::Point, factor::Float64) = Point(factor*p.x, factor*p.y )
scale{T<:Number}(P::Array{Point{T}}, factor::Float64) = reshape( [scale(P[i],factor) for i=1:length(P)], size(P) )
scale(c::Circle, factor::Float64) = Circle(scale(c.center,factor), c.radius*factor)
scale(e::Ellipse, factor::Float64) = Ellipse(scale(e.center,factor), e.a*factor, e.b*factor, e.theta)
scale(a::Arc, factor::Float64) = Arc(scale(a.center,factor), a.radius*factor, a.theta0, a.theta1)
scale(t::Triangle, factor::Float64) = Triangle(scale(t.points,factor))
scale(p::Polygon, factor::Float64) = Polygon(scale(p.points,factor))
# * and / operators scale (about the origin) 
for object in (Circle, Ellipse, Arc, Triangle, Polygon)
    @eval begin
        *(factor::Float64,o::$(object)) = scale(o, factor)
        *(o::$(object),factor::Float64) = scale(o, factor)
        /(o::$(object),factor::Float64) = scale(o, 1.0/factor)
    end
end
# scale around a point q
scale(o::G2dObject, factor::Float64, q::Point) = scale(o-q, factor) + q
# scale an array of objects
for object in (Point, Circle, Ellipse, Arc, Triangle, Polygon)
    @eval begin
        scale{T<:Number}(O::Array{$(object){T}},factor::Float64) = reshape( [scale(O[i], factor) for i=1:length(O)], size(O) )
        *{T<:Number}(factor::Float64,O::Array{$(object){T}}) = scale(O, factor)
        *{T<:Number}(O::Array{$(object){T}},factor::Float64) = scale(O, factor)
        /{T<:Number}(O::Array{$(object){T}},factor::Float64) = scale(O, 1.0/factor)
    end
end

### scale the object in x-direction (except Arc, Line, Ray and Segment) around the origin
scalex(p::Point, factor::Float64) = Point( factor*p.x, p.y )
scalex{T<:Number}(P::Array{Point{T}}, factor::Float64) = reshape( [scalex(P[i],factor) for i=1:length(P)], size(P) )
scalex(c::Circle, factor::Float64) = Ellipse(scalex(c.center,factor), c.radius*factor, c.radius, factor>1.0 ? 0.0 : pi/2)
scalex(t::Triangle, factor::Float64) = Triangle(scalex(t.points,factor))
scalex(p::Polygon, factor::Float64) = Polygon(scalex(p.points,factor))
# scalex around a point q
scalex(o::G2dObject, factor::Float64, q::Point) = scalex(o-q, factor) + q


### scale the object in y-direction (except Arc, Line, Ray and Segment) around the origin
scaley(p::Point, factor::Float64) = Point( p.x, factor*p.y )
scaley{T<:Number}(P::Array{Point{T}}, factor::Float64) = reshape( [scaley(P[i],factor) for i=1:length(P)], size(P) )
scaley(c::Circle, factor::Float64) = Ellipse(scaley(c.center,factor), c.radius*factor, c.radius, factor<1.0 ? 0.0 : pi/2)
scaley(t::Triangle, factor::Float64) = Triangle(scaley(t.points,factor))
scaley(p::Polygon, factor::Float64) = Polygon(scaley(p.points,factor))
# scaley around a point q
scaley(o::G2dObject, factor::Float64, q::Point) = scaley(o-q, factor) + q


### rotate counter-clockwise around the origin (angle specified in radians)
rotate(p::Point, angle::Float64) = Point(cos(angle)*p.x - sin(angle)*p.y, sin(angle)*p.x + cos(angle)*p.y )
rotate{T<:Number}(P::Array{Point{T}}, angle::Float64) = reshape( [rotate(P[i],angle) for i=1:length(P)], size(P) )
rotate(c::Circle, angle::Float64) = Circle(rotate(c.center,angle), c.radius)
rotate(e::Ellipse, angle::Float64) = Ellipse(rotate(e.center,angle), e.a, e.b, e.theta + angle)
rotate(a::Arc, angle::Float64) = Arc(rotate(a.center,angle), a.radius, a.theta0+angle, a.theta1+angle)
rotate(l::Line, angle::Float64) = Line(rotate(l.startpoint,angle), l.theta + angle)
rotate(r::Ray, angle::Float64) = Ray(rotate(r.startpoint,angle), rotate(r.direction,angle))
rotate(s::Segment, angle::Float64) = Segment(rotate(s.startpoint,angle), rotate(s.endpoint,angle))
rotate(t::Triangle, angle::Float64) = Triangle(rotate(t.points,angle))
rotate(p::Polygon, angle::Float64) = Polygon(rotate(p.points,angle))
# rotate counter-clockwise around a point p, with the default being the origin
rotate(o::G2dObject, angle::Float64, q::Point) = rotate(o-q, angle) + q
# no equivalent operator


### reflection
###    about a point (default the origin)
reflect(p::Point) = -p
# NB: - already is an operator that performs this for a point
reflect{T<:Number}(P::Array{Point{T}}) = reshape( [reflect(P[i]) for i=1:length(P)], size(P) )
reflect(c::Circle) = Circle(reflect(c.center), c.radius)
reflect(e::Ellipse) = Ellipse(reflect(e.center), e.a, e.b, e.theta)
reflect(a::Arc) = Arc(reflect(a.center), a.radius, pi-a.theta1, pi-a.theta0)
reflect(l::Line) = Line(reflect(l.startpoint), l.theta)
reflect(r::Ray) = Ray(reflect(r.startpoint), reflect(r.direction))
reflect(s::Segment) = Segment(reflect(s.startpoint), reflect(s.endpoint))
reflect(t::Triangle) = Triangle(reflect(t.points))
reflect(p::Polygon) = Polygon(reflect(p.points))
# unary - reflects around the origin
for object in (Circle, Ellipse, Arc, Line, Ray, Segment, Triangle, Polygon)
    @eval begin
        -(o::$(object)) = reflect(o)
    end
end
# reflect around a point
reflect(o::G2dObject, q::Point) = reflect(o-q) + q


###  reflection around about a line
function reflect(p::Point, l::Line)
    # rotate so we are reflecting around a horizontal line
    pr = rotate(p, -l.theta)
    lr = rotate(l, -l.theta)

    # reflect
    pr = Point(pr.x, lr.startpoint.y - (pr.y-lr.startpoint.y))

    # rotate back
    return rotate(pr, l.theta)
end
reflect{T<:Number}(P::Array{Point{T}}, line::Line) = reshape( [reflect(P[i],line) for i=1:length(P)], size(P) )
reflect(c::Circle, line::Line) = Circle(reflect(c.center,line), c.radius)
reflect(e::Ellipse, line::Line) = Ellipse(reflect(e.center,line), e.a, e.b, 2*line.theta - e.theta)
reflect(a::Arc, line::Line) = Arc(reflect(a.center,line), a.radius, 2*line.theta-a.theta1, 2*line.theta-a.theta0)
reflect(l::Line, line::Line) = Line(reflect(l.startpoint,line), 2*line.theta - l.theta)
function reflect(r::Ray, line::Line)
    refstartpoint = reflect(r.startpoint,line)
    midstartpoint = (r.startpoint + refstartpoint)/2.0
    newpoint = reflect(r.startpoint, midstartpoint)
 
    endpoint = r.startpoint + r.direction
    refendpoint = reflect(endpoint,line)
    midendpoint = (endpoint + refendpoint)/2.0
    newendpoint = reflect(endpoint, midendpoint)

    return Ray(newpoint, newendpoint - newpoint)
end
reflect(s::Segment, line::Line) = Segment(reflect(s.startpoint,line), reflect(s.endpoint,line))
reflect(t::Triangle, line::Line) = Triangle(reflect(t.points,line))
reflect(p::Polygon, line::Line) = Polygon(reflect(p.points,line))
# no equivalent operator for reflection along a line



### shear functions
# no equivalent operator



### project points onto a line
# no equivalant operator


