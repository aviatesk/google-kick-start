# %% constants
# ------------

# %% body
# -------

function main(io = stdin)
    readnum = let io = io
        (T::Type{<:Number} = Int; dlm = isspace, kwargs...) ->
            parse.(T, split(readline(io), dlm; kwargs...))
    end

    T, = readnum()
    for t = 1:T
        R, C = readnum()
        M = Matrix{Char}(undef, R, C)
        for r in eachrow(M)
            r .= collect(readline(io))
        end
        ret = solve(R, C, M)
        println(stdout, "Case #$(t): ", ret)
    end
end

function solve(R, C, M)
    return -1
end

if isdefined(Main, :Juno)
    open(f -> main(f), replace(@__FILE__, r"(.+).jl" => s"\1.in"))
else
    main()
end
