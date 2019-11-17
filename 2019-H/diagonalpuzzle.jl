# utils
# ----

readnum(type::Type{<:Number} = Int) = parse(type, readline())
readarray(type::Type{<:Number} = Int, dlm = isspace; kwargs...) =
    parse.(type, split(readline(), dlm; kwargs...))

# body
# ----

function main()
    T = readnum()
    for t = 1:T
        N = readnum()
        grid = zeros(Bool, (N, N))
        for (i, n) in enumerate(1:N)
            for (j, c) in enumerate(readline())
                if c === '.'
                    grid[i, j] = true
                end
            end
        end

        n = solve(grid)
        println(stdout, "Case #$(t): $(n)")
    end
end

function solve(grid)

end

# call
# ----

main()
