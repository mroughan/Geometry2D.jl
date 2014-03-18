# test the triangle functions etc
using Geometry2D
using PyPlot

srand(1)

p1 = Point(0.1,0.1)
p2 = Point(0.9,0.1)
p3 = Point(0.33,0.9)
t1 = Triangle([p1,p2,p3])
println("area of t1 = $(area(t1))")

figure(30)
hold(false)
plot(0,0)
hold(true)
plot(t1)

println( isin(p1,t1) )
println( isin(p2,t1) )
println( isin(p3,t1) )
println( isin(Point(0.5,0.1),t1) )
println( isin(Point(0.5,0.1+eps()),t1) )
println( isin(Point(0.5,0.1-eps()),t1) )
println( isin(Point(0.5,0.3),t1) )
n = 300
for i=1:n
    p = rand(Point)
    in,edge = isin(p, t1; tolerance=1.0e-2)
    if in && edge
        plot(p; marker="o", color="red")
    elseif in
        plot(p; marker="o", color="green")        
    else
        plot(p; marker="o", color="blue")
    end
end

figure(31)
hold(false)
plot(0,0)
hold(true)
t2 = rand(Triangle)
plot(t2; linewidth=3)
c1 = Circle(t2)
plot(c1; color="magenta", marker="")
for i=1:n
    p = rand(Point)
    if incircumcircle(p, t2)
        plot(p; marker="o", color="red")
    else
        plot(p; marker="o", color="blue")
    end
end
axis("equal")


figure(32)
hold(false)
plot(0,0)
hold(true)
plot(t2; vertexLabelsOn=true)
p = Point(0.6, 0.2)
d,q = distance(p, t2)
plot(p)
plot(Segment(p,q))
max_diff = 0.0
for i=1:n
    p = rand(Point)
    d,q = distance(p, t2)
    # plot(p)
    if (p != q)
        plot(Segment(p,q); marker="")
    end
    distance_diff = d - distance(p,q)
    if abs(distance_diff) > abs(max_diff)
       max_diff = distance_diff
    end
end
axis("equal")

println("max differece in distances estimates = $(max_diff)")



figure(33)
hold(false)
plot(0,0)
hold(true)
# plot(t2; vertexLabelsOn=true)
fill(t2; label="t2", color="red")

r1 = Ray(Point(0.0,0.3), Point(1.0,0.2))  
plot(r1; label="ray 1", color="green", bounds=Bounds(1, -1, -1, 1))
p1 = edgeintersection( r1, t2)
plot(p1; label="intersection points 1", color="red")

r4 = Segment(Point(0.2, 0.6), Point(0.7,0.3))  
plot(r4; label="segment 4", color="orange", bounds=Bounds(1, -1, -1, 1))
p4 = edgeintersection( t2, r4; tolerance=1.0e-2)
plot(p4; label="intersection points 4", color="red")

r5 = Segment(Point(0.2, 0.2), Point(0.7,0.3))  
plot(r5; label="segment 4", color="orange", bounds=Bounds(1, -1, -1, 1))
p5 = edgeintersection( t2, r5; tolerance=1.0e-2)
plot(p5; label="intersection points 5", color="red")

# legend()



figure(34)
hold(false)
plot(0,0)
hold(true)
t = rand(Triangle, (4,))
h = fill(t; alpha=0.3)
axis("equal")


figure(35)
hold(false)
plot(0,0)
hold(true)
plot(t[1]; color="red", marker="")
fill(t[1]; pattern="lines", color="red", marker="", angle=0.0, separation=0.05, offset=0.0)
plot(t[2]; color="blue", marker="")
fill(t[2]; pattern="grid", color="blue", marker="", angle=pi/6, separation=0.02, offset=0.0, alpha=0.5)
plot(t[3]; color="green", marker="")
fill(t[3]; pattern="squarespec", color="green", marker="o", markersize=1, angle=pi/3, separation=0.02, offset=0.0, alpha=0.5)
plot(t[4]; color="yellow", marker="")
fill(t[4]; pattern="trispec", color="yellow", marker="o", markersize=2, angle=0.0, separation=0.03, offset=0.0)
axis("equal")

 