# %% constants
# ------------

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


# %% body
# -------

function main(io = stdin)
    readnum = let io = io
        (T::Type{<:Number} = Int; dlm = isspace, kwargs...) ->
            parse.(T, split(readline(io), dlm; kwargs...))
    end
    readto = let io = io
        (target = '\n'; kwargs...) -> readuntil(io, target; kwargs...)
    end

    T, = readnum()
    for t = 1:T
        N, Q = readnum()
        A = readnum()
        ops = [(readto(' ') == "Q", readnum()) for _ in 1:Q]
        ret = solve(N, Q, A, ops)
        println(stdout, "Case #$(t): ", ret)
    end
end

function solve(N, Q, A, ops)
    (@generator for (query, (l, r)) in ops
        if query
            (@generator for (i, Ai) in enumerate(@view A[l:r])
                isodd(i) ? (Ai * i) : -(Ai * i)
            end) |> sum
        else
            A[l] = r
            0
        end
    end) |> sum
end

if isdefined(Main, :Juno)
    open(f -> main(f), replace(@__FILE__, r"(.+).jl" => s"\1.in"))
else
    main()
end
