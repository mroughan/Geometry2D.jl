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
    p = Point(rand(), rand())
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
t2 = TriangleRand()
plot(t2; linewidth=3)
c1 = Circle(t2)
plot(c1; color="magenta", marker="")
for i=1:n
    p = Point(rand(), rand())
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
    p = Point(rand(), rand())
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


