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
        L, R = readnum()
        ret = solve(L, R)
        println(stdout, "Case #$(t): ", ret)
    end
end

function solve(L, R)
    s = 0
    for n in L:R
        s += isboring(n)
    end
    return s
end

function isboring(n)
    ks = parse.(Int, split(string(n), ""))
    for (i,k) in enumerate(ks)
        isodd(i) ⊻ isodd(k) && return false
    end
    return true
end

@static if @isdefined(Juno) || @isdefined(VSCodeServer)
    main(open(replace(@__FILE__, r"(.+)\.jl" => s"\1.in")))
else
    main()
end
