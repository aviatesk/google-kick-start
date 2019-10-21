# TODO: hidden testset

# utils
# ----

readnum(type::Type{<:Number} = Int) = parse(type, readline())
readarray(type::Type{<:Number} = Int, dlm = isspace; kwargs...) =
    parse.(type, split(readline(), dlm; kwargs...))

# body
# ----

function main()
    T = readnum()
    for t = 1:T
        N, H = readarray()
        A = readarray() # N elements
        B = readarray() # N elements
        n = solve(N, H, A, B)
        println(stdout, "Case #$t: $n")
    end
end

function solve(N, H, A, B)
    n = 0
    for comb in combinations(1:3, N)
        HA = sum(c === 2 ? 0 : A[i] for (i, c) in enumerate(comb))
        HB = sum(c === 1 ? 0 : B[i] for (i, c) in enumerate(comb))

        if HA ≥ H && HB ≥ H
            n += 1
        end
    end
    n
end

# brute-force search
combinations(patterns::Itr, n::Int) where {Itr} =
    _combinations(patterns, n, Vector{Tuple{Vararg{eltype(patterns)}}}(), ())
# ref: https://discourse.julialang.org/t/splatting-arguments-causes-30x-slow-down/16964/2
function _combinations(patterns::Itr, n::Int, combs::Vector{Tuple{Vararg{T}}}, comb::Tuple{Vararg{T}}) where {Itr, T}
    if length(comb) === n
        push!(combs, comb)
    else
        for p in patterns
            _combinations(patterns, n, combs, (comb..., p))
        end
    end
    combs
end

# call
# ----

main()
