# 
# some basicly useful functions
# 

export ccw, sort, plot

######################################################
# CCW functions
#   there are various overloaded alternatives here, but the first is preferred
#

# Input is three "Point" composite data structures 
#   This is the best one to use if the data are already in "Point" data structures.
#   The others are slower, but may be used to create cleaner code where it doesn't
#   need to be fast, or putting the data into Points would be wasteful (say for an array of points)
function ccw{T <: Real}(point1::Point{T}, point2::Point{T}, point3::Point{T})
    v1 = point2 .- point1
    v2 = point3 .- point2
    return v1.x*v2.y - v1.y*v2.x
end
ccw{T<:Real,S<:Real,V<:Real}(point1::Point{T}, point2::Point{S}, point3::Point{V}) = ccw(promote(point1,point2,point3)...)

# Input is a vector of 3 Points
function ccw{T <: Real}(points::Vector{Point{T}})
    if length(points) != 3
       error("points should be a 3 element vector of points")
    end
    v1 = points[2] .- points[1]
    v2 = points[3] .- points[2]
    return v1.x*v2.y - v1.y*v2.x
end

# Inputs 'points' is a 3xn array of Points
function ccw{T <: Real}(points::Array{Point{T}})
    if size(points,1) != 3
       error("points should be a 3xn array of points")
    end
    v1 = points[2,:] .- points[1,:]
    v2 = points[3,:] .- points[2,:]
    return points_x(v1).*points_y(v2) .- points_y(v1).*points_x(v2)
end

# Inputs x and y are 3 element vectors providing coordinates for the three points
function ccw{T <: Real}(x::Vector{T}, y::Vector{T}) 
    if length(x) != length(x)
        error("The size of x must be the same as size y.")
    end
    return (x[2] - x[1])*(y[3] - y[1]) - 
               (y[2] - y[1])*(x[3] - x[1])
end

# Inputs X and Y are 3xn arrays of coordinates of n sets of 3 points
function ccw{T <: Real}(X::Array{T}, Y::Array{T}) 
    if size(X) != size(Y)
        error("The size of X must be the same as size Y.")
    end
    if size(X,1) != 3 || size(Y,1) != 3
        error("X and Y should be 3xn vertices")
    end
    return (X[2,:] - X[1,:]).*(Y[3,:] - Y[1,:]) - 
               (Y[2,:] - Y[1,:]).*(X[3,:] - X[1,:])
end

# Inputs p1,p2, and p3 are three 2-element vectors, each containing (x,y) coordinates
function ccw{T <: Real}(p1::Vector{T}, p2::Vector{T}, p3::Vector{T})
    if length(p1)!=2 || length(p2)!=2 || length(p3)!=2 
        error("p1, p2, and p3 should be 2 element vectors")
    end
    return (p2[1] - p1[1])*(p3[2] - p1[2]) - 
               (p2[2] - p1[2])*(p3[1] - p1[1])
end


######################################################
# Lexicographic sorting functions for points
#     i.e., sort first by x-coordinate, then if that is equal sort by y
#     the function returns the permutation, to get sorted points do
#        points = points[k]
#

# Input a vector of Points
function sortperm{T <: Real}(points::Vector{Point{T}})
    k1 = sortperm(points_y(points))
    k2 = sortperm(points_x(points[k1]), alg=MergeSort)
    return k1[k2]
end

# Inputs x and y are vectors providing coordinates for the points
function sortperm{T <: Real}(x::Vector{T}, y::Vector{T}) 
    k1 = sortperm(y)
    k2 = sortperm(x[k1], alg=MergeSort)
    return k1[k2]
end

# # Inputs are the points in a nx2 array, would overload native sorts, so avoid this
# function sort{T <: Real}(P::Array{T})
#     k1 = sortperm(P[:,2])
#     k2 = sortperm(P[k1,1], alg=MergeSort)
#     return P[k1[k2],:], k1[k2]
# end
