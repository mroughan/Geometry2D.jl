# functions for generating random objects
#   nominally these are "uniform over unit square" for Float types
#   but what does that mean actually?
# only implemented for AbstractFloat types, as this is all that makes sense???
#
export rand

# generate a random object
rand{T<:AbstractFloat}(::Type{Point{T}}) = Point{T}(rand(T), rand(T))
rand{T<:AbstractFloat}(::Type{Circle{T}}) = Circle{T}(rand(Point{T}), rand(T)) 
rand{T<:AbstractFloat}(::Type{Ellipse{T}}) = Ellipse{T}(rand(Point{T}), rand(T), rand(T), randangle(T))
rand{T<:AbstractFloat}(::Type{Arc{T}}) = Arc{T}(rand(Point{T}), rand(), randangle(T), randangle(T))
rand{T<:AbstractFloat}(::Type{Line{T}}) = Line{T}(rand(Point{T}), randangle(T))
rand{T<:AbstractFloat}(::Type{Ray{T}}) = Ray{T}(rand(Point{T}), rand(Point{T}))
rand{T<:AbstractFloat}(::Type{Segment{T}}) = Segment{T}(rand(Point{T}), rand(Point{T}))
rand{T<:AbstractFloat}(::Type{Triangle{T}}) = Triangle{T}( rand(Point{T}, (3,)) )
rand{T<:AbstractFloat}(::Type{Polygon{T}}, n::Integer) = Polygon( rand(Point{T}, (n,)) )

# random angle uniformly distributed over [-pi,pi]
randangle{T<:AbstractFloat}(::Type{T}) = pi*(rand(T)-1)
# does this even make sense for integer?

################################################################
# default versions are all Float64
for object in (Point, Circle, Ellipse, Arc, Line, Ray, Segment, Triangle)
   @eval begin
       rand(::Type{$(object)}) = rand($(object){Float64})
        # function randomarray{T<:Number}(::$(object), s::Tuple)
        #     return reshape( [random($(object)) for i=1:prod(s)], s )
        # end
   end
end
# do these ones separately because of the extra argument, 
rand(::Type{Polygon}, n::Integer) = rand(Polygon{Float64}, n)

################################################################
# vector versions are created automatically by base/random, but return a 
# slightly weird data type in the default case:
#        Array{Point{T<:Number},1} or  Array{Point{T<:Number},2}
# but this isn't quite like an Array{Point{Float64},1} when you use it as a input type, so I have
# my own code here to make the default type work, so we can create random arrays of objects
for object in (Point, Circle, Ellipse, Arc, Line, Ray, Segment, Triangle)
   @eval begin
       rand{T<:AbstractFloat}(::Type{$(object){T}}, dims::Dims) = rand!(Array($(object){T}, dims))
       rand(::Type{$(object)}, dims::Dims) = rand!(Array($(object){Float64}, dims))
   end
end


################################################################
# also functions for generating random points inside some other object
#    technically, we are generating a 2D Poisson Process on the shape in question
#    using repeated censoring of points (there are faster approaches for particular shapes
#    but this will work for any, with the codicil that they have non-zero area).
function rand{T<:AbstractFloat}(::Type{Point{T}}, b::Bounds)
    xscale = b.right - b.left
    yscale = b.top   - b.bottom
    p = Point(convert(T, b.left + xscale*rand(T)), convert(T, b.bottom + yscale*rand(T))) 
    return p
end
rand(::Type{Point}, b::Bounds) = rand(Point{Float64}, b)

for object in (Circle, Ellipse, Triangle, Polygon)
   @eval begin
       function rand{T<:AbstractFloat}(::Type{Point{T}}, o::$(object))
           B = bounds(o)
           i = 0
           p = rand(Point{T}, B)
           while !isin(p, o)[1]
               p = rand(Point{T}, B)
               i+=1
           end
           # println("i=$i")
           return p
       end
       rand(::Type{Point}, o::$(object)) = rand(Point{Float64}, o) 
   end
end


