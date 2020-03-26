# aviatesk - google kick start

Keeps my challenges/reviews for programming competitions on [Google Kick Start](https://codingcompetitions.withgoogle.com/kickstart).


## archives

2019-E:
- [Cherries Mesh](https://codingcompetitions.withgoogle.com/kickstart/round/0000000000050edb/0000000000170721), [cherriesmesh.jl](./2019-E/cherriesmesh.jl)
  * [x] visible
  * [x] hidden

2019-F:
- [Flattening](https://codingcompetitions.withgoogle.com/kickstart/round/0000000000050edc/000000000018666c), [flattening.jl](./2019-F/flattening.jl)
  * [x] visible
  * [x] hidden
- [Teach Me](https://codingcompetitions.withgoogle.com/kickstart/round/0000000000050edc/00000000001864bc), [teachme.jl](./2019-F/teachme.jl)
  * [x] visible
  * [x] hidden
- [Spectating Villages](https://codingcompetitions.withgoogle.com/kickstart/round/0000000000050edc/000000000018666b), [spectatingvilleges.jl](./2019-F/spectatingvilleges.jl)
  * [x] visible
  * [ ] hidden

2019-G:
- [Book Reading](https://codingcompetitions.withgoogle.com/kickstart/round/0000000000050e02/000000000018fd0d), [bookreading.jl](./2019-G/bookreading.jl)
  * [x] visible
  * [x] hidden
- [The Equation](https://codingcompetitions.withgoogle.com/kickstart/round/0000000000050e02/000000000018fe36), [theequation.jl](./2019-G/theequation.jl)
  * [x] visible
  * [ ] hidden
- [Shifts](https://codingcompetitions.withgoogle.com/kickstart/round/0000000000050e02/000000000018fd5e), [shifts.jl](./2019-G/shifts.jl)
  * [x] visible
  * [ ] hidden

2019-H:
- [H-index](https://codingcompetitions.withgoogle.com/kickstart/round/0000000000050edd/00000000001a274e), [hindex.jl](./2019-H/hindex.jl)
  * [x] visible
  * [x] hidden
- [Diagonal Puzzle](https://codingcompetitions.withgoogle.com/kickstart/round/0000000000050edd/00000000001a2835)
  * [ ] visible
  * [ ] hidden
- [Elevanagram](https://codingcompetitions.withgoogle.com/kickstart/round/0000000000050edd/00000000001a286d)
  * [ ] visible
  * [ ] hidden

2020-A:
- [Allocation](https://codingcompetitions.withgoogle.com/kickstart/round/000000000019ffc7/00000000001d3f56), [allocation.jl](./2020-A/allocation.jl)
  * [x] test set 1
  * [x] test set 2
- [Plates](https://codingcompetitions.withgoogle.com/kickstart/round/000000000019ffc7/00000000001d40bb), [plates.jl](./2020-A/plates.jl)
  * [x] test set 1
  * [x] test set 2
- [Workout](https://codingcompetitions.withgoogle.com/kickstart/round/000000000019ffc7/00000000001d3f5b), [workout.jl](./2020-A/workout.jl)
  * [x] test set 1
  * [x] test set 2
- [Bundling](https://codingcompetitions.withgoogle.com/kickstart/round/000000000019ffc7/00000000001d3ff3)
  * [ ] test set 1
  * [ ] test set 2


## workflow

1. fire up [Juno](https://junolab.org/)
2. copy [tmpl.jl](./tmpl.jl) and paste and save it into a file (let to be `prob.jl`)
3. create a sample input file and name it `prob.in`
4. run `prob.jl` interactively and solve !

> [tmpl.jl](./tmpl.jl)

```julia
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
