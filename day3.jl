data = readlines(open("data/day3.txt"))

function neighborhood(row::Int, start::Int, stop::Int)
    s = Set()
    for col in start-1:stop+1
        push!(s, (row-1, col))
        push!(s, (row+1, col))
    end
    push!(s, (row, start-1))
    push!(s, (row, stop+1))
    s
end

struct Partnumber
    row::Int
    start::Int
    stop::Int
    neighbors::Set
    number::Int
    Partnumber(row::Int, m::RegexMatch) = new(
        row,
        m.offset,
        m.offset + length(m.match) - 1,
        neighborhood(row, m.offset, m.offset + length(m.match) -1),
        parse(Int, m.match)
    )
end


struct Partsymbol
    location::Tuple
    symbol::String
    Partsymbol(row::Int, m::RegexMatch) = new((row, m.offset), m.match)
end


function parse_scheme(data)
    numbers = []
    symbols = []
    for (row, line) in enumerate(data)
        nums = collect(eachmatch(r"\d+", line))
        syms = collect(eachmatch(r"[^\w\d\.]", line))
        append!(numbers, [Partnumber(row, n) for n in nums])
        append!(symbols, [Partsymbol(row, s) for s in syms])
    end
    locations = Set([s.location for s in symbols])
    sum([n.number for n in numbers if !isempty(intersect(n.neighbors, locations))])
end

parse_scheme(data)

# Part 2

data = readlines(open("data/day3.txt"))


function parse_gears(data)
    numbers = []
    locations = Set()
    for (row, line) in enumerate(data)
        nums = collect(eachmatch(r"\d+", line))
        stars = collect(eachmatch(r"\*", line))
        append!(numbers, [Partnumber(row, n) for n in nums])
        if !isempty(stars)
            push!(locations, [(row, s.offset) for s in stars]...)
        end
    end
    numbers, locations
end
numbers, locations = parse_gears(data);
locations


d = Dict()
for n in numbers
    d[n.row] = append!(get(d, n.row, []), [n])
end

ratios = 0
for loc in locations
    row = loc[1]
    consider = []
    for r in row-1:row+1
        adj = get(d, r, [])
        append!(consider, adj)
    end
    gears = [n for n in consider if loc in n.neighbors]
    if length(gears) == 2
        ratio = gears[1].number * gears[2].number
        ratios += ratio
    end
end
ratios
