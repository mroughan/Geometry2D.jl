# 
# some basicly useful functions
# 

export ccw

######################################################
# CCW functions
#

# assume three "Point" composite data structures 
#   this is the best one to use if the data are already in "Point"
function ccw(point1::Point, point2::Point, point3::Point)
    v1 = point2 .- point1
    v2 = point3 .- point2
    return v1.x*v2.y - v1.y*v2.x
end

# assumes input is a vector of 3 Points
function ccw{T <: Number}(points::Vector{Point{T}})
    if length(points) != 3
       error("points should be a 3 element vector of points")
    end
    v1 = points[2] .- points[1]
    v2 = points[3] .- points[2]
    return v1.x*v2.y - v1.y*v2.x
end

# assumes input is a 3xn array of Points
function ccw{T <: Number}(points::Array{Point{T}})
    if size(points,1) != 3
       error("points should be a 3xn array of points")
    end
    v1 = points[2,:] .- points[1,:]
    v2 = points[3,:] .- points[2,:]
    return points_x(v1).*points_y(v2) .- points_y(v1).*points_x(v2)
end

# x and y vectors passed for the three points
function ccw(x::Vector, y::Vector) 
    if length(x) != length(x)
        error("The size of x must be the same as size y.")
    end
    return (x[2] - x[1])*(y[3] - y[1]) - 
               (y[2] - y[1])*(x[3] - x[1])
end

# x and y vectors passed a 3xn array of points (n Points)
function ccw(X::Array, Y::Array) 
    if size(X) != size(Y)
        error("The size of X must be the same as size Y.")
    end
    if size(X,1) != 3 || size(Y,1) != 3
        error("X and Y should be 3xn vertices")
    end
    return (X[2,:] - X[1,:]).*(Y[3,:] - Y[1,:]) - 
               (Y[2,:] - Y[1,:]).*(X[3,:] - X[1,:])
end

# assumes input are three 2-element vectors
function ccw(p1::Vector, p2::Vector, p3::Vector)
    if length(p1)!=2 || length(p2)!=2 || length(p3)!=2 
        error("p1, p2, and p3 should be 2 element vectors")
    end
    return (p2[1] - p1[1])*(p3[2] - p1[2]) - 
               (p2[2] - p1[2])*(p3[1] - p1[1])
end


######################################################
# ???? functions
#
