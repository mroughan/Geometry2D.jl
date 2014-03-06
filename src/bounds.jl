export Bounds

export isin, convert

export default_bounds

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
const default_bounds = Bounds(1,0, 0, 1)


# useful to have various functions, as if Bounds was an object
function isin(p::Point, b::Bounds; tolerance=1.0e-12)

    # see if the point is clearly outside
    if  p.y > b.top    + tolerance ||
        p.y < b.bottom - tolerance ||
        p.x < b.left   - tolerance ||
        p.x > b.right  + tolerance
        return false, false
    end

    # see if it is clearly inside
    if b.bottom + tolerance < p.y < b.top   - tolerance &&
       b.left   + tolerance < p.x < b.right - tolerance
        return true, false
    end

    # otherwise its near the edge
    return true, true
end
