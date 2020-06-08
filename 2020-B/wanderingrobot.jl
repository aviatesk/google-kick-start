# %% constants
# ------------

const p = 1/2

# %% body
# -------

function main(io = stdin)
    readnum(T::Type{<:Number} = Int; dlm = isspace, kwargs...) =
        parse.(T, split(readline(io), dlm; kwargs...))
    readto(target = '\n'; kwargs...) = readuntil(io, target; kwargs...)

    T, = readnum()
    for t = 1:T
        ret = solve(readnum()...)
        println(stdout, "Case #$(t): ", ret)
    end
end

# (L,U)
#       (R,D)
function solve(W, H, L, U, R, D)
    # f = ones(Float64, (H,W))
end

# TODO: horrible logic, ... refactor
function prob_to_return(W, H, col, row, prob = 1)
    row === 1 && col === 1 && return prob
    if row == 1
        H === 1 && return prob_to_return(W,H,row,col-1,prob)
        return prob_to_return(W,H,row,col-1,p*prob)
    elseif col === 1
        W === 1 && return prob_to_return(W,H,col,row-1,prob)
        return prob_to_return(W,H,col,row-1,p*prob)
    elseif col === W
        return prob_to_return(W,H,col,row-1,prob)
    elseif row === H
        return prob_to_return(W,H,row,col-1,prob)
    else
        return prob_to_return(W,H,col-1,row,p*prob) + prob_to_return(W,H,col,row-1,p*prob)
    end
end

@static if @isdefined(Juno)
    open(f -> main(f), replace(@__FILE__, r"(.+).jl" => s"\1.in"))
else
    main()
end
