# %% common
# ---------

# %% body
# -------

const p = 1/2

function main(io = stdin)
    readnum = let io = io
        (T::Type{<:Number} = Int; dlm = isspace, kwargs...) ->
            parse.(T, split(readline(io), dlm; kwargs...))
    end

    T, = readnum()
    for t = 1:T
        W,H,L,U,R,D = readnum()
        ret = solve(W,H,L,U,R,D)
        println(stdout, "Case #$(t): ", ret)
    end
end

# (L,U)
#       (R,D)
function solve(W, H, L, U, R, D)
    danger = 0.0
    L > 1 && (danger += sum(p*prob_to_return(W, H, L-1, row) for row in U:D))
    U > 1 && (danger += sum(p*prob_to_return(W, H, col, U-1) for col in L:R))
    return 1 - danger
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

# %% call
# -------

if isdefined(Main, :Juno)
    let p = joinpath(@__DIR__, replace(basename(@__FILE__), r"(.+).jl" => s"\1.in"))
        open(f -> main(f), p)
    end
else
    main()
end
