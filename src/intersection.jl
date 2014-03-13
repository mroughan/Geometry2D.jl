
export intersection, edgeintersection
export RayOrSegment

#######################################################################
#  intersections of objects LINETYPES with LINETYPES

# intersection of lines
function intersection( line1::Line, line2::Line; tolerance=1.0e-12)
    #OUTPUTS: 
    #   intersect = 0 means segments don't intersect (i.e, they are parallel)
    #             = 1 means 1 intersection
    #             = 2 means they overlap (infinite intersections) 
    #   point     = the intersection point if it exists
    #                  if they don't intersect then return "nothing"
    #                  if they are the same, then return the Line
    if abs(line1.theta - line2.theta) < tolerance
        if distance2(line1.startpoint,line2.startpoint) < tolerance
            return 2, line1     # lines are the same
        else
            return 0, nothing   # lines are parallel
        end
    else
        A = [[cos(line1.theta) -cos(line2.theta)]
             [sin(line1.theta) -sin(line2.theta)]]
        b = [line2.startpoint.x - line1.startpoint.x,
             line2.startpoint.y - line1.startpoint.y,
             ]
        par = A \ b
        p1 = line1.startpoint + par[1]*Point(cos(line1.theta), sin(line1.theta))
        p2 = line2.startpoint + par[2]*Point(cos(line2.theta), sin(line2.theta))

        # println("p1 = $p1")
        # println("p2 = $p2")
        return 1, p1
    end
end

# intersections of rays
function intersection( r1::Ray, r2::Ray; tolerance=1.0e-12)
    #OUTPUTS: 
    #   intersect = 0 means segments don't intersect (i.e, they are parallel)
    #             = 1 means 1 intersection
    #             = 2 means they overlap (infinite intersections) 
    #   point     = the intersection point if it exists
    #                  if they don't intersect then return "nothing"
    #                  if they are the same, then return the Ray
    d1 = distance2(r1.startpoint, r2.startpoint)
    d2 = distance2(r1.direction, r2.direction)
    if d1 < tolerance
        if d2 < tolerance            
            return 2, r1
        else
            return 1, r1.startpoint
        end
    elseif isin(r1.startpoint, r2)[1]
        if d2 < tolerance
            return 2, r1
        else
            return 1, r1.startpoint
        end
    elseif isin(r2.startpoint, r1)[1]
        if d2 < tolerance
            return 2, r2
        else
            return 1, r2.startpoint
        end
    else
        # neither end-point is on the other ray, so they intersect cleanly, or don't at all
        l1 = convert(Line, r1)
        l2 = convert(Line, r2)
        I,p = intersection(l1,l2; tolerance=tolerance)
        if I==1
            # find out if p is on the rays
            if isin(p,r1; tolerance=tolerance)[1] && isin(p,r2; tolerance=tolerance)[1]
                return 1,p
            else
                return 0,nothing
            end
        elseif I>1
            error("this shouldn't happen given previous tests")
        else
            return 0,nothing
        end
    end
end

# intersection of segments
function intersection( s1::Segment, s2::Segment; tolerance=1.0e-12 )
    #OUTPUTS: 
    #   intersect = 0 means segments don't intersect
    #             = 1 means 1 intersection
    #             = 2 means they overlap (infinite intersections) 
    #             
    #   point     = the intersection point if it exists
    #                  if they don't intersect then return "nothing"
    #                  if the segments overlap then return the overlapping Segment
    #               note that for floating point calculations we could be a little more sophisticated
    #               about these tests, but at the moment just test equality with respect to tolerance
    
    # check the 4 possible end-point intersections
    d1 = distance2(s1.startpoint, s2.startpoint)
    d2 = distance2(s1.endpoint, s2.endpoint)
    if d1<tolerance && d2<tolerance
        return 2, s1
    elseif d1<tolerance
        return 1, s1.startpoint
    elseif d2<tolerance
        return 1, s1.endpoint
    end

    d12 = distance2(s1.startpoint, s2.endpoint)
    if d12 < tolerance
        return 1, s1.startpoint
    end

    d21 = distance2(s2.startpoint, s1.endpoint)
    if d21 < tolerance
        return 1, s2.startpoint
    end

    # now check if lines overlap
    l1 = convert(Line, s1)
    l2 = convert(Line, s2)
    I,p = intersection(l1,l2; tolerance=tolerance)
    if I==1
        # find out if p is on the segments
        if isin(p,s1; tolerance=tolerance)[1] && isin(p,s2; tolerance=tolerance)[1]
            return 1,p
        else
            return 0,nothing
        end
    elseif I>1
        error("this shouldn't happen given previous tests")
    else
        return 0,nothing
    end
