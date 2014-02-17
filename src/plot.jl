
export plot


######################################################
# plotting routines
#    NB: should define "displayPath" and "bounded" for all objects that need be plotted
#           

# approach is to convert into a standard path form, and plot
#   varargs are the standard optional arguments for PyPlot
#      color, marker, markersize, linestyle, linewidth, hold, ...
#   http://matplotlib.org/api/axes_api.html#matplotlib.axes.Axes.plot
function plot(O::G2dObject; bounds=default_bounds, label="G2dObject", varargs...)
    if bounded(O)
        P = displayPath(O)
    else
        # for unbounded objects, give them a rectangle in which to be plotted
        #    bounds = [ [x_0,y0], [x_1,y_1]]  where 
        #                  (x_0,y_0) = bottom left
        #                  (x_1,y_1) = top right
        P = displayPath(O; bounds=bounds)
    end
    if (label=="G2dObject")
        label=string(typeof(O)) # default label is the type of the object being plotted
    end
    # println(P)
    if length(P)>0
        h = plot(points_x(P), points_y(P); label=label, varargs...)
        return h
    else
        warn("empty set of plot points")
    end
    # if ~bounded(O) && length(P)>1
    #     arrow(P[2].x, P[2].y, P[1].x, P[1].y, head_width=0.05, head_length=0.1)
    #     arrow(P[end-1].x, P[end-1].y, P[end].x, P[end].y, head_width=0.05, head_length=0.1)
    # end
end

# also need a nice "fill" routine
#   basic approach similar to above
#       used "closed" instead of "bounded" to decide how to plot
#       define a "boundingPath" function for each type to create a closed polygon approximating it
#       fill the polygon
#   will need a "fill" command: maybe matplotlib to start, but then my own for patterns
#   will need to know something about convexity/simplicity to fill?
#   
#   somethings: Point, Line, ...
#     aren't fillable
#
#   what should be the default for a "PointArray"?
#


#####################################################
# various attempts at automating function creation
#   none of which is working as yet

# function plot(c::Circle, plotargs...)
#     println("plot(circle)")
#     for x in plotargs
#         println("    $x")
#     end
#     n = 100
#     P = approxpoly(c, n)
#     plot(points_x(P), points_y(P), plotargs...)
# end

# arglist2 = "color=color, linewidth=3"
# arglist = "color=\"blue\", linewidth=3"
# arglist = "test1"
# eval(quote 
#     plot2(c::Circle, symbol($arglist)) = 1 
#     end)


# @eval plot2(c::Circle; quote($arglist)) = 1 

# eval(quote
#     function plot2(c:Circle; $arglist)
#         n = 100
#         P = approxpoly(c, n)
#         plot(points_x(P), points_y(P); $arglist2)
#     end
#     end)

