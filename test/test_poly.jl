#
# test polygon functions
# 
using Geometry2D
using PyPlot

srand(1)
n = 1000

poly1 = Polygon(rand(Point{Float64}, (6,)))
poly2 = Polygon(rand(Point, (4,)))
poly3 = rand(Polygon, 3)

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
for i=1:n
    p = rand(Point)
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
p = rand(Point, (n,1))
for i=1:n
    in,edge = isin(p[i], poly2; tolerance=1.0e-4)
    if in && edge
        plot(p[i]; marker="o", color="red")
    elseif in
        plot(p[i]; marker="o", color="green")        
    else
        plot(p[i]; marker="o", color="blue")
    end
end

figure(46)
hold(false)
plot(0,0)
hold(true)
plot(poly3; marker="", color="blue")
p = rand(Point, (n,1))
for i=1:n 
    in,edge = isin(p[i], poly3; tolerance=1.0e-4)
    if in && edge
        plot(p[i]; marker="o", color="red")
    elseif in
        plot(p[i]; marker="o", color="green")        
    else
        plot(p[i]; marker="o", color="blue")
    end
end
