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

# %% body
# -------

function main(io::IO = stdin)
    readnum = let io = io
        (T::Type{<:Number} = Int; dlm = isspace, kwargs...) ->
            parse.(T, split(readline(io), dlm; kwargs...))
    end

    T, = readnum()
    for t = 1:T
        N, K = readnum()
        A = readnum()
        ret = solve(N, K, A)
        println(stdout, "Case #$(t): ", ret)
    end
end

function solve(N, K, A)
    minn = N

    bitsearch(A) do bit, mask # i.e. walls to remain
        minn = update(minn, mask, N, K)
    end

    minn
end

function update(minn, mask, N, K)
    n = N - length(mask)
    if minn <= n
        return minn
    end

    prev = 0 # 1 ≤ Aᵢ ≤ 1000
    k = -1   # number height gaps: -1 offset for initial `prev` update
    for a in mask
        if prev !== a
            k += 1
            prev = a
        end

    end

    return k ≤ K ? n : minn
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
