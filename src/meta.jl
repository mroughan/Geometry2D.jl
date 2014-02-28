#
# routines which are about the package itself
# 

export closed

# should write this using meta-programming rules, to extend to all functions that
#   only work on closed objects
function closed(c::Bool)
    if method_exists()

        if c
            # print a list of the closed objects
            
        else
            # print the not closed objects
            
        end

    else
        warn("Object $o doesn't have a closed function")
    end
end


## similar for bounded, ...

## similar for centroid????