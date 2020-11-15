# %% constants & libraries
# ------------------------

# %% body
# -------

using LightGraphs

function main(io = stdin)
    readto(target = '\n') = readuntil(io, target)
    readnum(T::Type{<:Number} = Int; dlm = isspace, kwargs...) =
        parse.(T, split(readto(), dlm; kwargs...))::Vector{T}

    T, = readnum()
    for t = 1:T
        N, Q = readnum()
        s = readto()
        names = split(s, ' ')
        queries = [readnum() for _ in 1:Q]
        ret = solve(N, Q, names, queries)
        println(stdout, "Case #$(t): ", ret)
    end
end

function solve(N::T, Q, names, queries) where {T}
    g = Graph(N)
    for i in 1:N
        for j in (i+1):N
            isempty(intersect(names[i], names[j])) || add_edge!(g, i, j)
        end
    end

    fws = floyd_warshall_shortest_paths(g)
    ans = map(queries) do (s, d)
        dist = fws.dists[s, d]
        dist == typemax(T) ? -1 : dist
    end
    return join(ans, ' ')
end

@static if @isdefined(Juno) || @isdefined(VSCodeServer)
    main(open(replace(@__FILE__, r"(.+)\.jl" => s"\1.in")))
else
    main()
end
