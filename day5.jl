struct Mapper
    source::UnitRange
    Δ::Int
    f::Function
    function Mapper(line::String)
        dest, source, size = toInt(line)
        sourcerange = range(source, length=size)
        Δ = dest - source
        new(sourcerange, Δ, (x) -> x .+ Δ)
    end
end

struct Domain
    name::String
    maps::Vector{Mapper}
end

toInt(vals) = parse.(Int, split(vals))

function get_seeds(data)
    _, vals = split(data[1], ":")
    seeds = toInt(vals)
    popfirst!(data)
    popfirst!(data)
    push!(data, "")
    seeds, data
end

function build_maps(data)
    seeds, data = get_seeds(data)
    domains = Dict()
    name = ""
    collection = []
    steps = []
    for i in eachindex(data)
        line = data[i]
        if isempty(line)
            domains[name] = Domain(name, collection)
            collection = []
            continue
        end

        if !isnothing(match(r":", line))
            name = split(split(line)[1], "-")[1]
            push!(steps, name)
            continue
        end
        push!(collection, Mapper(line))
    end
    seeds, steps, domains
end

function apply(seed, domain)
    for m in domain.maps
        if seed in m.source
            seed = m.f(seed)
            return seed
        end
    end
    return seed
end

function get_lowest(data)
    seeds, steps, domains = build_maps(data);
    lowest = Inf
    for s in seeds
        for step in steps
            domain = domains[step]
            s = apply(s, domain)
        end
        if s < lowest
            lowest = s
        end
    end
    lowest
end
data = readlines(open("data/day5.txt"))
get_lowest(data)

# Part 2


r1 = 1:2
r5 = 1:5
r4 = 2:7
r3 = 5:10
r2 = 1:10
r6 = 9:10
r7 = 4:8
r8 = 1:8
r9 = 5:8
source = 4:8

between(x, r) = x >= first(r) && x <= last(r)

function overlap(r1, r2)
    between(first(r1), r2) || between(last(r1), r2) || between(first(r2), r1) || between(last(r2), r1)
end

for r in [r1, r2, r3, r4, r5, r6, r7, r8, r9]
    println(r,  " : " , overlap(r, source))
end


function split_ranges(r, source)
    out = []

    if first(r) < first(source)
        before = first(r)
        till = first(source) - 1
        push!(out, before:till)
        if last(r) < last(source) push!(out, first(source):last(r)) end
    end

    if last(r) > last(source)
        after = last(r)
        from = last(source) + 1
        isempty(out) ? push!(out, first(r):last(source)) : push!(out, source)
        push!(out, from:after)
    end
    out
end

for r in [r1, r2, r3, r4, r5, r6, r7, r8, r9]
    if overlap(r, source)
        println(r, " : ", split_ranges(r, source))
    end
end

function create_seed_ranges(seeds)
    rlist = UnitRange[]
    for i in 1:2:length(seeds)
        push!(rlist, range(seeds[i], length=seeds[i+1]))
    end
    rlist
end

function get_seeds2(data)
    _, vals = split(data[1], ":")
    seeds = create_seed_ranges(toInt(vals))
    popfirst!(data)
    popfirst!(data)
    push!(data, "")
    seeds, data
end

data = readlines(open("data/day5-test.txt"))
seeds, data = get_seeds2(data)

line = data[3]
m = Mapper(line)

r = seeds[1]
overlap(r, m.source)
r
split_ranges(r, m.source)


function build_maps2(data)
    seeds, data = get_seeds2(data);
    domains = Dict()
    name = ""
    collection = []
    steps = []
    for i in eachindex(data)
        line = data[i]
        if isempty(line)
            domains[name] = Domain(name, collection)
            collection = []
            continue
        end

        if !isnothing(match(r":", line))
            name = split(split(line)[1], "-")[1]
            push!(steps, name)
            continue
        end
        push!(collection, Mapper(line))
    end
    seeds, steps, domains
end

function get_lowest2(data)
    seeds, steps, domains = build_maps2(data);
    lowest = Inf
    for s in seeds
        for step in steps
            domain = domains[step]
            s = apply(s, domain)
        end
        if s < lowest
            lowest = s
        end
    end
    lowest
end
data = readlines(open("data/day5.txt"))
get_lowest2(data)





