# %% constants & libraries
# ------------------------

# %% library docs
# ---------------

"""
    @collect [cond] ex

Constructs [`Array`](@ref) from lastly evaluated values from a `for` loop block that appears
  first within given `ex` expression.
If the optional `cond` expression is given, iterations  where the `cond` is `false` are
  effectively filtered out.

```julia-repl
julia> @collect isodd(i) for i = 1:3
           println("i = ", i); i
       end
i = 1
i = 3
2-element Array{Int64,1}:
 1
 3
```

See also: [`@generator`](@ref)
"""
macro collect end

"""
    @generator [cond] ex

Constructs [`Base.Generator`](@ref) from lastly evaluated values from a `for` loop block
  that appears first within given `ex` expression.
If the optional `cond` expression is given, iterations where the `cond` is `false` are
  effectively filtered out.

```julia-repl
julia> @generator isodd(i) for i = 1:3
           println("i = ", i); i
       end |> sum
i = 1
i = 3
4
```

See also: [`@collect`](@ref)
"""
macro generator end

"""
    bruteforcesearch(n::Integer, b::Integer = 2)
    bruteforcesearch(f::Function, n::Integer, b::Integer = 2)

Generates ``b^n`` brute force patterns.

!!! note
    By default (i.e. when `b == 2`), this function is equivalent to bit-brute-force search.

!!! warning
    `b` must be within the range that `string(; base = b)` is accepted, i.e. ``2 ≤ b ≤ 63``

```julia-repl
julia> for gen in bruteforcesearch(3)
           @show collect(gen)
       end
collect(gen) = [1, 1, 2]
collect(gen) = [1, 2, 1]
collect(gen) = [1, 2, 2]
collect(gen) = [2, 1, 1]
collect(gen) = [2, 1, 2]
collect(gen) = [2, 2, 1]
collect(gen) = [2, 2, 2]
collect(gen) = [1, 1, 1]

julia> bruteforcesearch(2, 3) do gen
           collect(gen)
       end |> collect
 9-element Vector{Vector{Int64}}:
 [1, 2]
 [1, 3]
 [2, 1]
 [2, 2]
 [2, 3]
 [3, 1]
 [3, 2]
 [3, 3]
 [1, 1]
```
"""
function bruteforcesearch end

# %% library body
# ---------------

function decompose_forblk(forblk)
    @assert Meta.isexpr(forblk, :for) "for block expression should be given"
    itrspec, body = forblk.args
    @assert Meta.isexpr(itrspec, :(=)) "invalid for loop specification"
    v, itr = itrspec.args
    return body, v, itr
end

function recompose_to_comprehension(forblk, cond = nothing; gen = false)
    body, v, itr = decompose_forblk(forblk)
    return isnothing(cond) ?
        esc(gen ? :(($body for $v in $itr)) : :([$body for $v in $itr])) :
        esc(gen ? :(($body for $v in $itr if $cond)) : :([$body for $v in $itr if $cond]))
end

function walk_and_transform(x, cond = nothing; gen = false)
    Meta.isexpr(x, :for) && return recompose_to_comprehension(x, cond; gen = gen), true
    x isa Expr || return x, false
    for (i, ex) in enumerate(x.args)
        ex, transformed = walk_and_transform(ex, cond; gen = gen)
        x.args[i] = ex
        transformed && return x, true # already transformed
    end
    return x, false
end

macro collect(ex) first(walk_and_transform(ex)) end
macro collect(cond, ex) first(walk_and_transform(ex, cond)) end

macro generator(ex) first(walk_and_transform(ex; gen = true)) end
macro generator(cond, ex) first(walk_and_transform(ex, cond; gen = true)) end

bruteforcesearch(n::Integer, base::Integer = 2) = bruteforcesearch(identity, n, base)
function bruteforcesearch(f::Function, n::Integer, base::Integer = 2)
    m = base^n

    return @generator for i = 1:m
        s = if i == m
            '0' ^ n # otherwise will be "100...000" (with length `n + 1`)
        else
            string(i; pad = n, base = base)
        end

        gen = @generator for c in s
            parse(Int, c; base = base) + 1 # for 1-based indexing
        end
        f(gen)
    end
end

# %% body
# -------

function main(io = stdin)
    readto(target = '\n') = readuntil(io, target)
    readnum(T::Type{<:Number} = Int; dlm = isspace, kwargs...) =
        parse.(T, split(readto(), dlm; kwargs...))::Vector{T}

    T, = readnum()
    for t = 1:T
        # handle IO and solve
        N, = readnum()
        ERs = [readnum() for _ in 1:N]
        ret = solve(N, ERs)
        println(stdout, "Case #$(t): ", join(ret, ' '))
    end
end

# OOP style
function solve_oop(N, ERs)
    inf = typemax(Int)
    retn, rettime = N, 0

    for bits in bruteforcesearch(N)
        ERs′ = [ER for (flg, ER) in zip(bits, ERs) if flg == 1]
        n = let len = length(ERs′)
            len == 0 && continue
            N - len
        end

        time = compute_time(ERs′)
        if isnothing(time)
            if rettime < inf
                retn = n
            elseif retn > n
                retn = n
            end
            rettime = inf
        else
            if rettime < time
                retn, rettime = n, time
            elseif rettime == time && retn > n
                retn = n
            end
        end
    end

    return retn, rettime == inf ? "INDEFINITELY" : string(rettime)
end

# v1.1 compat
Base.:(==)(a) = Base.Fix2(==, a)
Base.:(!=)(a) = Base.Fix2(!=, a)

# functional style
function solve(N, ERs)
    removal2time = @collect for bits in bruteforcesearch(N)
        ERs′ = [ER for (flg, ER) in zip(bits, ERs) if flg == 1]
        N - length(ERs′) => compute_time(ERs′)
    end

    filter!(!=(N) ∘ first, removal2time)

    infs = filter(isnothing ∘ last, removal2time)
    isempty(infs) || return first(findmin(first.(infs))), "INDEFINITELY"

    m = maximum(last, removal2time)
    maxs = filter(==(m) ∘ last, removal2time)
    return first(findmin(first.(maxs))), m
end

function compute_time(ERs)
    cur = s = sum(first.(ERs))
    for (Ei, Ri) in ERs
        (s - Ei) < Ri && return cur
        cur += Ei
    end

    return nothing
end

@static if @isdefined(Juno) || @isdefined(VSCodeServer)
    main(open(replace(@__FILE__, r"(.+)\.jl" => s"\1.in")))
else
    main()
end
