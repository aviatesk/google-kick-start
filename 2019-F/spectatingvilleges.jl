# %% common
# ---------

"""
    bitsearch(f::Function, ary::AbstractVector)

Applies `f` for all the possible ``2^n`` sets of bit-masked elements in `ary`
(where ``n`` is the length of `ary`).

```julia
julia> bitsearch(1:2) do bit, mask
           @show bit, mask
       end
(bit, mask) = (1, [2])
(bit, mask) = (2, [1])
(bit, mask) = (3, Int64[])
(bit, mask) = (4, [1, 2])
```

!!! note
    When ``n`` isn't so small (e.g. ≥ 10), you may need to consider the cost of
    creating those ``2^n`` masks. Unwinding the two nested 2 `for` loops into an
    algorithm would help.
"""
function bitsearch(f::Function, ary::AbstractVector)
    for bit in 1:1<<length(ary)
        mask = [a for (i, a) in enumerate(ary) if iszero(bit & 1<<(i-1))]
        f(bit, mask)
    end
end

function bitmasks(ary::AbstractVector{T}) where {T}
    masks = Vector{Vector{T}}(undef, 2^length(ary))
    addmask! = let masks = masks
        (bit, mask) -> @inbounds masks[bit] = mask
    end
    bitsearch(addmask!, ary)
    return masks
end
bitmasks(n::T) where {T<:Integer} = bitmasks(one(T):n)

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

function main(io::IO = stdin)
    readnum = let io = io
        (T::Type{<:Number} = Int; dlm = isspace, kwargs...) ->
            parse.(T, split(readline(io), dlm; kwargs...))
    end

    T, = readnum()
    for t = 1:T
        V, = readnum()
        B = readnum()
        XY = [readnum() for _ in 1:V-1]
        ret = solve(V, B, XY)
        println(stdout, "Case #$(t): ", ret)
    end
end

function solve(V, B, XY)
    adj = adjacency_list(V, XY)

    bs = @generator for mask in bitmasks(V)
        vs = Set(mask)
        for v in mask
            push!(vs, adj[v]...)
        end
        sum(B[collect(vs)])
    end

    return max(0, maximum(bs))
end

function adjacency_list(V, XY)
    adj = [Int[] for _ in 1:V]
    for (Xi, Yi) in XY
        push!(adj[Xi], Yi)
        push!(adj[Yi], Xi)
    end
    return adj
end

# %% call
# -------

if isdefined(Main, :Juno)
    let p = joinpath(@__DIR__, replace(basename(@__FILE__), r"(.+).jl" => s"\1.in"))
        open(f -> main(f), p)
    end
else
    main()
end
