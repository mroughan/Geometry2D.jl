# test various functions related to circles
#
#
c1 = Circle(Point(1,1), 1.0)
@assert c1.center==Point(1,1)

figure(1)
# plot(c1, "r+")
h = plot(c1; color="red", linewidth=2, marker="+", linestyle="--")
legend()



