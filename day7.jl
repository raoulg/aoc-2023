function counter(line)
    d = Dict()
    for c in line
        d[c] = get(d, c, 0) + 1
    end
    sort(collect(values(d)))
end

data

score_hand(v) = sum(v.^2)

# test
cases = [
    [5],
    [4,1],
    [3,2],
    [3,1,1],
    [2,2,1],
    [2,1,1,1],
    [1,1,1,1,1]
]
for c in cases
    println(c, " : ", score_hand(c))
end

struct Hand
    raw
    handscore
    bid
    Hand(hand, bid) = new(hand, score_hand(counter(hand)), parse(Int, bid))
end

charvals = Dict('A'=>14, 'K'=>13, 'Q'=>12, 'J'=>11, 'T'=>10, '9'=>9, '8'=>8, '7'=>7, '6'=>6, '5'=>5, '4'=>4, '3'=>3, '2'=>2)

function isless_raw(h1, h2)
    # println("raw for $h1 and $h2")
    for (c1, c2) in zip(h1, h2)
        if charvals[c1] == charvals[c2]
            continue
        else
            # println("char $c1 and $c2 : ", charvals[c1], " ", charvals[c2])
            return charvals[c1] < charvals[c2]
        end
    end
end


function Base.isless(h1::Hand, h2::Hand)
    h1.handscore == h2.handscore ? isless_raw(h1.raw, h2.raw) : h1.handscore < h2.handscore
end


function get_hands(data)
    hands = []
    for line in data
        h = Hand(split(line)...)
        push!(hands, h)
    end
    hands
end

function winning(hands)
    h = sort(hands)
    z = [hand.bid for hand in h]
    sum(z .* [1:length(z)...])
end

data = readlines(open("data/day7.txt"))
hands = get_hands(data)
winning(hands)

# part 2
data = readlines(open("data/day7.txt"))

function counter(line)
    d = Dict()
    for c in line
        d[c] = get(d, c, 0) + 1
    end
    j = pop!(d, 'J', 0)
    if !isempty(d)
        v = sort(collect(values(d)), rev=true)
        v[1] += j
    else
        v = [5]
    end
    return v
end
charvals = Dict('A'=>14, 'K'=>13, 'Q'=>12, 'J'=>1, 'T'=>10, '9'=>9, '8'=>8, '7'=>7, '6'=>6, '5'=>5, '4'=>4, '3'=>3, '2'=>2)
hands = get_hands(data)
winning(hands)
