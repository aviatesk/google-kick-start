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

function solve(N, K, P, M)
    cumsum!(M, M; dims = 2)
    prev = cur = [M[1,min(p,K)] for p = 1:P] # init with n = 1 case
    for n = 2:N
        prev = cur[:]
        # NOTE: don't think p = 0 case for simplicity since it's never optimal case
        for p = 1:P
            cur[p] = prev[p] # x = 0 case
            for x = 1:(p-1)
                cur[p] = max(cur[p], M[n,min(x,K)] + prev[p-x])
            end
            cur[p] = max(cur[p], M[n,min(p,K)]) # x = p case
        end
    end
    return cur[P]
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
