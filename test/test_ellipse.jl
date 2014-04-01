# test various functions related to circles
#
#
using Geometry2D
using PyPlot

srand(1)
n = 100

e1 = Ellipse(Point(0.0,0.0), 1.0, 1.5, 0.0)
e2 = Ellipse(Point(1.0,0.0), 1.5, 1.5, 0.0)
e3 = Ellipse(Point(4.0,1.0), 2.0, 1.0,  -pi/6 )
e4 = scaley(Circle(Point(3.0, -1.0), 1.0), 2.0, Point(0.0, -1.0))
 
println("circle perimeter = $(perimeter(Circle(Point(0.0,0.0), 1.5))) and elliptical perimeter is $(perimeter(Ellipse(Point(0.0,0.0), 1.5, 1.5, 0.0)))")
println("line length = $(2.0*length(Segment(Point(0.0,0.0), Point(0.0,1.0)))) and elliptical perimeter is $(perimeter(Ellipse(Point(0.5,0.0), 0.5, 0.00001, 0.0)))")
 
figure( 90)
hold(false)
plot(0,0)
hold(true)
axis("equal")
plot(e1; color="red", linewidth=2, marker="o", linestyle="--")
plot(e2; color="blue", linewidth=1, marker="o", linestyle="-")
plot(e3; color="green", linewidth=1, marker="o", linestyle="-")
plot(e4; color="magenta", linewidth=1, marker="o", linestyle="-")
 

figure(91)
hold(false)
plot(0,0)
hold(true)
axis("equal")
plot(e1; color="red", linewidth=1, marker="", linestyle="-")
plot(e2; color="blue", linewidth=1, marker="", linestyle="-")
plot(e3; color="green", linewidth=1, marker="", linestyle="-")
plot(e4; color="magenta", linewidth=1, marker="", linestyle="-")
plot(bounds(e1); color="red", linestyle="--")
plot(bounds(e2); color="blue", linestyle="--")
plot(bounds(e3); color="green", linestyle="--")
plot(bounds(e4); color="magenta", linestyle="--")

figure(92)
hold(false)
plot(0,0)
hold(true)
axis("equal")
plot(e3; color="green", linewidth=1, marker="", linestyle="-")
for i=1:n
    p = Point(4*rand()+2, 4*rand()-1)
    in,edge = isin(p, e3; tolerance=1.0e-2)
    if in && edge
        plot(p; marker="o", color="red")
    elseif in
        plot(p; marker="o", color="green")        
    else
        plot(p; marker="o", color="blue")
    end
end

figure(93)
hold(false)
plot(0,0)
hold(true)
axis("equal")
plot(e3; color="green", linewidth=1, marker="", linestyle="-")
max_diff = 0
for i=1:n 
    p = Point(8*rand(), 8*rand()-2)
    plot(p)
    d,q = distance(p, e3)
    # plot(p)
    if (p != q)
        figure(93)
        plot(Segment(p,q); marker="")
    end
    distance_diff = d - distance(p,q)
    if abs(distance_diff) > abs(max_diff)
       max_diff = distance_diff
    end
end
println("max_diff = $max_diff")
