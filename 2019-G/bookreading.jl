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

function main()
    line = readline()
    T = parse(Int, line)
    for t = 1:T
        N, M, Q = map(n -> parse(Int, n), split(readline()))
        P = map(n -> parse(Int, n), split(readline())) # M elements
        R = map(n -> parse(Int, n), split(readline())) # Q elements
        pages = solve(N, P, R)
        println(stdout, "Case #$(t): $(pages)")
    end
end

function solve(N, P, R)
    pages = 0
    memo = Dict(n => 0 for n in 1:N)
    for p in P
        for d in divisors(p)
            memo[d] += 1
        end
    end
    for r in R
        pages += N ÷ r - memo[r]
    end
    pages
end

divisors(n) = [1, (i for i = 2:(n ÷ 2) if n % i === 0)..., n]

main()
