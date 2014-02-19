#
# test polygon functions
# 
using Geometry2D
using PyPlot

srand(1)

points1 = PointArrayRand(6)
poly1 = Polygon(points1) 

points2 = PointArrayRand(4)
poly2 = Polygon(points2)

points3 = PointArrayRand(3)
poly3 = Polygon(points3)

figure(40)
hold(false)
plot(0,0)
hold(true)
plot(poly1; color="green")
plot(poly2; marker="s", color="blue")
plot(poly3; marker="d", color="red")

figure(41)
hold(false)
plot(0,0)
hold(true)
plot(poly1; marker="", color="blue", anglesOn=true, vertexLabelsOn=true)
axis("equal")
plot(translate(poly1, Vect(0.2, 0.2)); marker="", color="red")

figure(42)
hold(false)
plot(0,0)
hold(true)
plot(poly2; marker="", color="blue", anglesOn=true, vertexLabelsOn=true)
axis("equal")
plot(translate(poly2, Vect(0.2, 0.2)); marker="", color="red")

figure(43)
hold(false)
plot(0,0)
hold(true)
plot(poly3; marker="", color="blue", anglesOn=true, vertexLabelsOn=true)
axis("equal")
plot(translate(poly3, Vect(0.2, 0.2)); marker="", color="red")



figure(44)
hold(false)
plot(0,0)
hold(true)
plot(poly1; marker="", color="blue")
n = 1000
for i=1:n
    p = Point(rand(), rand())
    in,edge = isin(p, poly1; tolerance=1.0e-4)
    if in && edge
        plot(p; marker="o", color="red")
    elseif in
        plot(p; marker="o", color="green")        
    else
        plot(p; marker="o", color="blue")
    end
end

figure(45)
hold(false)
plot(0,0)
hold(true)
plot(poly2; marker="", color="blue")
n = 1000
for i=1:n
    p = Point(rand(), rand())
    in,edge = isin(p, poly2; tolerance=1.0e-4)
    if in && edge
        plot(p; marker="o", color="red")
    elseif in
        plot(p; marker="o", color="green")        
    else
        plot(p; marker="o", color="blue")
    end
end

figure(46)
hold(false)
plot(0,0)
hold(true)
plot(poly3; marker="", color="blue")
n = 1000
for i=1:n
    p = Point(rand(), rand())
    in,edge = isin(p, poly3; tolerance=1.0e-4)
    if in && edge
        plot(p; marker="o", color="red")
    elseif in
        plot(p; marker="o", color="green")        
    else
        plot(p; marker="o", color="blue")
    end
end


