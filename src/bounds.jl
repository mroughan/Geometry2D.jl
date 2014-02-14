export Bounds


#################################################################
# Bounds

immutable Bounds{T<:Number} <: G2dSimpleObject
    top::T
    bottom::T
    left::T
    right::T

    function Bounds( top::T, bottom::T, left::T, right::T)
        if (top < bottom)
            error("top must not be < bottom")
        end
        if (right < left)
            error("right must not be < left")
        end
        return new(top, bottom, left, right)
    end
end
Bounds{T<:Number}(top::T, bottom::T, left::T, right::T) = Bounds{T}(top, bottom, left, right)
Bounds{T<:Number, S<:Number, U<:Number, V<:Number}(top::T, bottom::S, left::U, right::V) = Bounds(promote(top,bottom,left,right)...)
function Bounds(p1::Point, p2::Point)
    # two points define extremes of rectangle
    return new(p2.y, p1.y, p1.x, p2.x)
end
function Bounds(P::Array{Point})
    x = points_x(P)
    y = points_y(P)
    return Bounds(maximum(y), minimum(y), minimum(x), maximum(x))
end

# promotion rules