end


# intersection of rays with segments
function intersection( s::Segment, r::Ray; tolerance=1.0e-12 )
    #OUTPUTS: 
    #   intersect = 0 means segments don't intersect
    #             = 1 means 1 intersection
    #             = 2 means they overlap (infinite intersections) 
    #             
    #   point     = the intersection point if it exists
    #                  if they don't intersect then return "nothing"
    #                  if the segments overlap then return the overlapping Segment
    #               note that for floating point calculations we could be a little more sophisticated
    #               about these tests, but at the moment just test equality with respect to tolerance

    r1 = convert(Ray, s)
    r2 = Ray( s.endpoint, s.startpoint-s.endpoint)

    I1,p1 = intersection(r1, r; tolerance=tolerance)
    I2,p2 = intersection(r2, r; tolerance=tolerance)
    
    # what if they overlap
    if I1==2 && I2==2
        if isin(s.startpoint, r; tolerance=tolerance)[1] && isin(s.endpoint, r)[1]
            return 2, s
        elseif isin(s.startpoint, r; tolerance=tolerance)[1]
            return 2, Segment(r.startpoint, s.startpoint)
        elseif isin(s.endpoint, r; tolerance=tolerance)[1]
            return 2, Segment(r.startpoint, s.endpoint)
        else
            error("this case shouldn't happen")
        end
    elseif I1==2
        return 0, nothing
    elseif I2==2
        return 0, nothing
    end

    # normal intersections
    if I1==1 && I2==1
        return 1, p1
    else
        return 0, nothing
    end
end
intersection( r::Ray, s::Segment; tolerance=1.0e-12 ) =  intersection( s, r; tolerance=tolerance )

# intersection of lines with segments or Rays
RayOrSegment = Union(Ray, Segment)
function intersection( s::RayOrSegment, l::Line; tolerance=1.0e-12 )
    #OUTPUTS: 
    #   intersect = 0 means no intersection
    #             = 1 means 1 intersection
    #             = 2 means they overlap (infinite intersections) 
    #             
    #   point     = the intersection point if it exists
    #                  if they don't intersect then return "nothing"
    #                  if they overlap, return overlapping part
    #               note that for floating point calculations we could be a little more sophisticated
    #               about these tests, but at the moment just test equality with respect to tolerance

    sl = convert(Line, s)
    I,p = intersection(sl, l; tolerance=tolerance)
    # what if they overlap
    if I==2
        return 2, s
    elseif I==1
        if isin(p, s; tolerance=tolerance)[1]
            return 1, p
        else
            return 0, nothing
        end
    elseif I==0
        return 0, nothing
    end
end
intersection( l::Line, s::RayOrSegment; tolerance=1.0e-12 ) =  intersection( s, l; tolerance=tolerance )


#######################################################################
#  intersections of objects edges with LINETYPES

