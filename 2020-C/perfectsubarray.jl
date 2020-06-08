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
    NAs = [(readnum(), readnum()) for _ in 1:T]
    perfects = make_perfects(NAs)
    for (t, ((N,), A)) in enumerate(NAs)
        ret = solve(N, A, perfects)
        println(stdout, "Case #$(t): ", ret)
    end
end

@static @isdefined(Juno) && using Lazy

function make_perfects(NAs)::Set{Int}
    @static @isdefined(Lazy) && begin
    m = maximum(NAs) do (_,A)
        @>> A filter(>(0)) sum
    end
    return @>> Lazy.range(0) map(abs2) takewhile(≤(m)) Set
    end

    m = maximum(NAs) do (N,A)
        sum(filter(Ai->Ai>0, A))
    end
    n = 0
    perfects = Set()
    while (perfect = n^2) ≤ m
        push!(perfects, perfect)
        n += 1
    end
    return perfects
end

function solve(N, A, perfects)
    ret = 0
    @views for i in 1:N
        A′ = A[i:end]
        for s in accumulate(+, A′)
            s in perfects && (ret += 1)
        end
    end
    return ret
end

@static if @isdefined(Juno)
    open(f -> main(f), replace(@__FILE__, r"(.+).jl" => s"\1.in"))
else
    main()
end
