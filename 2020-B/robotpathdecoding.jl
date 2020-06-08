# %% common
# ---------

# %% body
# -------

function main(io = stdin)
    readnum = let io = io
        (T::Type{<:Number} = Int; dlm = isspace, kwargs...) ->
            parse.(T, split(readline(io), dlm; kwargs...))
    end

    T, = readnum()
    for t = 1:T
        ret = solve(io)
        println(stdout, "Case #$(t): ", ret)
    end
end

const L = 10^9

function solve(io)
    r, c = read_routine(io)
    (r = mod(r+1, L)) === 0 && (r = L)
    (c = mod(c+1, L)) === 0 && (c = L)
    return "$c $r"
end

function read_routine(io, eof = '\n')
    row = col = 0
    while (c = read(io, Char)) !== eof
        if isnumeric(c)
            read(io, Char) # start
            subrow, subcol = read_routine(io, ')')
            n = parse(Int,c)
            row += subrow*n
            col += subcol*n
        else
            if c === 'N'
                row -= 1
            elseif c === 'E'
                col += 1
            elseif c === 'W'
                col -= 1
            else
                row += 1
            end
        end
    end
    return mod(row,L), mod(col,L) # avoid overflow
end

# %% call
# -------

@static if @isdefined(Juno)
    main(open(replace(@__FILE__, r"(.+)\.jl" => s"\1.in")))
else
    main()
end
