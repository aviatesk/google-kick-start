# %% common
# ---------

# adapted:
# - from https://github.com/JuliaCollections/DataStructures.jl/blob/master/src/disjoint_set.jl#L152
# - by @aviatesk, 2019/12/17

# Disjoint sets

############################################################
#
#   A forest of disjoint sets of integers
#
#   Since each element is an integer, we can use arrays
#   instead of dictionary (for efficiency)
#
#   Disjoint sets over other key types can be implemented
#   based on an DisjointSets through a map from the key
#   to an integer index
#
############################################################

mutable struct DisjointSets
    parents::Vector{Int}
    ranks::Vector{Int}
    ngroups::Int

    # creates a disjoint set comprised of n singletons
    DisjointSets(n::Integer) = new(collect(1:n), zeros(Int, n), n)
end

Base.length(s::DisjointSets) = length(s.parents)
num_groups(s::DisjointSets) = s.ngroups
Base.eltype(::Type{DisjointSets}) = Int

# find the root element of the subset that contains x
# path compression is implemented here

function find_root_impl!(parents::Array{Int}, x::Integer)
    p = parents[x]
    @inbounds if parents[p] != p
        parents[x] = p = _find_root_impl!(parents, p)
    end
    p
end

# unsafe version of the above
function _find_root_impl!(parents::Array{Int}, x::Integer)
    @inbounds p = parents[x]
    @inbounds if parents[p] != p
        parents[x] = p = _find_root_impl!(parents, p)
    end
    p
end

find_root(s::DisjointSets, x::Integer) = find_root_impl!(s.parents, x)

"""
    is_in_same_set(s::DisjointSets, x::Integer, y::Integer)

Returns `true` if `x` and `y` belong to the same subset in `s` and `false` otherwise.
"""
is_in_same_set(s::DisjointSets, x::Integer, y::Integer) = find_root(s, x) == find_root(s, y)

# merge the subset containing x and that containing y into one
# and return the root of the new set.
function union!(s::DisjointSets, x::Integer, y::Integer)
    parents = s.parents
    xroot = find_root_impl!(parents, x)
    yroot = find_root_impl!(parents, y)
    xroot != yroot ?  root_union!(s, xroot, yroot) : xroot
end

# form a new set that is the union of the two sets whose root elements are
# x and y and return the root of the new set
# assume x ≠ y (unsafe)
function root_union!(s::DisjointSets, x::Integer, y::Integer)
    parents = s.parents
    rks = s.ranks
    @inbounds xrank = rks[x]
    @inbounds yrank = rks[y]

    if xrank < yrank
        x, y = y, x
    elseif xrank == yrank
        rks[x] += 1
    end
    @inbounds parents[y] = x
    @inbounds s.ngroups -= 1
    x
end

# make a new subset with an automatically chosen new element x
# returns the new element
#
function Base.push!(s::DisjointSets)
    x = length(s) + 1
    push!(s.parents, x)
    push!(s.ranks, 0)
    s.ngroups += 1
    return x
end

# %% body
# -------

function main(io::IO = stdin)
    readnum = let io = io
        (T::Type{<:Number} = Int; dlm = isspace, kwargs...) ->
            parse.(T, split(readline(io), dlm; kwargs...))
    end

    T, = readnum()
    for t = 1:T
        N, M = readnum()
        CD = Matrix{Int}(undef, (M, 2))
        for m in 1:M
            CD[m, :] = readnum()
        end
        ret = solve(N, M, CD)
        println(stdout, "Case #$(t): ", ret)
    end
end

function solve(N, M, CD)
    n = 0
    djs = DisjointSets(N)
    for (Cᵢ, Dᵢ) in eachrow(CD)
        if !is_in_same_set(djs, Cᵢ, Dᵢ)
            union!(djs, Cᵢ, Dᵢ)
            n += 1
        end
    end
    return n + 2(num_groups(djs) - 1)
end

# %% call
# -------

if isdefined(Main, :Juno)
    let p = joinpath(@__DIR__, replace(basename(@__FILE__), r"(.+).jl" => s"\1.in"))
        open(f -> main(f), p)
    end
else
    main()
end