# intersections with line and circles
function edgeintersection(c::Circle, l::LINETYPE; tolerance=1.0e-12)
    line = convert(Line, l)
    if abs(line.theta - pi/2.0) < tolerance || abs(line.theta + pi/2.0) < tolerance
        # nearly vertical line
        z = line.startpoint.x - c.center.x
        if abs(z) - c.radius > tolerance
            p = []
        elseif abs(z) - c.radius > -tolerance
            p = [ Point(line.startpoint.x, c.center.y) ]
        else
            y = sqrt(c.radius*c.radius - z*z)
            p = [Point(line.startpoint.x, c.center.y - y), 
                 Point(line.startpoint.x, c.center.y + y) ]
        end
    else
        m = tan(line.theta)
        m2 = m*m
        r2 = c.radius * c.radius

        # translate the problem back so that line.startpoint is the origin
        tmp = line.startpoint
        c -= tmp
        line -= tmp

        # check discriminant of quadratic problem to see how many solutions
        A = (1 + m2)
        Bd = -(c.center.x + m*c.center.y)
        C = c.center.x*c.center.x + c.center.y*c.center.y - r2
        D = (Bd*Bd - A*C)
        if D > tolerance
            # two solutions
            x1 = ( -Bd - sqrt(D)) / A
            x2 = ( -Bd + sqrt(D)) / A
            y1 = m*x1
            y2 = m*x2
            p = tmp + [Point(x1,y1), Point(x2,y2)]
        elseif D > -tolerance
            # one solution
            x = -Bd / A
            y = m*x
            p = tmp + [Point(x,y)]
        else
            # no solutions
            p = []
        end

    end
    # check intersection points are on the original object
    p2 = []
    for i=1:length(p)
        I,E = isin(p[i], l)
        if I
            p2 = [p2, p[i]]
        end
    end
    return p2
end
edgeintersection(l::LINETYPE, c::Circle; tolerance=1.0e-12) = edgeintersection(c, l; tolerance=tolerance)


function edgeintersection{T<:Number}( l::LINETYPE, poly::Polygon{T}; tolerance=1.0e-12)
    #OUTPUTS: 
    #   points    = an array (possibly empty) of intersection points sorted in order along the ray
    #  
    
    # look for intersections which each edge
    n = length(poly)
    p = Array(Point{T},0) 
    for i=1:n
        s = edge(poly, i) 
        I,pi = intersection( l, s ; tolerance=tolerance ) 
        if I==1
            p = [p, pi]
        elseif I==2
            # include end points, if appropriate
            if !(typeof(l)<:Line) && isin(l.startpoint, s)[1]
                p = [p, l.startpoint]
            end
            if typeof(l)<:Segment && isin(l.endpoint, s)[1]
                p = [p, l.endpoint]
            end
            if isin(s.startpoint, l)[1]
                p = [p, s.startpoint]
            end
            if isin(s.endpoint, l)[1]
                p = [p, s.endpoint]
            end
        end
    end 
    
    # convert them to parametric form, and sort (in order along the ray)
    if length(p) == 0
        return []
    end
    q = (p - l.startpoint)
    thetas = Array(Float64, length(q))
    s = Array(Float64, length(q))
    for i=1:length(q)
        thetas[i], s[i] = polar(q[i])
    end
    # println("q = $q, thetas=$thetas, s=$s")
  
    order = sortperm(s)
    s = s[order]
    thetas = thetas[order] 
    
    # remove repeated points
    i=1
    while i<length(s) 
        if  abs(s[i]-s[i+1]) < tolerance
            splice!(s, i+1) 
            splice!(thetas, i+1) 
       else
            i+=1
        end
    end
 
    # output the results as an array of points
    return l.startpoint + PointArray( s.*cos(thetas), s.*sin(thetas) )
end
edgeintersection{T<:Number}(poly::Polygon{T}, l::LINETYPE; tolerance=1.0e-12) = edgeintersection(l, poly; tolerance=tolerance)

# edge intersections for others that can be obtained by converting to polygons (though there are more efficient ways maybe)
edgeintersection(l::LINETYPE, b::Bounds; tolerance=1.0e-12) = edgeintersection(l,Polygon(b); tolerance=tolerance)
edgeintersection(b::Bounds, l::LINETYPE; tolerance=1.0e-12) = edgeintersection(l,Polygon(b); tolerance=tolerance)
edgeintersection(l::LINETYPE, t::Triangle; tolerance=1.0e-12) = edgeintersection(l,Polygon(t); tolerance=tolerance)
edgeintersection(t::Triangle, l::LINETYPE; tolerance=1.0e-12) = edgeintersection(l,Polygon(t); tolerance=tolerance)



