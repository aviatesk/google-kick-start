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
        N, M, Q = readarray()
        P = readarray() # M elements
        R = readarray() # Q elements
        pages = solve(N, P, R)
        println(stdout, "Case #$(t): $(pages)")
    end
end

function solve(N, P, R)
    memo = ones(Bool, N)
    for p in P
        memo[p] = false
    end
    pages = Dict(n => count(x -> memo[n*x], 1:(N÷n)) for n = 1:N)
    sum(ps[r] for r in R) # `pages` should be pre-computed, since R can be [1, 1, 1, ...]
end

# call
# ----

main()
