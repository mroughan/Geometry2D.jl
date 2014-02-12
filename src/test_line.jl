print("\n==========================================\n lines \n")

# some points to use below
p1 = Point(0,0)
p2 = Point(1.0,1.0)
p3 = Point(1//2, 2//3)
p4 = Point(0.0, 0.0)

# set up some example lines and test them
l1 = Line(1,1)
l2 = Line(1.0,1.0)
l3 = Line(1, 1.0)
l4 = Line(2//3, 1//1)
l5 = Line(p1,p2)
l6 = Line(p2,p3)
l7 = Line(Point(0,1), pi/4)
l8 = Line(Point(0.0,1.0), 1)

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

# set up Rays and test them

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

figure(11)
plot(s1; marker="o", color="red")
plot(s2; marker="o", color="green")
plot(s3; marker="o", color="blue")
plot(s4; marker="o", color="yellow")
plot(s5; marker="o", color="orange")

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
