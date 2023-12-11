data = readlines(open("data/day4.txt"));


function count_wins(winning, have)
    win = Set([parse(Int, w) for w in split(winning)])
    hav = Set([parse(Int, h) for h in split(have)])

    length(intersect(win, hav))
end

function score_cards(data)
    score = 0
    for line in data
        winning, have = split(split(line, ":")[2], "|")
        n = count_wins(winning, have) - 1
        if n >= 0
            score += 2^n
        end
    end
    score
end
@time score_cards(data)

# Part 2

data = readlines(open("data/day4.txt"));
function score_copies(data)
    copies = Dict()
    for line in data
        card, nums = split(line, ":")
        cardnum = parse(Int, match(r"\d+", card).match)
        copies[cardnum] = get(copies, cardnum, 0) + 1

        winning, have = split(nums, "|")
        n = count_wins(winning, have)
        for i in 1:n
            copies[cardnum+i] = get(copies, cardnum+i, 0) + (1 * copies[cardnum])
        end
    end
    sum(values(copies))
end
@time score_copies(data)