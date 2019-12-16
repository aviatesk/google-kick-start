"""
    bitsearch(f::Function, ary::AbstractVector)

Applies `f` for ``2^n`` arrays that represent all the possible bit-masked sets in
    `ary` (where ``n`` is the length of `ary`).

```julia
julia> bitsearch(1:2) do bit, mask
           @show bit, mask
       end
(bit, mask) = (1, [2])
(bit, mask) = (2, [1])
(bit, mask) = (3, Int64[])
(bit, mask) = (4, [1, 2])
```

!!! note
    When ``n`` isn't so small (e.g. ≥ 10), you may need to consider the cost of
    creating those ``2^n`` masks. Unwinding the two nested 2 `for` loops into an
    algorithm would help.
"""
function bitsearch(f::Function, ary::AbstractVector)
    for bit in 1:1<<length(ary)
        mask = [a for (i, a) in enumerate(ary) if iszero(bit & 1<<(i-1))]
        f(bit, mask)
    end
end

function bitmasks(ary::AbstractVector{T}) where {T}
    masks = Vector{Vector{T}}(undef, 2^length(ary))
    mask! = let masks = masks
        (bit, mask) -> @inbounds masks[bit] = mask
    end
    bitsearch(mask!, ary)
    return masks
end
bitmasks(n::T) where {T<:Integer} = bitmasks(one(T):n)
