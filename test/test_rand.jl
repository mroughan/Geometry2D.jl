#
# test polygon functions
# 
using Geometry2D
using PyPlot

srand(1)

p1 = rand(Point) 
p2 = rand(Point{Float32})
P = rand(Point, (4,))
c1 = rand(Circle{Float32})
e1 = rand(Ellipse)
a1 = rand(Arc)
l1 = rand(Line)
r1 = rand(Ray)
s1 = rand(Segment)
t1 = rand(Triangle)
poly1 = rand(Polygon, 5)

b = Bounds(1.5, -0.5, -0.5, 1.5)

#################################
# plot the random objects
figure(100)
hold(false)
plot(0,0)
hold(true)
title("random objects")
plot(b; linestyle=":", color="black")
plot(default_bounds; linestyle=":", color="black")
# plot(origin(); marker="o", color="black")
plot(p1; marker="o", color="green")
plot(p2; marker="o", color="green")
plot(P; marker="s", color="green")
plot(c1; marker="", color="red")
plot(e1; marker=".", color="magenta")
plot(a1; marker=".", color="orange")
plot(l1; marker=".", color="brown", bounds=b)
plot(r1; marker=".", color="black", bounds=b)
plot(s1; marker=".", color="red")
plot(t1; marker=".", color="blue")
plot(poly1; marker=".", color="red")

axis("equal")

################################
# test generation of random points inside an object
n = 100

figure(101)
hold(false)
plot(0,0)
hold(true)
title("random points in Bounds")
plot(b; marker="", color="black")
p1 = 0
p2 = 0
for i=1:n
    p1 = rand(Point, b)
    plot(p1; marker=".", color="red")
    p2 = rand(Point{Float32}, b)
    plot(p2; marker=".", color="green")
end
axis("equal")

figure(102)
hold(false)
plot(0,0)
hold(true)
title("random points in a Circle")
plot(c1; marker="", color="black")
p1 = 0
p2 = 0
for i=1:n
    p1 = rand(Point, c1)
    plot(p1; marker=".", color="red")
    p2 = rand(Point{Float32}, c1)
    plot(p2; marker=".", color="green")
end
axis("equal")

figure(103)
hold(false)
plot(0,0)
hold(true)
title("random points in an Ellipse")
plot(e1; marker="", color="black")
p1 = 0
p2 = 0
for i=1:n
    p1 = rand(Point, e1)
    plot(p1; marker=".", color="red")
    p2 = rand(Point{Float32}, e1)
    plot(p2; marker=".", color="green")
end
axis("equal")

figure(104)
hold(false)
plot(0,0)
hold(true)
title("random points in an Triangle")
plot(t1; marker="", color="black")
p1 = 0
p2 = 0
for i=1:n
    p1 = rand(Point, t1)
    plot(p1; marker=".", color="red")
    p2 = rand(Point{Float32}, t1)
    plot(p2; marker=".", color="green")
end
axis("equal")

figure(105)
hold(false)
plot(0,0)
hold(true)
title("random points in an Polygon")
plot(poly1; marker="", color="black")
p1 = 0
p2 = 0
for i=1:n
    p1 = rand(Point, poly1)
    plot(p1; marker=".", color="red")
    p2 = rand(Point{Float32}, poly1)
    plot(p2; marker=".", color="green")
end
axis("equal")


