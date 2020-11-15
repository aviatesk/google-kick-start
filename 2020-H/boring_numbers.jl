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

solve(L, R) = count_boring(R) - count_boring(L - 1)

function count_boring(n)
    s = 0

    ks = parse.(Int, split(string(n), ""))
    kn = length(ks)

    for i in 1:kn-1
        s += 5^i
    end

    for (i, k) in enumerate(ks)
        n = count((isodd(i) ? isodd : iseven)(k′) for k′ in 0:(i==kn ? k : k-1))
        s += n * 5^(kn-i)
        (isodd(i) ? isodd : iseven)(k) || break
    end

    return s
end

@static if @isdefined(Juno) || @isdefined(VSCodeServer)
    main(open(replace(@__FILE__, r"(.+)\.jl" => s"\1.in")))
else
    main()
end
