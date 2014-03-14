#
# test polygon functions
# 
using Geometry2D
using PyPlot

srand(15)

points1 = PointArrayRand(5)
poly1 = Polygon(points1) 

p1 = Point(0.1, 0.5)
p2 = Point(0.6, 0.2)
p3 = Point(0.5, 0.8)
t1 = Triangle([p1,p2,p3])
c1 = Circle(p1, 0.2)
a1 = Arc(p1, 0.3, pi/2, -pi/2)
l1 = Line(Point(0.25,0), pi/2)
r1 = Ray(Point(0.4,0.1), Vect(0.5, 0.1))
s1 = Segment(Point(0.2,0.8), Point(0.8,0.2))
b = Bounds(1.5, -0.1, -0.6, 1.8)
e1 = Ellipse(Point(0.75,0.5), 0.3, 0.5, pi/6) 

#################################
# translation test
figure(50)
hold(false)
plot(0,0)
hold(true)
title("translation")
plot(origin(); marker="o", color="black")
plot(poly1; marker="", color="green")
plot(p1; marker="o", color="green")
plot(p2; marker="o", color="red")
plot(p3; marker="o", color="blue")
plot(t1; marker="", color="orange")
plot(c1; color="cyan")
plot(a1; color="magenta")
plot(l1; color="blue", bounds=b)
plot(r1; color="red", bounds=b)
plot(s1; color="green")
plot(e1; color="black")

pt = Vect(1,0.5)
plot(poly1+pt; linestyle="--", marker="", color="green")
plot(p1+pt; marker="o", color="green")
plot(p2+pt; marker="o", color="red")
plot(p3+pt; marker="o", color="blue")
plot(t1+pt; linestyle="--", marker="", color="orange")
plot(c1+pt; linestyle="--", marker="", color="cyan")
plot(a1+pt; linestyle="--", marker="", color="magenta")
plot(l1+pt; linestyle="--", color="blue", bounds=b)
plot(r1+pt; linestyle="--", color="red", bounds=b)
plot(s1+pt; linestyle="--", color="green")
plot(e1+pt; linestyle="--", color="black")

axis("equal")

#################################
# scale test
figure(51)
hold(false)
plot(0,0)
hold(true)
title("scale about the origin")
plot(origin(); marker="o", color="black")
plot(poly1; marker="", color="green")
plot(p1; marker="o", color="green")
plot(p2; marker="o", color="red")
plot(p3; marker="o", color="blue")
plot(t1; marker="", color="orange")
plot(c1; color="cyan")
plot(a1; color="magenta")

factor = 3.0
plot(scale(poly1, factor); linestyle="--", marker="", color="green")
plot(scale(p1, factor); marker="o", color="green")
plot(scale(p2, factor); marker="o", color="red")
plot(scale(p3, factor); marker="o", color="blue")
plot(scale(t1, factor); linestyle="--", marker="", color="orange")
plot(scale(c1, factor); linestyle="--", marker="", color="cyan")
plot(scale(a1, factor); linestyle="--", marker="", color="magenta")

plot(poly1 / factor; linestyle="--", marker="", color="green")
plot(p1 / factor; marker="o", color="green")
plot(p2 / factor; marker="o", color="red")
plot(p3 / factor; marker="o", color="blue")
plot(t1 / factor; linestyle="--", marker="", color="orange")
plot(c1 / factor; linestyle="--", marker="", color="cyan")
plot(a1 / factor; linestyle="--", marker="", color="magenta")

axis("equal")

#################################
# rotation test
figure(52)
hold(false)
plot(0,0)
hold(true)
title("rotation about the origin")
plot(origin(); marker="o", color="black")
plot(poly1; marker="", color="green")
plot(p1; marker="o", color="green")
plot(p2; marker="o", color="red")
plot(p3; marker="o", color="blue")
plot(t1; marker="", color="orange")
plot(c1; color="cyan")
plot(a1; color="magenta")
plot(l1; color="blue", bounds=b)
plot(r1; color="red", bounds=b)
plot(s1; color="green")
plot(e1; color="black")

angle = pi/30
plot(rotate(poly1, angle); linestyle="--", marker="", color="green")
plot(rotate(p1, angle); marker="o", color="green")
plot(rotate(p2, angle); marker="o", color="red")
plot(rotate(p3, angle); marker="o", color="blue")
plot(rotate(t1, angle); linestyle="--", marker="", color="orange")
plot(rotate(c1, angle); linestyle="--", marker="", color="cyan")
plot(rotate(a1, angle); linestyle="--", marker="", color="magenta")
plot(rotate(l1, angle); linestyle="--", color="blue", bounds=b)
plot(rotate(r1, angle); linestyle="--", color="red", bounds=b)
plot(rotate(s1, angle); linestyle="--", color="green")
plot(rotate(e1, angle); linestyle="--", color="black")

