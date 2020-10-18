# %% constants & libraries
# ------------------------

# %% body
# -------

function main(io = stdin)
    readto(target = '\n') = readuntil(io, target)
    readnum(T::Type{<:Number} = Int; dlm = isspace, kwargs...) =
        parse.(T, split(readto(), dlm; kwargs...))::Vector{T}

    T, = readnum()
    for t = 1:T
        # handle IO and solve
        ret = solve(readto())
        println(stdout, "Case #$(t): ", ret)
    end
end

function solve(s)
    ret = 0
    cnt = 0

    s′ = string(s, "JULIA") # dummy

    @inbounds for i in eachindex(s)
        if s′[i:i+3] == "KICK"
            cnt += 1
        elseif s′[i:i+4] == "START"
            ret += cnt
        end
    end

    return ret
end

@static if @isdefined(Juno) || @isdefined(VSCodeServer)
    main(open(replace(@__FILE__, r"(.+)\.jl" => s"\1.in")))
else
    main()
end
