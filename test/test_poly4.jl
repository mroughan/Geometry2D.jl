#
# test polygon functions by showing the convergence of random polygons to an ellipse
#   "FROM RANDOM POLYGON TO ELLIPSE: AN EIGENANALYSIS"
#    ADAM N. ELMACHTOUB AND CHARLES F. VAN LOAN
#    www.cs.cornell.edu/cv/ResearchPDF/PolygonSmoothingPaper.pdf
#
# 
using Geometry2D
using PyPlot

srand(2)

m = 400
n = 30
poly = Array(Polygon{Float64}, m+1)
poly[1] = rand(Polygon, n)

figure(80)
hold(false)
plot(0,0)
hold(true)
plot(poly[1]; marker=".", color="blue")

k = 100
for i=1:m
    poly[i+1] = average(poly[i])
    if mod(i,k)==0 
        figure(80+(i-1)/k)
        plot(poly[i+1]; marker=".", color="red")

        figure(80+i/k)
        hold(false)
        plot(0,0)
        hold(true)
        plot(poly[i+1]; marker=".", color="blue")
    end
end





