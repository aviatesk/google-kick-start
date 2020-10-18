# %% constants & libraries
# ------------------------

# %% body
# -------

using LinearAlgebra

function main(io = stdin)
    readto(target = '\n') = readuntil(io, target)
    readnum(T::Type{<:Number} = Int; dlm = isspace, kwargs...) =
        parse.(T, split(readto(), dlm; kwargs...))::Vector{T}

    T, = readnum()
    for t = 1:T
        # handle IO and solve
        N, = readnum()
        M = Matrix{Int}(undef, N, N)
        for i in 1:N
            M[i, :] = readnum()
        end
        ret = solve(N, M)
        println(stdout, "Case #$(t): ", ret)
    end
end

@inbounds solve(N, M) = maximum(sum(M[diagind(M, k)]) for k in -N:N)

@static if @isdefined(Juno) || @isdefined(VSCodeServer)
    main(open(replace(@__FILE__, r"(.+)\.jl" => s"\1.in")))
else
    main()
end
