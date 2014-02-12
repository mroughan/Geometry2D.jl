
export plot


######################################################
# plotting routines
#    NB: should define "displayPath" for all objects that need be plotted
#

# approach is to convert into a standard path form, and plot
function plot(O::G2dObject; color="blue", label="G2dObject", marker="o", linestyle="-", linewidth=1, markersize=10)
    P = displayPath(O)
    if (label=="G2dObject")
        label=string(typeof(O)) # default label is the type of the object being plotted
    end
    plot(points_x(P), points_y(P); color=color, label=label, marker=marker, linestyle=linestyle, linewidth=linewidth, markersize=markersize)
end

# also need a nice "fill" routine


# various attempts at automating the above

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

