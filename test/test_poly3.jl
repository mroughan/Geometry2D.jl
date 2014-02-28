using Geometry2D
using PyPlot

srand(2)

points1 = PointArrayRand(3)
poly1 = Polygon(points1) 
figure(70)
hold(false)
plot(0.5,0.5)
hold(true)
plot(poly1; marker=".", color="blue")
plot(centroid(poly1); marker="o", color="red")
plot(centroid(Triangle(points1)); marker="x", color="green")

c1 = Circle(Triangle(points1))
plot(c1; marker="", color="magenta", linestyle=":")
plot(centroid(c1); marker="+", color="magenta")
axis("equal")

points2 = PointArrayRand(4)
poly2 = Polygon(points2)
figure(71)
hold(false)
plot(0,0)
hold(true)
plot(poly2; marker=".", color="blue")
plot(centroid(poly2); marker="o", color="red")

points3 = PointArrayRand(4)
poly3 = Polygon(points3)
figure(72) 
hold(false)
plot(0,0)
hold(true)
plot(poly3; marker=".", color="blue")
plot(centroid(poly3); marker="o", color="red")
 


figure(73)
hold(false)
plot(0,0)
hold(true) 
plot(poly3)
n = 300
max_diff = 0.0
for i=1:n
    p = Point(rand(), rand())
    d,q = distance(p, poly3)
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

