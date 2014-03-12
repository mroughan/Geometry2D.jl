
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




#############################################333
# filling functionality

function fill(O::G2dObject; label="G2dObject", 
              pattern="", angle=pi/6.0, separation=1.0, offset=0.0, 
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
            # block colors
            h = fill(points_x(P), points_y(P); label=label, varargs...)
        else
            # fill with a pattern

            # rotate so that pattern is horizontal/vertical
            O2 = rotate(O, -angle)

            # find the bounding region
            b = quantise(bounds(O2), separation, offset)
            
            # generate points or lines inside the object
            if pattern=="squarespec"
                x = [b.left  : separation : b.right]
                y = [b.bottom: separation : b.top]
                P2 = Array(Point{Float64}, (length(x),length(y)))
                I2 = Array(Bool, (length(x),length(y)))
                for i=1:length(x) 
                    for j=1:length(y)
                        P2[i,j] = Point(x[i], y[j])
                        I2[i,j] = isin(P2[i,j], O2)[1]
                    end 
                end
            elseif pattern=="trispec"
                x = [b.left-separation/2 : separation : b.right]
                y = [b.bottom: separation/sqrt(2) : b.top]
                P2 = Array(Point{Float64}, (length(x),length(y)))
                I2 = Array(Bool, (length(x),length(y)))
                for i=1:length(x)
                    for j=1:length(y)
                        if mod(j,2) == 0
                           P2[i,j] = Point(x[i], y[j])
                        else
                           P2[i,j] = Point(x[i]+separation/2, y[j])
                        end
                        I2[i,j] = isin(P2[i,j], O2)[1]
                    end 
                end
            elseif pattern=="lines"
                y = [b.bottom: separation : b.top]
                P2 = []
                I2 = []
                for i=1:length(y) 
                    r = Ray(Point(b.left,y[i]), Point(1.0,0.0))
                    s = intersection(r, O2)
                    P2 = [P2, s]
                    I2 = [I2, trues(length(s))]
                end
            elseif pattern=="grid"
                y = [b.bottom: separation : b.top]
                P2 = []
                I2 = []
                for i=1:length(y) 
                    r = Ray(Point(b.left,y[i]), Point(1.0,0.0))
                    s = intersection(r, O2)
                    P2 = [P2, s]
                    I2 = [I2, trues(length(s))]
                end
                x = [b.left: separation : b.right]
                for i=1:length(x) 
                    r = Ray(Point(x[i],b.bottom), Point(0.0,1.0))
                    s = intersection(r, O2)
                    P2 = [P2, s] 
                    I2 = [I2, trues(length(s))]
                end
            elseif pattern=="checked"
                error("not implemented yet")                
            elseif pattern=="striped" 
                error("not implemented yet")
            else
                error("unimplemented type of pattern")
            end

            # rotate back to original frame, and plot
            # P = similar(P2, length(O2))
            h = Array(Any,0)
            for i=1:length(P2)
                if I2[i]
                    h1 = plot(rotate(P2[i], angle); varargs...)
                    h = [h, h1]
                end
            end
            
        end 
    else
        h = nothing
    end
    return h
end

