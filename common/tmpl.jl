# %% common
# ---------

# %% body
# -------

function main(io::IO = stdin)
    readnum = let io = io
        (T::Type{<:Number} = Int; dlm = isspace, kwargs...) ->
            parse.(T, split(readline(io), dlm; kwargs...))
    end

    T, = readnum()
    for t = 1:T
        # ...
        ret = solve()
        println(stdout, "Case #$(t): ", ret)
    end
end

function solve()
    # ...
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
