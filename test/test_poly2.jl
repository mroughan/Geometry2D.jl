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


