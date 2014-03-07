using Geometry2D
using PyPlot

srand(1)

points1 = PointArrayRand(6)
poly1 = Polygon(points1) 

poly2 = PolygonRegular(6)

poly3 = PolygonRegular(12; center=Point(1,1), scale=2.0)

poly4 = Hexagon(; center=Point(2,1.5), scale=0.8)

figure(60)
hold(false)
plot(0,0)
hold(true)
plot(poly1; color="green")
plot(poly2; marker="s", color="blue")
plot(poly3; marker="d", color="red")
plot(poly4; marker="", color="magenta")

axis("equal")

#### test star polygons
#### compare to http://upload.wikimedia.org/wikipedia/commons/9/96/Regular_Star_Polygons.jpg

Schlafli = [[3 1],
            [4 1],
            [5 1],
            [5 2],
            [6 1],
            [6 2],
            [7 1],
            [7 2],
            [7 3],
            [8 1],
            [8 2],
            [8 3],
            [9 1],
            [9 2],
            [9 3],
            [9 4],
            [10 1],
            [10 2],
            [10 3],
            [10 4],
            [11 1],
            [11 2],
            [11 3],
            [11 4],
            [11 5],
            ]

figure(61) 
hold(false)
plot(0,0)
hold(true)
star =  PolygonStar(7,3)
for i=1:size(Schlafli,1)
    p = Point(1.5*(Schlafli[i,1]-2*Schlafli[i,2]-1),  3 - Schlafli[i,1] )
    star = PolygonStar(Schlafli[i,1], Schlafli[i,2]; center=p, scale=0.65, theta0=pi/2)
    for j=1:length(star); plot(star[j]; marker="", color="blue"); end
    text(p.x+0.4, p.y+0.3, @sprintf("(%d,%d)", Schlafli[i,1], Schlafli[i,2]))
end

axis("equal")


#### test simplified star polygons
figure(62) 
hold(false)
plot(0,0)
hold(true)
star1 = PolygonSimpleStar(7,3)
star2 = PolygonStar(7,3)
plot(star2[1]; linestyle=":", marker=".", color="red")
plot(star1; color="blue")

# for i=1:size(Schlafli,1)
#     p = Point(1.5*(Schlafli[i,1]-2*Schlafli[i,2]-1),  3 - Schlafli[i,1] )
#     star = PolygonSimpleStar(Schlafli[i,1], Schlafli[i,2]; center=p, scale=0.65, theta0=pi/2)
#     for j=1:length(star); plot(star[j]; marker="", color="blue"); end
#     text(p.x+0.4, p.y+0.3, @sprintf("(%d,%d)", Schlafli[i,1], Schlafli[i,2]))
# end

axis("equal")


figure(63) 
hold(false)
plot(0,0)
hold(true)
star = PolygonSimpleStar(7,3; center=Point(1.0,1.0))
for i=1:size(Schlafli,1)
    p = Point(1.5*(Schlafli[i,1]-2*Schlafli[i,2]-1),  3 - Schlafli[i,1] )
    star = PolygonSimpleStar(Schlafli[i,1], Schlafli[i,2]; center=p, scale=0.65, theta0=pi/2)
    plot(star; marker="", color="blue")
    text(p.x+0.4, p.y+0.3, @sprintf("(%d,%d)", Schlafli[i,1], Schlafli[i,2]))
end

axis("equal")



figure(64)
hold(false)
plot(0,0)
hold(true)
star1 = PolygonStar(7,3; center=Point(0.0,0.0))
star2 = PolygonSimpleStar(7,2; center=Point(1.0,1.0))
fill(star1[1]; label="star1", color="red")
fill(star2; label="star2", color="orange", alpha=0.5)
legend()
axis("equal")


figure(65)
hold(false)
plot(0,0)
hold(true)
star1 = PolygonStar(7,3; center=Point(0.0,0.0))
plot(star1[1]; label="star1", marker="", color="blue")

r1 = Ray(Point(-1,0.0), Point(1.0,0.0))  
p1 = edgeintersection( r1, star1[1])
println("p1 = $p1")
plot(r1; label="ray 1", color="green", bounds=Bounds(1, -1, -1, 1))
plot(p1; label="intersection points 1", color="red")
 
r2 = Ray(Point(-1,0.24), Point(1.0,1/3.0))  
p2 = edgeintersection(star1[1], r2)
println("p2 = $p2")
plot(r2; label="ray 2", color="green", bounds=Bounds(1, -1, -1, 1))
plot(p2; label="intersection points 2", color="red")

r3 = Ray(Point(-1,-0.24), Point(1.0,0.0))  
p3 = edgeintersection( r3, star1[1]; tolerance=1.0e-2)
println("p3 = $p3")
plot(r3; label="ray 3", color="green", bounds=Bounds(1, -1, -1, 1))
plot(p3; label="intersection points 3", color="red")
 
r4 = Segment(Point(-0.7,-0.6), Point(0.7,-0.5))  
p4 = edgeintersection( r4, star1[1]; tolerance=1.0e-2)
println("p4 = $p4")
plot(r4; label="segment 4", color="orange", bounds=Bounds(1, -1, -1, 1))
plot(p4; label="intersection points 4", color="red")
 
r5 = edge(star1[1], 1)
p5 = edgeintersection( r5, star1[1])
println("p5 = $p5")
plot(r5; label="segment 5", color="orange", bounds=Bounds(1, -1, -1, 1))
plot(p5; label="intersection points 5", color="blue", marker="x", markersize=12)

# legend()
axis("equal")


