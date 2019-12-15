# %% common
# ---------

# %% body
# -------

function main(io::IO = stdin)
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
    R = calcR(N, A)
    F = calcF(N, K, A, R)
    return F[N]
end

function calcR(N, A)
    R = zeros(Int, (N, N))
    for i = 1:N
        maxn = 0
        memo = Dict{Int, Int}()
        for j = i:N
            a = A[j]
            n = memo[a] = get!(memo, a, 0) + 1
            maxn = max(maxn, n)
            R[i, j] = (j - i + 1) - maxn
        end
    end
    return R
end

function calcF(N, K, A, R)
    F = R[1, 1:N-K]
    for k = 1:K
        newF = Int[0]
        for i in eachindex(F)
            m = minimum(F[j] + R[j+1, i+1] for j = 1:i)
            push!(newF, m)
        end
        F = newF
    end
    return F
end

# # NOTE: the below works only for visible testset, but more straightforward
# function solve(N, K, A)
#     minn = N
#
#     # bit brute force
#     # NOTE: shouldn't create O(2ᴺ) arrays that represent changed walls
#     for bit = 1:1<<N
#         k, n = gaps_and_changed(N, A, bit)
#         if k ≤ K && minn > n
#             minn = n
#         end
#     end
#
#     return minn
# end
#
# function gaps_and_changed(N, A, bit)
#     prev = 0 # 1 ≤ Aᵢ ≤ 1000
#     k = -1   # number height gaps: -1 offset for initial `prev` update
#     n′ = 0   # number of unchanged walls
#     for i = 1:N
#         if iszero(bit & 1<<(i-1))
#             n′ += 1
#             if prev !== (@inbounds a = A[i])
#                 k += 1
#                 prev = a
#             end
#         end
#     end
#
#     return k, N - n′
# end

# %% call
# -------

if isdefined(Main, :Juno)
    let p = joinpath(@__DIR__, replace(basename(@__FILE__), r"(.+).jl" => s"\1.in"))
        open(f -> main(f), p)
    end
else
    main()
end
