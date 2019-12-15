# aviatesk - google kick start

Keeps my challenges/reviews for programming competitions on [Google Kick Start](https://codingcompetitions.withgoogle.com/kickstart).


## archives

2019-F:
- [Flattening](https://codingcompetitions.withgoogle.com/kickstart/round/0000000000050edc/000000000018666c)
  * [x] visible
  * [x] hidden
- [Teach Me](https://codingcompetitions.withgoogle.com/kickstart/round/0000000000050edc/00000000001864bc)
  * [x] visible
  * [x] hidden
- [Spectating Villages](https://codingcompetitions.withgoogle.com/kickstart/round/0000000000050edc/000000000018666b)
  * [ ] visible
  * [ ] hidden

2019-G:
- [Book Reading](https://codingcompetitions.withgoogle.com/kickstart/round/0000000000050e02/000000000018fd0d)
  * [x] visible
  * [x] hidden
- [The Equation](https://codingcompetitions.withgoogle.com/kickstart/round/0000000000050e02/000000000018fe36)
  * [x] visible
  * [ ] hidden
- [Shifts](https://codingcompetitions.withgoogle.com/kickstart/round/0000000000050e02/000000000018fd5e)
  * [x] visible
  * [ ] hidden

2019-H:
- [H-index](https://codingcompetitions.withgoogle.com/kickstart/round/0000000000050edd/00000000001a274e)
  * [x] visible
  * [x] hidden
- [Diagonal Puzzle](https://codingcompetitions.withgoogle.com/kickstart/round/0000000000050edd/00000000001a2835)
  * [ ] visible
  * [ ] hidden
- [Elevanagram](https://codingcompetitions.withgoogle.com/kickstart/round/0000000000050edd/00000000001a286d)
  * [ ] visible
  * [ ] hidden


## workflow

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
    let p = joinpath(@__DIR__, replace(basename(@__FILE__), r"(.+).jl" => s"\1.in"))
        open(f -> main(f), p)
    end
else
    main()
end
```