# 
# An assortment of routines related to triangles
#    NB: a triangle here is just a PointArray with three points
#        it doesn't really seem to make sense to have a separate type or I have to redefine everything again
#        so we have to know that a point array is a triangle of not using "istriangle"    
#    So a triangle is a 3x1 array of points
#    And a Vector of triangles is a 3xn array of points
#    Don't build arbitrary arrays of triangles
#
#    https://groups.google.com/forum/#!topic/julia-dev/Pz5bBwwQmMw
#
export Triangle, TriangleRand, isTriangle

function Triangle{T<:Number}(x::Array{T}, y::Array{T})
    if size(x) != size(y)
        error(" size of x must be the same as size y.")
    end
    if (size(x,1) != 3 || size(y,3) != 3)
        error(" triangles have three vertices")
    end
    if ndims(x)==1
        # points must be unique, and in counter-clockwise order
        c = ccw(x, y)
        if c>0
            return PointArray(x, y)
        elseif c<0
            return PointArray(flipud(x), flipud(y))            
        else
            error("points appear to be colinear")
        end 
    elseif ndims(x)==2
        tmp = Array(Point{T}, size(x))
        c = ccw(x, y)
        for k=1:size(x,2)
            if c[k]>0
                tmp[1,k] = Point(x[1,k],x[1,k])
                tmp[2,k] = Point(x[2,k],x[2,k])
                tmp[3,k] = Point(x[3,k],x[3,k])
            elseif c[k]<0
                tmp[3,k] = Point(x[1,k],x[1,k])
                tmp[2,k] = Point(x[2,k],x[2,k])
                tmp[1,k] = Point(x[3,k],x[3,k])
            else
                error("points $k appear to be colinear")
            end
        end
        return tmp
    end
end
Triangle{T<:Number, S<:Number}(x::Array{T}, y::Array{S}) = Triangle(promote(x,y)...)
Triangle() = PointArray(3)
Triangle(n::Integer) = PointArray(3, n)
TriangleRand(n::Integer) = Triangle(rand(3,n), rand(3,n))

# have a test because Triangle isn't a formal type
function isTriangle{T<:Number}(t::Array{Point{T}})
    # returns true for each array element that is a valid triangle
    #     i.e., a 3 element vector of points in counter-clockwise order
    if (size(t,1) != 3)
        return falses(size(t))
    end
    return ccw(t) > 0
end


# utilities

# no "type" Triangle
# bounded(t::Triangle) = true
