print("\n==========================================\n lines \n")

# some points to use below
p1 = Point(0,0)
p2 = Point(1.0,1.0)
p3 = Point(1//2, 2//3)
p4 = Point(0.0, 0.0)
p5 = Point(4,2)

# set up some example lines and test them
l1 = Line(1,1)
l2 = Line(1.0,1.0)
l3 = Line(1, 1.0)
l4 = Line(2//3, 1//1)
l5 = Line(p1,p2)
l6 = Line(p2,p3)
l7 = Line(Point(0,1), pi/4)
l8 = Line(Point(0.0,1.0), 1)
l0 = Line(Point(1.0,1.0), pi/2)
la = Line(Point(1.0,1.0), 0)

println( isequal(l1, l2) ) # true
println( isequal(l1, l3) ) # true
println( isequal(l1, l4) ) # false
println( isequal(l1, l5) ) # false
println( isequal(l1, l6) ) # false

println( isparallel(l1, l2) ) # true
println( isparallel(l1, l3) ) # true
println( isparallel(l1, l4) ) # true
println( isparallel(l1, l5) ) # true
println( isparallel(l1, l6) ) # true

println(" xint=$(xint(l1)), yint=$(yint(l1)), slope=$(slope(l1)), invslope=$(invslope(l1))" )
println(" xint=$(xint(l2)), yint=$(yint(l2)), slope=$(slope(l2)), invslope=$(invslope(l2))" )
println(" xint=$(xint(l3)), yint=$(yint(l3)), slope=$(slope(l3)), invslope=$(invslope(l3))" )
println(" xint=$(xint(l4)), yint=$(yint(l4)), slope=$(slope(l4)), invslope=$(invslope(l4))" )
println(" xint=$(xint(l5)), yint=$(yint(l5)), slope=$(slope(l5)), invslope=$(invslope(l5))" )
println(" xint=$(xint(l6)), yint=$(yint(l6)), slope=$(slope(l6)), invslope=$(invslope(l6))" )
println(" xint=$(xint(l7)), yint=$(yint(l7)), slope=$(slope(l7)), invslope=$(invslope(l7))" )
println(" xint=$(xint(l8)), yint=$(yint(l8)), slope=$(slope(l8)), invslope=$(invslope(l8))" )

figure(20)
hold(false)
plot(0,0)
hold(true)
b = Bounds(1.5, 0, 0, 1.5)
plot(l1;color="red", bounds=b) 
plot(l2; label="line2", color="blue", linestyle="--", bounds=b)
plot(l3; label="line3", color="green", linestyle=":", bounds=b)
plot(l4; label="line4", color="yellow", bounds=b)
plot(l5; label="line5", color="orange", bounds=b)
plot(l6; label="line6", color="brown", bounds=b)
# plot(l7; label="line7", color="black", bounds=b)
plot(l8; label="line8", color="cyan", bounds=b)
plot(Line(Point(1.5, 1), pi/2); label="edgeline", linestyle="-.",  color="blue", bounds=b)
plot(Line(Point(1, 0), 0); label="edgeline", linestyle="-.", color="blue", bounds=b)
axis([-1.2, 2.2, -1.2, 2.2])
# axis("equal")
legend(loc="lower left")
grid(true)

figure(21)
hold(false)
plot(0,0)
hold(true)
b = Bounds(2, 0, -1, 2)
plot(l1; label="line1", color="blue", bounds=b)
d,ps = distance(p1, l1)
plot(Segment(p1,ps); label="nearest", color="red")
println("distance from p1 to l1 = $d")
@assert abs(d-sqrt(2)/2) < 1.0e-12

d,ps = distance(Point(-1,0.5), l1)
plot(Segment(Point(-1,0.5),ps); label="nearest", color="red")
println("distance from (-1,0.5) to l1 = $d")

d,ps = distance(Point(0.5,1.8), l1)
plot(Segment(Point(0.5,1.8),ps); label="nearest", color="red")
println("distance from (0.5,1.8) to l1 = $d")

d,ps = distance(Point(-0.5,1.5), l1)
plot(Segment(Point(-0.5,1.5),ps); label="nearest", color="red")
println("distance from (-0.5,1.5) to l1 = $d")

d,ps = distance(Point(0.8,1.2), l1)
plot(Segment(Point(0.8,1.2),ps); label="nearest", color="red")
println("distance from (0.8,1.2) to l1 = $d")

plot(l0; label="line0", color="green", bounds=b)
d,ps = distance(p3, l0)
plot(Segment(p3,ps); label="nearest", color="red")
println("distance from p3 to l0 = $d")
@assert abs(d-1.0/2.0) < 1.0e-12

plot(la; label="line0", color="magenta", bounds=b)
d,ps = distance(p3, la)
plot(Segment(p3,ps); label="nearest", color="red")
println("distance from p3 to la = $d")
@assert abs(d-1.0/3.0) < 1.0e-12

axis([-1.2, 2.2, -1.2, 2.2])
grid(true)



figure(22)
hold(false)
plot(0,0)
hold(true)
b = Bounds(2, 0, -1, 2)
l_test = Line( Point(0.60,0.56), pi/3.2)
plot(l_test; label="line1", color="blue", bounds=b)
for i=1:30
    p_test = Point(rand(), rand())
    d,ps = distance(p_test, l_test)
    plot(Segment(p_test,ps); label="nearest", color="red")
end
axis([-1.2, 2.2, -1.2, 2.2])
grid(true) 



#######################################
# set up Rays and test them
r1 = Ray(p1, Vect(1,2))
r2 = Ray(p1, Vect(1,-0.5))
r3 = Ray(p3, Vect(-1//2, -1//2))

figure(23) 
hold(false)
plot(0,0)
hold(true)
plot(p1; color="blue", marker="o")
plot(p3; color="magenta", marker="o")
b = Bounds(2,-1,-1,2)
plot(r1; label="ray1", color="blue", bounds=b)
plot(r2; label="ray2", color="green", bounds=b)
plot(r3; label="ray3", color="magenta", bounds=b)

d,ps = distance(Point(0.8,1.2), r1)
plot(Segment(Point(0.8,1.2),ps); label="nearest", color="red", linestyle="-", marker="o")
println("distance from (0.8,1.2) to r1 = $d")

d,ps = distance(Point(-0.5,-0.5), r1)
plot(Segment(Point(-0.5,-0.5),ps); label="nearest", color="red", linestyle="-", marker="o")
println("distance from (-0.5,-0.5) to r1 = $d")

d,ps = distance(Point(0.5,1.5), r1)
plot(Segment(Point(0.5,1.5),ps); label="nearest", color="red", linestyle="-", marker="o")
println("distance from (0.5,1.5) to r1 = $d")

d,ps = distance(Point(1,1), r1)
plot(Segment(Point(1,1),ps); label="nearest", color="red", linestyle="-", marker="o")
println("distance from (1,1) to r1 = $d")

d,ps = distance(Point(0.5,-0.5), r1)
plot(Segment(Point(0.5,-0.5),ps); label="nearest", color="red", linestyle="-", marker="o")
println("distance from (0.5,-0.5) to r1 = $d")

d,ps = distance(Point(0.75,0.5), r2)
plot(Segment(Point(0.75,0.5),ps); label="nearest", color="red", linestyle="-", marker="o")
println("distance from (0.75,0.5) to r2 = $d")

d,ps = distance(Point(-0.5,0.5), r3)
plot(Segment(Point(-0.5,0.5),ps); label="nearest", color="red", linestyle="-", marker="o")
println("distance from (-0.5,0.5) to r3 = $d")

d,ps = distance(Point(-0.25,0.5), r3)
plot(Segment(Point(-0.25,0.5),ps); label="nearest", color="red", linestyle="-", marker="o")
println("distance from (-0.25,0.5) to r3 = $d")
 
d,ps = distance(Point(1.25,0.5), r3)
plot(Segment(Point(1.25,0.5),ps); label="nearest", color="red", linestyle="-", marker="o")
println("distance from (1.25,0.5) to r3 = $d")
 
axis([-1.2, 2.2, -1.2, 2.2])
# legend()
grid(true)

# test "isin"


##########################################3
# set up Segments and test them
s1 = Segment(p1, p2)
s2 = Segment(p2, p1)
s3 = Segment(p3, p1)
s4 = Segment(p3, p2)
err5 = 0;
try 
    s5 = Segment(p1, p4)
catch err5
end
s5 = SegmentRand()

figure(25)
plot(s1; marker="o", color="red")
plot(s2; marker="o", color="green")
plot(s3; marker="o", color="blue")
plot(s4; marker="o", color="yellow")
plot(s5; marker="o", color="orange")

figure(26)
hold(false)
plot(0,0)
hold(true)
b = Bounds(2, 0, -1, 2)
l_test = Segment( Point(0.33,0.7), Point(0.68, 0.22))
plot(l_test; label="line1", color="blue", bounds=b)
for i=1:40
    p_test = Point(rand(), rand())
    d,ps = distance(p_test, l_test)
    plot(Segment(p_test,ps); label="nearest", color="red")
end
axis([-.2, 1.2, -.2, 1.2])
grid(true) 


###########################################
# 

# test inclusion algorithms
println(  isin( Point(0,1), Line(1,5) ) )             # true
println(  isin( Point(0.0,1.0), Line(1.0,5.0) ) )     # true
println(  isin( Point(0,1), Line(1.0,5.0) ) )         # true
println(  isin( Point(eps(),1), Line(1.0,5.0) ) )     # true
println(  isin( Point(0.0000001,1), Line(1.0,5.0) ) ) # false

# test intersections algorithms
i12,p12 = intersection(l1, l2)
i34,p34 = intersection(l3, l4)
i16,p16 = intersection(l1, l6)

