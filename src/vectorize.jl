#
# vectorisation of common functions that apply over many types of objects
#    obviously the function only works if there is a scalara version of it for the type in question
#

# unary operators
for f in (:closed, :bounded, :area, :perimeter)
    @eval begin
        function ($f)(O::Array{G2dCompoundObject})
            return reshape( [($f)(O[i]) for i=1:length(O)], size(O) )
        end
    end
end

# binary operators
for f in (:isequal, )
    @eval begin
        function ($f)(O1::Array{G2dCompoundObject},O2::Array{G2dCompoundObject})
            if size(O1) != size(O2)
                error("arrays must be the same size")
            end
            return reshape( [($f)(O1[i],O2[i]) for i=1:length(O1)], size(O1) )
        end
    end
end

# point to object operators
for f in (:isin, :distance, )
    @eval begin
        function ($f)(p::Point,O::Array{G2dCompoundObject})
            return reshape( [($f)(p,O[i]) for i=1:length(O)], size(O) )
        end
        function ($f)(P::Array{Point},o::G2dCompoundObject)
            return reshape( [($f)(P[i],o) for i=1:length(P)], size(P) )
        end
        # may there should be a function that lets you put in a vector if each?
    end
end