#######################################################################
#  intersections of objects edges with other objects

# circle-circle intersections
# see http://math.stackexchange.com/questions/256100/how-can-i-find-the-points-at-which-two-circles-intersect
# and http://mathworld.wolfram.com/Circle-CircleIntersection.html
function edgeintersection(c1::Circle, c2::Circle; tolerance=1.0e-12)
    d = distance(c1.center,c2.center)
    if c1 == c2
        error("The two input circles are the same")
    elseif d > c1.radius + c2.radius + tolerance
        # the two circles don't overlap at all
        return []
    elseif d < abs(c1.radius - c2.radius) - tolerance
        # one circle is entirely inside the other
        return []
    elseif d > c1.radius + c2.radius - tolerance
        # they just touch (exterior)
        tmp,p1,p2 = distance(c1, c2)
        return [ (p1+p2)/2 ]
    elseif d < abs(c1.radius - c2.radius) + tolerance
        # they just touch (interior)
        direction = (c2.center - c1.center) / d
        p = c2.center + sign(c1.radius - c2.radius) * direction * c2.radius
        return p
    else
        # proper intersection
        # transform so one circle is at origin, and line between them is x-axis
        l = Line(c1.center, c2.center)
        ca = rotate(c1-c1.center, -l.theta)
        cb = rotate(c2-c1.center, -l.theta)
        r2 = cb.radius*cb.radius
        R2 = ca.radius*ca.radius
        d = cb.center.x
        x = ( d*d - r2 + R2) / (2*d)
        y = sqrt( R2 - x*x )
        p1 = Point(x, y)
        p2 = Point(x,-y)
        return c1.center + [rotate(p1, l.theta), rotate(p2, l.theta)]
    end
end


#######################################################################
#  overlap-intersections of objects with LINETYPES

function intersection{T<:Number}( l::LINETYPE, poly::Polygon{T}; tolerance=1.0e-12)
    #OUTPUTS: 
    #   segments  = an array of line segments that overlap
    #  
    
    # look for intersections which each edge
    p = edgeintersection( l, poly; tolerance=tolerance)
    n = length(p)
    S = Array(Segment{T}, 0)
    if n >= 2 
        for i=1:n-1
            # see if the mid-point is in the polygon
            mid = (p[i]+p[i+1])/2.0
            I,E = isin(mid, poly; tolerance=tolerance)
            if I
                s = Segment{T}(convert(Point{T},p[i]),convert(Point{T},p[i+1])) 
                S = [S, s]
            end 
        end
    end
    return S
end
intersection{T<:Number}(poly::Polygon{T}, l::LINETYPE; tolerance=1.0e-12) = intersection( l, poly; tolerance=1.0e-12)

function intersection( l::LINETYPE, c::Circle; tolerance=1.0e-12)
    #OUTPUTS: 
    #   segments  = an array of line segments that overlap
    #  
    
    # look for intersections which each edge
    p = edgeintersection( l, c; tolerance=tolerance)
    n = length(p)
    if n == 2 
        return [Segment(p[1], p[2])]
    else
        return []
    end
end
intersection(c::Circle, l::LINETYPE; tolerance=1.0e-12) = intersection( l, c; tolerance=1.0e-12)

# intersections for others that can be obtained by converting to polygons (though there are more efficient ways maybe)
intersection(l::LINETYPE, b::Bounds; tolerance=1.0e-12) = intersection(l,Polygon(b); tolerance=tolerance)
intersection(b::Bounds, l::LINETYPE; tolerance=1.0e-12) = intersection(l,Polygon(b); tolerance=tolerance)
intersection(l::LINETYPE, t::Triangle; tolerance=1.0e-12) = intersection(l,Polygon(t); tolerance=tolerance)
intersection(t::Triangle, l::LINETYPE; tolerance=1.0e-12) = intersection(l,Polygon(t); tolerance=tolerance)


