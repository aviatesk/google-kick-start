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
        N, B = readnum()
        A = readnum()
        ret = solve(A, B)
        println(stdout, "Case #$(t): ", ret)
    end
end

function solve(A, B)
    sort!(A)
    n = 0
    for Ai in A
        B -= Ai
        B < 0 && return n
        n += 1
    end
    return n
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
