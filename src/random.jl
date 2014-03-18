# functions for generating random objects
#   nominally these are "uniform over unit square" for Float types
#   but what does that mean actually?
# only implemented for FloatingPoint types, as this is all that makes sense???
#
export rand

rand{T<:FloatingPoint}(::Type{Point{T}}) = Point{T}(rand(T), rand(T))
rand{T<:FloatingPoint}(::Type{Circle{T}}) = Circle{T}(rand(Point{T}), rand(T)) 
rand{T<:FloatingPoint}(::Type{Ellipse{T}}) = Ellipse{T}(rand(Point{T}), rand(T), rand(T), randangle(T))
rand{T<:FloatingPoint}(::Type{Arc{T}}) = Arc{T}(rand(Point{T}), rand(), randangle(T), randangle(T))
rand{T<:FloatingPoint}(::Type{Line{T}}) = Line{T}(rand(Point{T}), randangle(T))
rand{T<:FloatingPoint}(::Type{Ray{T}}) = Ray{T}(rand(Point{T}), rand(Point{T}))
rand{T<:FloatingPoint}(::Type{Segment{T}}) = Segment{T}(rand(Point{T}), rand(Point{T}))
rand{T<:FloatingPoint}(::Type{Triangle{T}}) = Triangle{T}( rand(Point{T}, (3,)) )
rand{T<:FloatingPoint}(::Type{Polygon{T}}) = error("rand isn't implemented for polygons yet")

# random angle uniformly distributed over [-pi,pi]
randangle{T<:FloatingPoint}(::Type{T}) = pi*(rand(T)-1)
# does this even make sense for integer?

# default versions are all Float64
for object in (Point, Circle, Ellipse, Arc, Line, Ray, Segment, Triangle)
   @eval begin
       rand(::Type{$(object)}) = rand($(object){Float64})
        # function randomarray{T<:Number}(::$(object), s::Tuple)
        #     return reshape( [random($(object)) for i=1:prod(s)], s )
        # end
   end
end

# vector versions are created automatically
