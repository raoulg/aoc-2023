split_parse(line) = parse.(Int, split(split(line, ":")[2]))

function parse_data(data)
    times = split_parse(data[1])
    dist = split_parse(data[2])
    times, dist
end

function solve(a, b, c)
    z = b^2 - 4*a*c
    z > 0 ? [(-b + sqrt(z)) / (2*a), (-b - sqrt(z)) / (2*a)] : nothing
end

function get_freedom(solution)
        if (ceil(solution[1]) == solution[1]) solution[1] += 1 end
        if (floor(solution[2]) == solution[2]) solution[2] -= 1 end
        floor(solution[2]) - ceil(solution[1]) + 1
end

function get_margin(data)
    times, dist = parse_data(data)
    margin = 1
    for (t, d) in zip(times, dist)
        solution = solve(-1, t, -d)
        freedom = get_freedom(solution)
        margin *= freedom
    end
    margin
end

data = readlines(open("data/day6.txt"))
get_margin(data)

# Part 2
unkern(line) = parse(Int, join(split(split(line, ":")[2])))
t = unkern(data[1])
d = unkern(data[2])
solution = solve(-1, t, -d)
Int(get_freedom(solution))