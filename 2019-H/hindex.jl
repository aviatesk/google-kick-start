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
        N = readnum()
        A = readarray() # N elements
        hs = solve(N, A)
        println(stdout, "Case #$(t): $(join(hs, ' '))")
    end
end

function solve(N, A)
    [hindex(i, A[1:i]) for i = 1:N]
end

function hindex(n, A′)
    sort!(A′; rev = true)

    maxw = 0
    for (w, h) in enumerate(A′)
        if w ≤ h
            maxw = w
        end
    end
    maxw
end

# call
# ----

main()
