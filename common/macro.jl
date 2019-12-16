function decompose_forblk(forblk)
    @assert forblk.head === :for "for block expression should be given"
    itrspec, body = forblk.args
    @assert itrspec.head === :(=) "invalid for loop specification"
    v, itr = itrspec.args
    return body, v, itr
end

function _collect(forblk)
    body, v, itr = decompose_forblk(forblk)
    return :([
        $(esc(body))
        for $(esc(v)) in $(esc(itr))
    ])
end
function _collect(cond, forblk)
    body, v, itr = decompose_forblk(forblk)
    return :([
        $(esc(body))
        for $(esc(v)) in $(esc(itr))
        if $(esc(cond))
    ])
end

"""
    @collect [cond] forblk

Constructs [`Array`](@ref) from lastly evaluated values within a given `for` loop block.
If the optional `cond` expression is given, values where the `cond` is `false`
are effectively filtered out.

```julia-repl
julia> @collect isodd(i) for i = 1:3
           println("i = ", i); i
       end
i = 1
i = 3
2-element Array{Int64,1}:
 1
 3
```

See also: [`@generator`](@ref)
"""
macro collect(exs...) _collect(exs...) end

function _generator(forblk)
    body, v, itr = decompose_forblk(forblk)
    return :((
        $(esc(body))
        for $(esc(v)) in $(esc(itr))
    ))
end
function _generator(cond, forblk)
    body, v, itr = decompose_forblk(forblk)
    return :((
        $(esc(body))
        for $(esc(v)) in $(esc(itr))
        if $(esc(cond))
    ))
end

"""
    @generator [cond] forblk

Constructs [`Base.Generator`](@ref) from a given `for` loop block.
If the optional `cond` expression is given, values where the `cond` is `false`
are effectively filtered out.

```julia-repl
julia> g = @generator isodd(i) for i = 1:3
           println("i = ", i); i
       end;

julia> sum(g)
i = 1
i = 3
4
```

See also: [`@collect`](@ref)
"""
macro generator(exs...) _generator(exs...) end

# # comparison example
# function forbench(n)
#     ret = 0
#     for i in 1:n-1
#         ret = max(ret, gcd(i,n))
#     end
#     return ret
# end
# function genbench(n)
#     g = @generator for i in 1:n-1
#         gcd(i,n)
#     end
#     return maximum(g)
# end
#
# using BenchmarkTools
# forbench(10)
# genbench(10)
# n = 1000000
# # should be almost same performance
# @btime forbench($n)
# @btime genbench($n)
