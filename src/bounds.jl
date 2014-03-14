export Bounds

export isin, convert, displayPath, quantise, isequal, bounded, closed

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
function Bounds{T<:Number}(P::Array{Point{T}})
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

# create bounds outside a set of bounds, quantised onto a grid
function quantise(b::Bounds, x::Number)
    top    = ceil( b.top   /x) * x
    bottom = floor(b.bottom/x) * x
    left   = floor(b.left  /x) * x
    right  = ceil( b.right /x) * x

    return Bounds(top, bottom, left, right)
end

# create bounds outside a set of bounds, quantised onto a grid, which is offset
function quantise(b::Bounds, x::Number, offset::Number)
    top    = ceil( (b.top    - offset)/x) * x + offset
    bottom = floor((b.bottom - offset)/x) * x + offset
    left   = floor((b.left   - offset)/x) * x + offset
    right  = ceil( (b.right  - offset)/x) * x + offset

    return Bounds(top, bottom, left, right)
end

# utility functions
isequal(b1::Bounds, b2::Bounds) = b1.top==b2.top && b1.bottomw==b2.bottom && b1.left==b2.left && b1.right==b2.right
bounded(::Bounds) = true
closed(::Bounds) = true

# function for plotting
function displayPath(b::Bounds)
    p = Polygon(b)
    return p.points
end
