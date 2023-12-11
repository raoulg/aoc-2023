# part one
data = readlines(open("data/day2-test.txt"))

parseToInt(m) = isnothing(m) ? 0 : parse(Int64, m.match)

struct Game
    red :: Int
    green :: Int
    blue :: Int
end

blue = r"\d+(?= blue)"
red = r"\d+(?= red)"
green = r"\d+(?= green)"

function Game(sample::T) where {T <: AbstractString}
    Game(
        parseToInt(match(red, sample)),
        parseToInt(match(green, sample)),
        parseToInt(match(blue, sample))
    )
end

function Base.:<=(g1::Game, g2::Game)
    g1.red <= g2.red && g1.green <= g2.green && g1.blue <= g2.blue
end

function check_possibility(data::Vector{String}, max:: Game)
    possible = 0
    for line in data
        id, games = split(line, ":")
        id = parse(Int, match(r"\d+", id).match)
        check = all([Game(s) <= max for s in split(games, ";")])
        if check
            possible += id
        end
    end
    possible
end

data = readlines(open("data/day2.txt"))
check_possibility(data, Game(12, 13, 14 ))

# Part two
function Base.:maximum(g1::Game, g2::Game)
    Game(
        maximum([g1.red, g2.red]),
        maximum([g1.green, g2.green]),
        maximum([g1.blue, g2.blue])
    )
end

function get_maximum(samples)
    min = Game(0,0,0)
    for s in samples
        min = maximum(min, Game(s))
    end
    min
end

Base.:prod(g::Game) = g.red * g.green * g.blue

function check_max(data::Vector{String})
    total = 0
    for line in data
        id, games = split(line, ":")
        id = parse(Int, match(r"\d+", id).match)
        max = get_maximum(split(games, ";"))
        power = prod(max)
        total += power
    end
    total
end

data = readlines(open("data/day2.txt"))
check_max(data)

