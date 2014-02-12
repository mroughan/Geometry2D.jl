# test various functions related to circles
#
#
c1 = Circle(Point(1,1), 1.0)
@assert c1.center==Point(1,1)

figure(12)
hold(false)
axis("equal")
# plot(c1, "r+")
h = plot(c1; color="red", linewidth=2, marker="+", linestyle="--")

a = Point(1,0.7)
b = Point(1.7,2)
c = Point(2.6,1)
c2 = Circle(a, b, c) 

figure(12)
hold(true)
plot(c2)
plot(a; color="magenta", marker="d")
plot(b; color="magenta", marker="d")
plot(c; color="magenta", marker="d")


legend()
