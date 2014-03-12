#
# vectorisation of common functions that apply over many types of objects
#    obviously the function only works if there is a scalara version of it for the type in question
#

# unary operators
for f in (:closed, :bounded, :area, :perimeter,)
    @eval begin
        function ($f){T<:G2dObject}(O::Array{T})
            return reshape( [($f)(O[i]) for i=1:length(O)], size(O) )
        end
    end
end

# functions that need varargs
for f in (:plot, :fill, )
    @eval begin
        function ($f){T<:G2dObject}(O::Array{T}; varargs...)
            return reshape( [($f)(O[i]; varargs...) for i=1:length(O)], size(O) )
        end
    end
end
# e.g., 
# plot{T<:G2dObject}(A::Array{T}; varargs...) = reshape( [plot(A[i]; varargs...) for i=1:length(A)], size(A) )


# binary operators
for f in (:isequal, )
    @eval begin
        function ($f){T<:G2dCompoundObject}(O1::Array{T}, O2::Array{T})
            if size(O1) != size(O2)
                error("arrays must be the same size")
            end
            return reshape( [($f)(O1[i],O2[i]) for i=1:length(O1)], size(O1) )
        end
    end
end

# point to object operators
for f in (:isin, :distance, :distance2 )
    @eval begin
        function ($f){S<:Number,T<:G2dCompoundObject}(p::Point{S},O::Array{T})
            return reshape( [($f)(p,O[i]) for i=1:length(O)], size(O) )
        end
        function ($f){S<:Number}(P::Array{Point{S}},o::G2dCompoundObject)
            return reshape( [($f)(P[i],o) for i=1:length(P)], size(P) )
        end
        # may there should be a function that lets you put in a vector if each?
    end
end

