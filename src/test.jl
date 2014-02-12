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
using PyPlot


# test that the constructors for the basic data types work
reload("test_point")
reload("test_line")

# test circles
reload("test_circle")

# test the various overloaded forms of ccw
reload("test_ccw")

# test the convex hull code


