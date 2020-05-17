# %% constants
# ------------

# %% body
# -------

function main(io = stdin)
    readnum(T::Type{<:Number} = Int; dlm = isspace, kwargs...) =
        parse.(T, split(readline(io), dlm; kwargs...))
    readto(target = '\n'; kwargs...) = readuntil(io, target; kwargs...)

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

if isdefined(Main, :Juno)
    open(f -> main(f), replace(@__FILE__, r"(.+).jl" => s"\1.in"))
else
    main()
end
