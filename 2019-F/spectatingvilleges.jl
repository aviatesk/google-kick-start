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

    maxb = 0
    for mask in bitmasks(V)
        vs = Set(mask)
        for v in mask
            push!(vs, adj[v]...)
        end
        b = sum(B[collect(vs)])
        maxb = max(maxb, b)
    end

    return maxb
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
