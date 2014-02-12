print("\n==========================================\n points \n")

# test the base constructors
p1 = Point(0,0)
p2 = Point(1.0,1.0)
p3 = Point(1//2, 2//3)

figure(10)
plot(p1; marker="o", color="red")
plot(p2; marker="o", color="green")
plot(p3; marker="o", color="blue")

# test promotion as part of constructors
p4 = Point(1, 1.0)
p5 = Point(2, 3//4)
p6 = Point(3.0, 2//3)
p7 = Point(convert(Uint32,2), convert(Uint16,3))
p8 = Point(convert(Uint32,2)//convert(Uint32,4), convert(Uint16,3))

# some tests of promotion of Points
dump(promote(p1,p2))
dump(promote(p1,p3))
dump(promote(p3,p2))
dump(promote(p7,p8))

# some tests of comparisons

# some tests of arithmetic
println( p2 - p1 )
println( p3 + p2 )
println( 2 + p4 )
println( 2 * p5 )
println( p6 / 3 )

# tests of various functions
