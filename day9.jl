data = [parse.(Int64, split(x)) for x in readlines(open("data/day9.txt"))]

function extrapolate(v)
    if all([x == 0 for x in v])
        return 0
    end

    δ = diff(v)
    ŷ = extrapolate(δ)
    last(v) + ŷ
end

sum([extrapolate(v) for v in data])
sum([extrapolate(reverse(v)) for v in data])


