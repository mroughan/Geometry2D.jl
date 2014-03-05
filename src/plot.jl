
export plot, fill


######################################################
# plotting routines
#    NB: should define "displayPath" and "bounded" for all objects that need be plotted
#           

# add a plot routine for A::Array{G2dObject}, that iterates over the array

# approach is to convert into a standard path form, and plot
#   varargs are the standard optional arguments for PyPlot
#      color, marker, markersize, linestyle, linewidth, hold, ...
#   http://matplotlib.org/api/axes_api.html#matplotlib.axes.Axes.plot
function plot(O::G2dObject; anglesOn=false, vertexLabelsOn=false, bounds=default_bounds, label="G2dObject", marker="o", linestyle="-", varargs...)
    if bounded(O)
        if method_exists(displayPath, (typeof(O),))
            P = displayPath(O)
        else
            P = []
        end
        if method_exists(displayPoints, (typeof(O),))
            Po = displayPoints(O)
        else
            Po = []
        end
    else
        if method_exists(displayPath, (typeof(O),))
            P = displayPath(O; bounds=bounds)
        else
            P = []
        end
        if method_exists(displayPoints, (typeof(O),))
            Po = displayPoints(O; bounds=bounds)
        else
            Po = []
        end
    end
    if (label=="G2dObject")
        label=string(typeof(O)) # default label is the type of the object being plotted
    end
    if length(P)>0
        h = plot(points_x(P), points_y(P); label=label, linestyle=linestyle, marker="", varargs...)
    else
        h = nothing
    end
    if length(Po)>0
        ho = plot(points_x(Po), points_y(Po); hold=true, label=label, marker=marker, linestyle="", varargs...)
    else 
        ho = nothing
    end

    # textual labels on the points
    if vertexLabelsOn
        for i=1:length(Po)
            tmp = @sprintf("%d", i)
            text(P[i].x, P[i].y, tmp; va="center")
        end
    end

    # plot angles
    if anglesOn && length(P)>2
        # calculate the angles
        a = angles(Polygon(P))
        for i=1:length(a)
            r = 0.1
            
            # draw an arc for each angle -- requires a bit of work
            theta1 = angle( P[mod1(i+1,length(a))], P[i] )
            theta0 = angle( P[mod1(i-1,length(a))], P[i] )
            if ccw(P[mod1(i-1,length(a))],  P[i],  P[mod1(i+1,length(a))] )<=0
                arc = Arc(P[i], r, theta0, theta1)
                plot(arc; linestyle=":", hold=true, varargs...)
                mid_angle = (arc.theta1+arc.theta0)/2
            else
                arc = Arc(P[i], r, theta1, theta0)
                plot(arc; linestyle=":", hold=true, varargs...)
                mid_angle = (arc.theta1+arc.theta0)/2
            end

            # write the angle
            tmp = @sprintf("%.1f\u00B0", 180.0*a[i]/pi)
            text(P[i].x + (r/3.0)*cos(mid_angle), P[i].y + (r/2.0)*sin(mid_angle), tmp; va="center", ha="center")
            plot(P[i].x + (r/3.0)*cos(mid_angle), P[i].y + (r/2.0)*sin(mid_angle); marker="x", hold=true)
       end
    end
    
    # could do something similar to "displayPoints" for the path to show an arrow?
    # if ~bounded(O) && length(P)>1
    #     arrow(P[2].x, P[2].y, P[1].x, P[1].y, head_width=0.05, head_length=0.1)
    #     arrow(P[end-1].x, P[end-1].y, P[end].x, P[end].y, head_width=0.05, head_length=0.1)
    # end

    return h, ho
end
# vectorise separately from other code to allow for varargs???
#   really would like this to be a more generic type, e.g., G2dObject, but they aren't parameterised, and it
#   seems to need that to find it
plot{T<:Number}(A::Array{Point{T}}; varargs...) = reshape( [plot(A[i]; varargs...) for i=1:length(A)], size(A) )

function fill(O::G2dObject; label="G2dObject", 
              pattern="", linestyle="-", angle=45, width=10, 
              varargs...)
    if closed(O)
        if method_exists(displayPath, (typeof(O),))
            P = displayPath(O)
        else
            error("haven't implemented displayPath for objects of type $(typeof(O)) yet")
        end
        if (label=="G2dObject")
            label=string(typeof(O)) # default label is the type of the object being plotted
        end
    else
        error("can only 'fill' a closed object")
    end
    if length(P)>0
        if pattern==""
            h = fill(points_x(P), points_y(P); label=label, varargs...)
        elseif pattern=="speckled"
            # options: specksize, marker, color

        elseif pattern=="checked"
            # options: checksize, checkfg, checkbg

        elseif pattern=="lines"
            # options: linestyle, linewidth, angle, width, color

        elseif pattern=="striped" 
            # options: stripecolors, angle, width

        else
            error("unimplemented type of pattern")
        end 
    else
        h = nothing
    end
    return h
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

