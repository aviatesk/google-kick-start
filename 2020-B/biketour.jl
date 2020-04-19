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
        N, = readnum()
        H = readnum()
        ret = solve(N, H)
        println(stdout, "Case #$(t): ", ret)
    end
end

function solve(N, H)
    d = diff(H)
    onpeek = false
    y = 0
    for di in d
        if di > 0
            onpeek = true
        elseif di === 0
            onpeek = false
        else
            onpeek && (y += 1)
            onpeek = false
        end
    end
    return y
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
