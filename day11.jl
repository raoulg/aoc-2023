import Combinatorics: combinations

struct Point
    x::Int
    y::Int
end

function Base.:+(p1::Point, p2::Point)
    Point(p1.x + p2.x, p1.y + p2.y)
end

function get_universe(data)
    universe = Dict{Tuple{Int, Int}, Point}()
    row = 1
    m = []
    for line in data
        v = Bool[]
        for col in eachindex(line)
            line[col] == '.' ? push!(v, false) : push!(v, true)
            if line[col] != '.'
                universe[(row, col)] = Point(row, col)
            end
        end
        push!(m, reshape(v, 1, :))
        row += 1
    end
    m = vcat(m...)
    universe, m
end


function row_col(universe)
    rows = Dict()
    cols = Dict()
    for (k, _) in universe
        rows[k[1]] = push!(get(rows, k[1], []), k)
        cols[k[2]] = push!(get(cols, k[2], []), k)
    end
    [rows, cols]
end

swap(x) = x == 1 ? 2 : 1
function get_expansion(m, rate; idx)
    n = size(m)[idx]
    counter = sum(m, dims=swap(idx))
    expand = fill(0, n)
    for i in findall(x -> x == 0, counter)
        k = i[1] * i[2]
        z = vcat(fill(0, k), fill(rate-1, n-k))
        expand += z
    end
    expand
end

add_amount(amount; idx) = idx == 1 ? Point(amount, 0) : Point(0, amount)

function expand_idx(universe, m, rate, bookkeeping; idx)
    x = get_expansion(m, rate, idx=idx)
    for (i, amount) in enumerate(x)
        if amount > 0
            if i in keys(bookkeeping[idx])
                for g in bookkeeping[idx][i]
                    universe[g] = universe[g] + add_amount(amount, idx=idx)
                end
            end
        end
    end
    universe
end

manhattan(p1::Point, p2::Point) = abs(p1.x - p2.x) + abs(p1.y - p2.y)

data = readlines(open("data/day11.txt"))

function run(data, rate)
    universe, m = get_universe(data)
    bookkeeping = row_col(universe)
    universe = expand_idx(universe, m, rate, bookkeeping, idx=1)
    universe = expand_idx(universe, m, rate, bookkeeping, idx=2)
    c = values(universe) |> collect |> (x) -> combinations(x, 2) |> collect
    sum([manhattan(x...) for x in c])
end

run(data, 2)
@time run(data, 1000000)