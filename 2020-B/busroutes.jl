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
        N,D = readnum()
        X = readnum()
        ret = solve(N,D,X)
        println(stdout, "Case #$(t): ", ret)
    end
end

@inbounds function solve(N, D, X)
    for i in N:-1:1
        D -= D % X[i]
    end
    return D
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
