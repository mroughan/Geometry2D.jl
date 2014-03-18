#
# test polygon functions
# 
using Geometry2D
using PyPlot

# srand(1)

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

axis("equal")
