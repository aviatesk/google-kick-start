# %% constants & libraries
# ------------------------

# %% body
# -------

function main(io = stdin)
    readto(target = '\n') = readuntil(io, target)
    readnum(T::Type{<:Number} = Int; dlm = isspace, kwargs...) =
        parse.(T, split(readto(), dlm; kwargs...))::Vector{T}

    T, = readnum()
    for t = 1:T
        # handle IO and solve
        W, N = readnum()
        X = readnum()
        ret = solve(W, N, X)
        println(stdout, "Case #$(t): ", ret)
    end
end

# brute force
solve(W, N, X) = minimum(compute_steps(N, X, y) for y in X)

compute_steps(N, X, y) = sum(x ≤ y ? min(y-x, N-y+x) : min(x-y, N+y-x) for x in X)

@static if @isdefined(Juno) || @isdefined(VSCodeServer)
    main(open(replace(@__FILE__, r"(.+)\.jl" => s"\1.in")))
else
    main()
end
