data = readlines(open("data/day1.txt"))

function calibration_sum(data :: Vector{String}, re::Regex)
    sum = 0
    for line in data
        digits = collect(eachmatch(re, line))
        f = first(digits)
        l = last(digits)
        value = parse(Int, f.match * l.match)
        sum += value
    end
    sum
end
re = r"\d"
calibration_sum(data, re)

function mapped_calibration_sum(data :: Vector{String}, re::Regex, mapping::Dict)
    sum = 0
    for line in data
        mapped = collect(eachmatch(re, line))
        f = first(mapped).match
        f_ = f in keys(mapping) ? mapping[f] : f
        l = last(mapped).match
        l_ = l in keys(mapping) ? mapping[l] : l
        value = parse(Int, f_ * l_)
        sum += value
    end
    sum
end

data = readlines(open("data/day1.txt"))
re = r"(?:(?<=o)n(?=e)|(?<=t)w(?=o)|(?<=t)hre(?=e)|four|fiv(?=e)|six|seve(?=n)|(?<=e)igh(?=t)|(?<=n)in(?=e))|\d"
mapping = Dict("n" => "1", "w" => "2", "hre" => "3", "four" => "4", "fiv" => "5", "six" => "6", "seve" => "7", "igh" => "8", "in" => "9")
mapped_calibration_sum(data, re, mapping)


# test
test = "twooneightwoneighthreeightfourfiveightsixsevenineoneightwonineight"
vals = collect(eachmatch(re, test))
