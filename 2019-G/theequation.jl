#=

### Limits

Time limit: 15 seconds per test set.
Memory limit: 1GB.
1 ≤ T ≤ 100.
1 ≤ N ≤ 1000.

Test set 1 (Visible)
0 ≤ M ≤ 100.
0 ≤ A_i ≤ 100, for all i.

Test set 2 (Hidden)
0 ≤ M ≤ 10^{15}.
0 ≤ A_i ≤ 10^{15}, for all i.


### Input

T
N M
A... (N elements)
...

### Sample case

4
3 27
8 2 4
4 45
30 0 4 11
1 0
100
6 2
5 5 1 5 1 0

=#

# ---

function main()
    T = parse(Int, readline())
    for t = 1:T
        N, M = map(n -> parse(Int, n), split(readline()))
        A = map(n -> parse(Int, n), split(readline()))
        k = solve(N, M, A)
        println(stdout, "Case #$(t): $(k)")
    end
end

function solve(N, M, A)
    ret = -1
    for k = 1:10000 # TODO: for hidden testset
        s = sum(k ⊻ Ai for Ai in A)
        s <= M && (ret = k)
    end
    ret
end

# ---

main()
