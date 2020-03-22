# %% common
# ---------

# %% body
# -------

function main(io = stdin)
    readnum = let io = io
        (T::Type{<:Number} = Int; dlm = isspace, kwargs...) ->
            parse.(T, split(readline(io), dlm; kwargs...))
    end

    T, = readnum()
    for t = 1:T
        # N: number of stacks
        # K: number of plates in a stack
        # P: how many platest Dr. Patel will pick
        N, K, P = readnum()
        M = Matrix{Int}(undef, N, K)
        for i in 1:N
            M[i,:] = readnum()
        end
        ret = solve(N, K, P, M)
        println(stdout, "Case #$(t): ", ret)
    end
end

# TODO: you're too slow, moron
function solve(N, K, P, M)
    cumsum!(M, M; dims = 2)
    function search(n, i, p = P, b = 0)
        n === N + 1 && return b
        (p -= i) < 0 && return b
        iszero(i) || (b += M[n,i])
        return maximum(i -> search(n+1, i, p, b), 0:K)
    end
    return maximum(i -> search(1, i), 0:K)
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
