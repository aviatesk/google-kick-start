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
        N, = readnum()
        A = readnum()
        ret = solve(N, A)
        println(stdout, "Case #$(t): ", ret)
    end
end

function solve(N, A)
    dA = diff(A)
    ret = 0
    cur = -1
    len = 0
    for dAi in dA
        if dAi != cur
            ret = max(ret, len + 1)
            len = 1
            cur = dAi
        else
            len += 1
        end
    end

    return max(ret, len + 1)
end

@static if @isdefined(Juno) || @isdefined(VSCodeServer)
    main(open(replace(@__FILE__, r"(.+)\.jl" => s"\1.in")))
else
    main()
end
