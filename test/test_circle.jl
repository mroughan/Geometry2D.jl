# test various functions related to circles
#
#
using Geometry2D
using PyPlot

srand(1)

c1 = Circle(Point(1,1), 1.0)
@assert c1.center==Point(1,1)

figure(12)
hold(false)
axis("equal")
# plot(c1, "r+")
h = plot(c1; color="red", linewidth=2, marker="+", linestyle="--")

a = Point(1,0.7)
b = Point(1.7,2)
c = Point(2.6,1)
c2 = Circle(a, b, c) 

figure(12)
hold(true)
plot(c2)
plot(a; color="magenta", marker="d")
plot(b; color="magenta", marker="d")
plot(c; color="magenta", marker="d")
legend()

println("c1 is bounded is $(bounded(c1)), with bounds = $(bounds(c1))")
println("c2 is bounded is $(bounded(c2)), with bounds = $(bounds(c2))")

### intersections
figure(13)
hold(false)
plot(0,0)
hold(true)
plot(c1)
l = Line(Point(0,0), 0.0 )
p = []
for i=1:10
    plot(l; bounds=Bounds(2.2, -0.5, -0.5, 2.2))
    p = edgeintersection(c1, l; tolerance=1.0e-12)
    for i=1:length(p)
        plot(p[i])
    end
    l = Line(Point(2*rand(), 2*rand()), pi*(rand()-0.5) )
end
l = Line(Point(1.2,0), pi/2 )
plot(l; bounds=Bounds(2.2, -0.5, -0.5, 2.2))
p = edgeintersection(c1, l; tolerance=1.0e-12)
for i=1:length(p)
    plot(p[i])
end
axis("equal")

figure(14)
hold(false)
plot(0,0)
hold(true)
plot(c1)
l = Segment(Point(0,0), Point(2.0,2.0) )
p = []
for i=1:20
    plot(l; marker="", bounds=Bounds(2.2, -0.5, -0.5, 2.2))
    p = edgeintersection(c1, l; tolerance=1.0e-12)
    for i=1:length(p)
        plot(p[i]) 
    end
    l = Segment(Point(3*rand(), 3*rand()), Point(3*rand(), 3*rand()) )
end
axis("equal")

# do circle-circle intersections
figure(15) 
hold(false)
plot(0,0)
hold(true)
plot(c1; color="blue", marker="")
c4 = Circle(Point(-1,1), 1.0)
plot(c4; color="red", marker="")
P14 = edgeintersection(c1, c4; tolerance=1.0e-12)
plot(P14; color="red")

c5 = Circle(Point(1.0,1.55), 0.45)
plot(c5; color="orange", marker="")
P15 = edgeintersection(c1, c5; tolerance=1.0e-12)
plot(P15; color="orange")
P51 = edgeintersection(c5, c1; tolerance=1.0e-12)
plot(P51; color="black", marker="+")

c6 = Circle(Point(1.0,0.55), 0.45)
plot(c6; color="green", marker="")
P16 = edgeintersection(c1, c6; tolerance=1.0e-12)
plot(P16; color="green")

c7 = Circle(Point(1.0,2.55), 0.45)
plot(c7; color="magenta", marker="")
P17 = edgeintersection(c1, c7; tolerance=1.0e-12)
plot(P17; color="magenta")

c8 = Circle(Point(-0.8,1.55), 0.65)
plot(c8; color="brown", marker="")
P48 = edgeintersection(c4, c8; tolerance=1.0e-12)
plot(P48; color="brown")
P84 = edgeintersection(c8, c4; tolerance=1.0e-12)
plot(P84; color="red", marker="+")

c9 = Circle(Point(-1.2,2.55), 1.2)
plot(c9; color="black", marker="")
P49 = edgeintersection(c4, c9; tolerance=1.0e-12)
plot(P49; color="black")
P94 = edgeintersection(c9, c4; tolerance=1.0e-12)
plot(P94; color="red", marker="+")

axis("equal")


#### Need some tests for Arc as well
figure(16)
hold(false)
plot(0,0)
hold(true)
arc = 0
for i=1:10
    theta0 = rand()*2*pi - pi
    theta1 = rand()*2*pi - pi
    radius = rand()*0.2 + 0.2
    c = Point(rand(), rand())
    arc = Arc(c, radius, theta0, theta1)
    plot(arc)
end
axis("equal")

# test circum- and incircles
p1 = Point(rand(), rand())
p2 = Point(rand(), rand())
p3 = Point(rand(), rand())
t1 = Triangle(p1,p2,p3)
c1 = Circle(t1)
c2 = incircle(t1)
figure(16)
hold(false)
plot(0,0)
hold(true)
plot(t1)
plot(c1)
plot(c2)
axis("equal")

