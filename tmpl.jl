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
        ret = solve()
        println(stdout, "Case #$(t): ", ret)
    end
end

function solve()
    # ...
end

@static if @isdefined(Juno) || @isdefined(VSCodeServer)
    main(open(replace(@__FILE__, r"(.+)\.jl" => s"\1.in")))
else
    main()
end
