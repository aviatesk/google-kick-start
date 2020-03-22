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
        N, K = readnum()
        M = readnum() # NOTE: N integers
        ret = solve(N, K, M)
        println(stdout, "Case #$(t): ", ret)
    end
end

# TODO: this code assumes `K = 1`
function solve(N, K, M)
    d = sort!(diff(M); rev = true)
    return max(d[1] - (d[1] ÷ 2), length(d) === 1 ? 0 : d[2])
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
