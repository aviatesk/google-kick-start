"""
    @collect [cond] forblock

Constructs [`Array`](@ref) from lastly evaluated values within a given `for` loop block.
If the optional `cond` expression is given, values where the `cond` is `false`
are effectively filtered out.

```julia
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
macro collect(exs...)
    n = length(exs)
    @assert n === 1 || n === 2 "only 1 or 2 expressions are accepted"
    isif = n === 2
    ex = exs[end]
    @assert ex.head === :for "for block expression should be given"
    itrspec, body = ex.args
    @assert itrspec.head === :(=) || itrspec === :in "invalid for loop specification"
    v, itr = itrspec.args
    isif ? :([
        $(esc(body))
        for $(esc(v)) in $(esc(itr))
        if $(esc(exs[begin]))
    ]) : :([
        $(esc(body))
        for $(esc(v)) in $(esc(itr))
    ])
end

"""
    @generator [cond] forblock

Constructs [`Base.Generator`](@ref) from a given `for` loop block.
If the optional `cond` expression is given, values where the `cond` is `false`
are effectively filtered out.

```julia
julia> g = @generator isodd(i) for i = 1:3
           println("i = ", i); i
       end;

julia> collect(g)
i = 1
i = 3
2-element Array{Int64,1}:
 1
 3
```

See also: [`@collect`](@ref)
"""
macro generator(exs...)
    n = length(exs)
    @assert n === 1 || n === 2 "only 1 or 2 expressions are accepted"
    isif = n === 2
    ex = exs[end]
    @assert ex.head === :for "for block expression should be given"
    itrspec, body = ex.args
    @assert itrspec.head === :(=) "invalid for loop specification"
    v, itr = itrspec.args
    isif ? :((
        $(esc(body))
        for $(esc(v)) in $(esc(itr))
        if $(esc(exs[begin]))
    )) : :((
        $(esc(body))
        for $(esc(v)) in $(esc(itr))
    ))
end