axis("equal")

#################################
# rotation about p
figure(53)
hold(false)
plot(0,0)
hold(true)
title("rotation about a point")
plot(poly1; marker="", color="green")
plot(p1; marker="o", color="green")
plot(p2; marker="o", color="red")
plot(p3; marker="o", color="blue")
plot(t1; marker="", color="orange")
plot(c1; color="cyan")
plot(a1; color="magenta")
plot(l1; color="blue", bounds=b)
plot(r1; color="red", bounds=b)
plot(s1; color="green")
plot(e1; color="black")

angle = pi/10
plot(rotate(poly1, angle, p3); linestyle="--", marker="", color="green")
plot(rotate(p1, angle, p2); marker="o", color="green")
plot(rotate(p2, angle, p2); marker="o", color="red")
plot(rotate(p3, angle, p2); marker="o", color="blue")
plot(rotate(t1, angle, p2); linestyle="--", marker="", color="orange")
plot(rotate(c1, angle, p2); linestyle="--", marker="", color="cyan")
plot(rotate(a1, angle, p2); linestyle="--", marker="", color="magenta")
plot(rotate(l1, angle, p2); linestyle="--", color="blue", bounds=b)
plot(rotate(r1, angle, p2); linestyle="--", color="red", bounds=b)
plot(rotate(s1, angle, p2); linestyle="--", color="green")
plot(rotate(e1, angle, p2); linestyle="--", color="black")

axis("equal")



#################################
# reflection about the origin
b2 = Bounds(1,-1,-1,1)
figure(54)
hold(false)
plot(0,0)
hold(true)
title("reflection about the origin")
plot(origin(); marker="o", color="black")
plot(poly1; marker="", color="green")
plot(p1; marker="o", color="green")
plot(p2; marker="o", color="red")
plot(p3; marker="o", color="blue")
plot(t1; marker="", color="orange")
plot(c1; color="cyan")
plot(a1; color="magenta")
plot(l1; color="blue", bounds=b2)
plot(r1; color="red", bounds=b2)
plot(s1; color="green")
plot(e1; color="black")

plot(-poly1; linestyle="--", marker="", color="green")
plot(-p1; marker="o", color="green")
plot(-p2; marker="o", color="red")
plot(-p3; marker="o", color="blue")
plot(-t1; linestyle="--", marker="", color="orange")
plot(-c1; linestyle="--", marker="", color="cyan")
plot(-a1; linestyle="--", marker="", color="magenta")
plot(-l1; linestyle="--", color="blue", bounds=b2)
plot(-r1; linestyle="--", color="red", bounds=b2)
plot(-s1; linestyle="--", color="green")
plot(-e1; linestyle="--", color="black")

axis("equal")


#################################
# reflection about a line
figure(55)
hold(false)
plot(0,0)
hold(true)
title("reflection about a line")
plot(origin(); marker="o", color="black")
plot(poly1; marker="", color="green")
plot(p1; marker="o", color="green")
plot(p2; marker="o", color="red")
plot(p3; marker="o", color="blue")
plot(t1; marker="", color="orange")
plot(c1; color="cyan")
plot(a1; color="magenta")
plot(l1; color="blue", bounds=b)
plot(r1; color="red", bounds=b)
plot(s1; color="green")
plot(e1; color="black")

line = Line(Point(1.1,0), -pi/4)
plot(line; color="black", bounds=b2)
plot(reflect(poly1, line); linestyle="--", marker="", color="green")
plot(reflect(p1, line); marker="o", color="green")
plot(reflect(p2, line); marker="o", color="red")
plot(reflect(p3, line); marker="o", color="blue")
plot(reflect(t1, line); linestyle="--", marker="", color="orange")
plot(reflect(c1, line); linestyle="--", marker="", color="cyan")
plot(reflect(a1, line); linestyle="--", marker="", color="magenta")
plot(reflect(l1, line); color="blue", bounds=b)
plot(reflect(r1, line); linestyle="--", color="red", bounds=b)
plot(reflect(s1, line); linestyle="--", color="green")
plot(reflect(e1, line); linestyle="--", color="black")

axis("equal")


