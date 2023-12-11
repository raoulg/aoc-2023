using Base.Iterators: cycle, peel

function process(data)
    instructions = popfirst!(data)
    popfirst!(data)
    tree = Dict()
    for line in data
        name, children = split(line, "=")
        name = replace(name, " " => "")
        l, r = split(replace(children, " " => "", "(" => "", ")" => ""), ",")
        tree[name] = [l, r]
    end
    instructions, tree
end

@enum Direction Left=1 Right=2
d = Dict('L' => Left, 'R' => Right)
move(current::SubString, d::Direction, tree) = tree[current][Int(d)]

function travel(instructions::String, tree::Dict, current::String, stop::Function)
    c = cycle(instructions)
    route = []
    while !stop(current)
        x, c = peel(c)
        current = move(current, d[x], tree)
        push!(route, current)
    end
    route
end

data = readlines(open("data/day8.txt"))
instructions, tree = process(data)
travel(instructions, tree, "AAA", (x) -> x == "ZZZ")

# Part 2
starts = [k for k in keys(tree) if last(k) == 'A']
lcm([length(travel(instructions, tree, s, (x) -> last(x) == 'Z')) for s in starts])