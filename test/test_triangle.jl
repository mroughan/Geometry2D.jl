# test the triangle functions etc

p1 = Point(0.1,0.1)
p2 = Point(0.9,0.1)
p3 = Point(0.33,0.9)
t1 = Triangle([p1,p2,p3])
println("area of t1 = $(area(t1))")

figure(15)
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
n = 30
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
