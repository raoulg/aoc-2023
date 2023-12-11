struct Point
    x::Int
    y::Int
end

function Base.:+(p1::Point, p2::Point)
    Point(p1.x + p2.x, p1.y + p2.y)
end

struct Pipe
    location::Point
    symbol::Char
    directions::Union{Array{Point}, Nothing}
end

up = Point(-1, 0)
down = Point(1, 0)
left = Point(0, -1)
right = Point(0, 1)

directions = Dict(
    '|' => [up, down],
    '-' => [left, right],
    'L' => [up, right],
    'J' => [up, left],
    '7' => [down, left],
    'F' => [down, right],
    '.' => nothing,
    'S' => nothing
)

function scan_landscape(data, s::Array{Point})
    directions['S'] = s
    landscape = Dict{Point, Pipe}()
    row = 1
    start = nothing
    for line in data
        for col in eachindex(line)
            loc = Point(row, col)
            pipe = line[col]
            if pipe != '.'
                landscape[loc] = Pipe(loc, line[col], directions[line[col]])
            end
            if pipe == 'S'
                start = landscape[loc]
            end
        end
        row +=1
    end
    landscape, start
end

flip(p::Point) = Point(-1*p.x, -1*p.y)
pair(p1::Point, p2::Point) = flip(p1) == p2
outgoing(p::Pipe, d::Point) = pair(d, p.directions[1]) ? p.directions[2] : p.directions[1]

function flow(landscape, p::Pipe, incoming::Point)
    out = outgoing(p, incoming)
    new_loc = p.location + out
    landscape[new_loc], out
end

function walk_pipe(data, s::Array{Point})
    landscape, start = scan_landscape(data, s)
    startlocation = start.location
    move = start.directions[1]
    p = landscape[startlocation + move]
    incoming = move
    trace = [start.location]
    while startlocation != p.location
        p, incoming = flow(landscape, p, incoming)
        push!(trace, p.location)
    end
    trace
end


data = readlines("data/day10.txt")
s = [left, right]
trace = walk_pipe(data, s)
length(trace) / 2

# Part 2

"""
https://en.wikipedia.org/wiki/Shoelace_formula
https://github.com/SP3269/Julia-Playground/blob/master/Shoelace%20Formula.ipynb
"""
function shoelace(A)
    shoe = vcat(A...)
    x1 = shoe[:, 1]
    y2 = circshift(shoe[:, 2], -1)
    y1 = shoe[:, 2]
    x2 = circshift(shoe[:, 1], -1)
    ((sum(x1 .* y2) - sum(x2 .* y1)) ) / 2
end


"""
https://en.wikipedia.org/wiki/Pick%27s_theorem
area = inside + boundary/2 - 1
area - boundary/2 + 1 = inside
"""
picksTheorem(A) = (shoelace(A) - (length(A)/2)) + 1

trace = walk_pipe(data, s)
A = [[x.x x.y] for x in trace]
picksTheorem(A)

