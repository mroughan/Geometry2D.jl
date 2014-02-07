#
# test.jl, (c) Matthew Roughan, 2014
#
# created: 	Wed Feb  5 2014 
# author:  	Matthew Roughan 
# email:   	matthew.roughan@adelaide.edu.au
# 
# test basic functions and such of the Geometry2D module     
#         
#         
#
#
using Geometry2D

# reload("point.jl")
# reload("utilities.jl")
# reload("triangle.jl")


# test the various overloaded forms of ccw
n = 5
srand(1)
X = rand(3,n)
Y = rand(3,n)
X[:,1] = [1:3]   # make sure there is at least one colinear case
Y[:,1] = [0,0,0]
CCW = Array(Float64,6,n)

for i=1:n
    point1 = Point(X[1,i], Y[1,i])
    point2 = Point(X[2,i], Y[2,i])
    point3 = Point(X[3,i], Y[3,i])
    CCW[1,i] = ccw(point1, point2, point3)
    
    x = X[:,i]
    y = Y[:,i]
    CCW[2,i] = ccw(x, y) 

    points = PointArray(x, y)
    CCW[3,i] = ccw(points)

    CCW[4,i] = ccw([X[1,i], Y[1,i]], [X[2,i], Y[2,i]], [X[3,i], Y[3,i]])
end

points = PointArray(X, Y)
CCW[5,:] = ccw(points)

CCW[6,:] = ccw(X, Y)

println(CCW)


