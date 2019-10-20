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
        N, M = readarray()
        A = readarray() # N elements
        k = solve(N, M, A)
        println(stdout, "Case #$(t): $(k)")
    end
end

function solve(N, M, A)
    ret = -1
    for k = 0:127
        if sum(Ai ⊻ k for Ai in A) ≤ M
            ret = k
        end
    end
    ret
end

# call
# ----

main()
