# utils
# ----

readnum(io = stdin, T::Type{<:Number} = Int) = parse(T, readline(io))
readarray(io = stdin, T::Type{<:Number} = Int, dlm = isspace; kwargs...) =
    parse.(T, split(readline(io), dlm; kwargs...))

function bitsearch(n::T) where {T<:Integer}
    ret = Array{Vector{T}}(undef, 1<<n)
    s = one(T)
    for bit = s:s<<n
        is = Vector{T}()
        for i = s:n
            bit & s<<(i - s) !== zero(T) && push!(is, i)
        end
        ret[bit] = is
    end
    ret
end

# body
# ----

function main(io = stdin)
    T = readnum(io)
    for t = 1:T
        N, S = readarray(io)
        A = Array{Vector{Int}}(undef, N)
        for i = 1:N
            A[i] = readarray(io)
        end
        ret = solve(N, A)
        println(stdout, "Case #$(t): ", ret)
    end
end

function solve(N, A)
    # NOTE:
    # Dict{Set{Int}, Int} would cause memory limit error, and so we should
    # use primitive type `UInt64` via `hash` function
    memo = Dict{UInt64, Int}()
    for Ai in A
        Ci = Ai[1]
        Aij = Ai[2:end]
        inds = bitsearch(Ci)
        for ind in inds
            h = hash(Set(Aij[ind]))
            memo[h] = get!(memo, h, 0) + 1
        end
    end

    sum(N - memo[hash(Set(Ai[2:end]))] for Ai in A)
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
