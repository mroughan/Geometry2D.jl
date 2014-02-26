### potential bug with immutable types
###  
### originally noted the problem in 0.2.0, and comments suggested it was fixed in 0.2.1
###    https://github.com/JuliaLang/julia/issues/3651
###    https://github.com/JuliaLang/julia/commit/3904340757f976e5215becb9befeff5a56f210b1
###  
### however, I just got 0.2.1, and the problem still occurs
###


# if we replace "immutable" with "type" below, the bug goes away, 
# otherwise it segfaults when we get to the last println, even though
# the "dumps" on previous lines all work
immutable Point{T<:Number}
    x::T
    y::T
end
 
Point{T<:Number, S<:Number}(x::T, y::S) = Point(promote(x,y)...)
copy{T<:Number}(points::Vector{Point{T}}) = [ points[i] for i=1:length(points)]

########################
# a Polygon type
type Polygon{T<:Number}
    class::String
    points::Vector{Point{T}}
end
copy{T<:Number}(p::Polygon{T}) = Polygon(p.class,  copy(p.points))

########################
#   now try to do something with a generated array of polygons
function Test()
    star = Array(Polygon,(3,))
    p = [Point(1.0,1.0), Point(2.0,2.0), Point(3.0,3.0)]
    P =  Polygon("test", p)
    star[1] = P

    # output the results
    dump(star)
    dump(star[1])
    dump(star[1].points)
    println(" tmp = $(star[1].points[1].x)")
 
    return 1
end

