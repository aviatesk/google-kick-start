# aviatesk - Google Kick Start

Keeps my challenges/reviews for programming competitions on [Google Kick Start](https://codingcompetitions.withgoogle.com/kickstart).


## steps

1. fire up [Juno](https://junolab.org/)
2. copy [tmpl.jl](./common/tmpl.jl) and paste and save it into a file (let to be `prob.jl`)
3. create a sample input file and name it `prob.in`
4. run `prob.jl` interactively and solve !

> [tmpl.jl](./common/tmpl.jl)

```julia
# %% common
# ---------

# %% body
# -------

function main(io::IO = stdin)
    readnum = let io = io
        (T::Type{<:Number} = Int; dlm = isspace, kwargs...) ->
            parse.(T, split(readline(io), dlm; kwargs...))
    end

    T, = readnum()
    for t = 1:T
        # ...
        ret = solve()
        println(stdout, "Case #$(t): ", ret)
    end
end

function solve()
    # ...
end

# %% call
# -------

if isdefined(Main, :Juno)
    let f = splitpath(@__FILE__)[end]
        p = joinpath(@__DIR__, replace(f, r"(.+).jl" => s"\1.in"))
        open(f -> main(f), p)
    end
else
    main()
end
```