#=

### Limits

Time limit: 40 seconds per test set.
Memory limit: 1GB.
1 ≤ T ≤ 100.
1 ≤ P₁ < P₂ < ... < P_M ≤ N.
1 ≤ R_i ≤ N, for all i.

Test set 1 (Visible)
1 ≤ M ≤ N ≤ 1000.
1 ≤ Q ≤ 1000.

Test set 2 (Hidden)
1 ≤ M ≤ N ≤ 10⁵.
1 ≤ Q ≤ 10⁵.

### Input

T
N M Q
P... (M elements)
R... (Q elements)
...

### Sample case

3
11 1 2
8
2 3
11 11 11
1 2 3 4 5 6 7 8 9 10 11
1 2 3 4 5 6 7 8 9 10 11
1000 6 1
4 8 15 16 23 42
1

=#

# --- utils

readnum(type::Type{<:Number} = Int) = parse(type, readline())
readarray(type::Type{<:Number} = Int, dlm = isspace; kwargs...) =
    parse.(type, split(readline(), dlm; kwargs...))

# --- body

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

# --- call

main()
