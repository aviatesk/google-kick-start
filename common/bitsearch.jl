"""
    bitsearch(f::Function, ary::AbstractVector)

Applies `f` for all the possible ``2^n`` sets of bit-masked elements in `ary`
(where ``n`` is the length of `ary`).

```julia
jυλια> bitsearch(1:2) do bit, mask
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
        args = [a for (i, a) in enumerate(ary) if iszero(bit & 1<<(i-1))]
        f(bit, args)
    end
end

function bitmasks(ary::AbstractVector{T}) where {T}
    masks = Vector{Vector{T}}(undef, 2^length(ary))
    addmask! = let masks = masks
        (bit, mask) -> @inbounds masks[bit] = mask
    end
    bitsearch(addmask!, ary)
    return masks
end
bitmasks(n::T) where {T<:Integer} = bitmasks(one(T):n)
