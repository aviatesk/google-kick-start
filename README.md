my footprints on [google kick start](https://codingcompetitions.withgoogle.com/kickstart)


## archives

2019-E:
- [problem](https://codingcompetitions.withgoogle.com/kickstart/round/0000000000050edb/0000000000170721), [cherriesmesh.jl](./2019-E/cherriesmesh.jl)
  * [x] visible
  * [x] hidden

2019-F:
- [problem](https://codingcompetitions.withgoogle.com/kickstart/round/0000000000050edc/000000000018666c), [flattening.jl](./2019-F/flattening.jl)
  * [x] visible
  * [x] hidden
- [problem](https://codingcompetitions.withgoogle.com/kickstart/round/0000000000050edc/00000000001864bc), [teachme.jl](./2019-F/teachme.jl)
  * [x] visible
  * [x] hidden
- [problem](https://codingcompetitions.withgoogle.com/kickstart/round/0000000000050edc/000000000018666b), [spectatingvilleges.jl](./2019-F/spectatingvilleges.jl)
  * [x] visible
  * [ ] hidden

2019-G:
- [problem](https://codingcompetitions.withgoogle.com/kickstart/round/0000000000050e02/000000000018fd0d), [bookreading.jl](./2019-G/bookreading.jl)
  * [x] visible
  * [x] hidden
- [problem](https://codingcompetitions.withgoogle.com/kickstart/round/0000000000050e02/000000000018fe36), [theequation.jl](./2019-G/theequation.jl)
  * [x] visible
  * [ ] hidden
- [problem](https://codingcompetitions.withgoogle.com/kickstart/round/0000000000050e02/000000000018fd5e), [shifts.jl](./2019-G/shifts.jl)
  * [x] visible
  * [ ] hidden

2019-H:
- [problem](https://codingcompetitions.withgoogle.com/kickstart/round/0000000000050edd/00000000001a274e), [hindex.jl](./2019-H/hindex.jl)
  * [x] visible
  * [x] hidden
- [problem](https://codingcompetitions.withgoogle.com/kickstart/round/0000000000050edd/00000000001a2835)
  * [ ] visible
  * [ ] hidden
- [problem](https://codingcompetitions.withgoogle.com/kickstart/round/0000000000050edd/00000000001a286d)
  * [ ] visible
  * [ ] hidden

2020-A:
- [problem](https://codingcompetitions.withgoogle.com/kickstart/round/000000000019ffc7/00000000001d3f56), [allocation.jl](./2020-A/allocation.jl)
  * [x] test set 1
  * [x] test set 2
- [problem](https://codingcompetitions.withgoogle.com/kickstart/round/000000000019ffc7/00000000001d40bb), [plates.jl](./2020-A/plates.jl)
  * [x] test set 1
  * [x] test set 2
- [problem](https://codingcompetitions.withgoogle.com/kickstart/round/000000000019ffc7/00000000001d3f5b), [workout.jl](./2020-A/workout.jl)
  * [x] test set 1
  * [x] test set 2
- [problem](https://codingcompetitions.withgoogle.com/kickstart/round/000000000019ffc7/00000000001d3ff3)
  * [ ] test set 1
  * [ ] test set 2

2020-B:
- [problem](https://codingcompetitions.withgoogle.com/kickstart/round/000000000019ffc8/00000000002d82e6), [biketour.jl](./2020-B/biketour.jl)
  * [x] test set 1
  * [x] test set 2
- [problem](https://codingcompetitions.withgoogle.com/kickstart/round/000000000019ffc8/00000000002d83bf), [busroutes.jl](./2020-B/busroutes.jl)
  * [x] test set 1
  * [x] test set 2
- [problem](https://codingcompetitions.withgoogle.com/kickstart/round/000000000019ffc8/00000000002d83dc), [robotpathdecoding.jl](./2020-B/robotpathdecoding.jl)
  * [x] test set 1
  * [x] test set 2
- [problem](https://codingcompetitions.withgoogle.com/kickstart/round/000000000019ffc8/00000000002d8565), [wanderingrobot.jl](./2020-B/wanderingrobot.jl)
  * [ ] test set 1
  * [ ] test set 2

2020-C:
- [problem](https://codingcompetitions.withgoogle.com/kickstart/round/000000000019ff43/00000000003380d2), [countdown.jl](./2020-C/countdown.jl)
  * [x] test set 1
  * [x] test set 2
- [problem](https://codingcompetitions.withgoogle.com/kickstart/round/000000000019ff43/00000000003379bb), [stablewall.jl](./2020-C/stablewall.jl)
  * [ ] test set 1
  * [ ] test set 2
- [problem](https://codingcompetitions.withgoogle.com/kickstart/round/000000000019ff43/00000000003381cb), [perfectsubarray.jl](./2020-C/perfectsubarray.jl)
  * [x] test set 1
  * [ ] test set 2
- [problem](https://codingcompetitions.withgoogle.com/kickstart/round/000000000019ff43/0000000000337b4d), [candies.jl](./2020-C/candies.jl)
  * [ ] test set 1
  * [ ] test set 2


## workflow

1. fire up [Juno](https://junolab.org/)
2. copy [tmpl.jl](./tmpl.jl) and paste and save it into a file (let to be `prob.jl`)
3. create a sample input file and name it `prob.in`
4. run `prob.jl` interactively and solve !

> [tmpl.jl](./tmpl.jl)

```julia
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
        ret = solve()
        println(stdout, "Case #$(t): ", ret)
    end
end

function solve()
    # ...
end

@static if @isdefined(Juno) || @isdefined(VSCodeServer)
    main(open(replace(@__FILE__, r"(.+)\.jl" => s"\1.in")))
else
    main()
end
```
