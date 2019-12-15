# %% common
# ---------

"""
    bitsearch(f::Function, ary::AbstractVector)

Applies `f` for all the possible ``2^n`` sets of bit-masked elements in `ary`
(where ``n`` is the length of `ary`).

```julia
jυλια> bitsearch(1:2) do bit, mask
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
        args = [a for (i, a) in enumerate(ary) if iszero(bit & 1<<(i-1))]
        f(bit, args)
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
        N, S = readnum()
        A = [readnum()[2:end] for i = 1:N]
        println(stdout, "Case #$(t): ", solve(N, A))
    end
end

function solve(N, A)
    # NOTE:
    # Dict{Set{Int}, Int} would cause memory limit error, and so we should
    # use primitive type `UInt64` via `hash` function
    memo = Dict{UInt64, Int}()
    for Ai in A
        for mask in bitmasks(Ai)
            h = hash(Set(mask))
            memo[h] = get!(memo, h, 0) + 1
        end
    end

    sum(N - memo[hash(Set(Ai))] for Ai in A)
end

# %% call
# -------

if isdefined(Main, :Juno)
    let f = splitpath(@__FILE__)[end]
        p = joinpath(@__DIR__, replace(f, r"(.+).jl" => s"\1.in"))
        open(f -> main(f), p)
    end
else
    main()
end
