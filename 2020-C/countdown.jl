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
    for t = 1:T
        N, K = readnum()
        A = readnum()
        ret = solve(N, K, A)
        println(stdout, "Case #$(t): ", ret)
    end
end

function solve(N, K, A)
    ret = 0
    count = K
    for Ai in A
        if Ai === count
            if count === 1
                ret += 1
                count = K
            else
                count -= 1
            end
        else
            count = K
            Ai === K && (count -= 1)
        end
    end
    return ret
end

if isdefined(Main, :Juno)
    open(f -> main(f), replace(@__FILE__, r"(.+).jl" => s"\1.in"))
else
    main()
end

# WARNING: this problem is just frustrating ...
