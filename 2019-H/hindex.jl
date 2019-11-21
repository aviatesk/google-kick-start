# utils
# ----

readnum(io = stdin, T::Type{<:Number} = Int) = parse(T, readline(io))
readarray(io = stdin, T::Type{<:Number} = Int, dlm = isspace; kwargs...) =
    parse.(T, split(readline(io), dlm; kwargs...))

# body
# ----

function main(io = stdin)
    T = readnum(io)
    for t = 1:T
        N = readnum(io)
        A = readarray(io) # N elements
        hs = solve(N, A)
        println(stdout, "Case #$(t): $(join(hs, ' '))")
    end
end

function solve(N, A)
    ret = Vector{Int}(undef, N)
    memo = Dict{Int, Int}()
    ans = 0
    rm = 1
    size = 0

    for (i, a) in enumerate(A)
        if a > ans
            memo[a] = get!(memo, a, 0) + 1
            size += 1
        end

        for k in rm:ans
            size -= get!(memo, k, 0)
        end
        rm = ans + 1

        if size ≥ ans + 1
            ans += 1
        end

        ret[i] = ans
    end

    ret
end

# call
# ----

if isdefined(Main, :Juno)
    open("2019-H/_hindex.txt") do f
        main(f)
    end
else
    main()
end
