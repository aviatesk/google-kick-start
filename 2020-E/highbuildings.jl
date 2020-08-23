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
        N, A, B, C = readnum()
        ret = solve(N, A, B, C)
        println(stdout, "Case #$(t): ", ret)
    end
end

# brute force search
function solve(N, A, B, C)
    # special case `N == 1`
    if isone(N)
        A == B == C == 1 && return "1"
        return "IMPOSSIBLE"
    end
    
    for comb in bruteforcesearch(N, N)
        comb = collect(comb)
        satisfies(comb, N, A, B, C) && return join(comb, ' ')
    end
    return "IMPOSSIBLE"
end

function satisfies(comb::AbstractVector{T}, N, A, B, C) where T
    visibleA = Set{T}()
    height = 0
    for (i, b) in enumerate(comb)
        if height ≤ b
            push!(visibleA, i)
            height = b
        end
    end
    length(visibleA) == A || return false

    visibleB = Set{T}()
    height = 0
    for (i, b) in enumerate(reverse(comb))
        if height ≤ b
            push!(visibleB, N - i + 1)
            height = b
        end
    end
    length(visibleB) == B || return false

    length(intersect(visibleA, visibleB)) == C || return false

    return true
end

@static if @isdefined(Juno) || @isdefined(VSCodeServer)
    main(open(replace(@__FILE__, r"(.+)\.jl" => s"\1.in")))
else
    main()
end
