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
        N, S = readarray(io)
        A = Array{Vector{Int}}(undef, N)
        for i = 1:N
            CA = readarray(io)
            A[i] = CA[2:end]
        end
        ret = solve(N, A)
        println(stdout, "Case #$(t): ", ret)
    end
end

function solve(N, A)
    ret = 0
    for i = 1:N, j = 1:N
        i === j && continue
        for Ai in A[i]
            if Ai ∉ A[j]
                ret += 1
                break
            end
        end
    end
    ret
end

# call
# ----

if isdefined(Main, :Juno)
    open("2019-F/_teachme.txt") do f
        main(f)
    end
else
    main()
end
