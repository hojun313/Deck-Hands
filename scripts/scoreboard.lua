-- scoreboard.lua

local scoreboard = {} -- 모듈 테이블 생성

local num_cols = 1 + 5 + 9 -- 점수판 가로 칸 수
local num_rows = 3         -- 점수판 세로 칸 수
local small_rect_width = 1900 / num_cols     -- 작은 사각형 가로 길이 (main.lua에서 계산)
local small_rect_height = 250 / num_rows    -- 작은 사각형 세로 길이 (main.lua에서 계산)

-- 점수판 초기화 함수 (필요하다면)
function scoreboard.init()
    -- 초기화 작업 (필요하다면 여기에 작성)
end

-- 점수판 그리기 함수
function scoreboard.drawScoreboard(scores)
    love.graphics.setColor(1, 1, 1) -- 흰색으로 설정
    
    local player_names = {"플레이어", "빨간 사자", "파란 늑대"} -- 플레이어 이름 목록
    local jokbo_names = {"", "10", "J", "Q", "K", "A", "HIGH", "DOUBLE", "TWO PAIR", "TRIPLE", "STRAIGHT", "FLUSH", "FULL HOUSE", "FOUR CARD", "STRAIGHT FLUSH", "ROYAL STRAIGHT FLUSH"}

    for row_index = 0, num_rows - 1 do
        for col_index = 0, num_cols - 1 do
            local x = 70 + col_index * small_rect_width
            local y = 70 + row_index * small_rect_height
            love.graphics.rectangle("line", x, y, small_rect_width, small_rect_height)

            local text = ""

            if col_index == 0 then -- 가장 왼쪽 위 칸
                if player_names[row_index + 1] then
                    text = player_names[row_index + 1]
                end
            elseif row_index == 0 then -- 첫 번째 줄 (row_index 가 0일 때)
                if jokbo_names[col_index + 1] then -- jokbo_names 테이블에 해당 인덱스가 있는지 확인
                    text = jokbo_names[col_index + 1]
                end
            else
                score = scores[col_index + 1]
                if score then
                    text = score
                end
            end
            love.graphics.print(text, x + 10, y + 10)
        end
    end
end

-- 점수 계산 함수 (점수 계산 로직 추가)
function scoreboard.calculateScore(fieldCards)
    local scores = {}
    for i = 1, 14 do
        scores[i] = 0
    end

    -- 족보 계산에 필요한 변수 초기화
    local rankCount = {} -- 각 숫자별 등장 횟수
    local suitCount = {} -- 각 무늬별 등장 횟수
    local ranks = {}      -- 카드 숫자만 저장 (순서대로 정렬)
    local rankOrder = {["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5, ["6"] = 6, ["7"] = 7, ["8"] = 8, ["9"] = 9, ["10"] = 10, ["J"] = 11, ["Q"] = 12, ["K"] = 13, ["A"] = 15}
    local suits = {}      -- 카드 무늬만 저장
    for _, card in ipairs(fieldCards) do
        rankCount[card.rank] = (rankCount[card.rank] or 0) + 1
        suitCount[card.suit] = (suitCount[card.suit] or 0) + 1
        table.insert(ranks, card.rank)
        table.insert(suits, card.suit)
    end

    table.sort(ranks, function(a, b) -- 숫자 순서대로 정렬 (문자열 비교 주의)
        local orderMap = {}
        local rankOrderChar = {"2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"}
        for i, r in ipairs(rankOrderChar) do
            orderMap[r] = i
        end
        return orderMap[a] < orderMap[b]
    end)

    -- 10카드, J카드 세기 (별도 점수, 필요에 따라 조정)
    scores[2] = scores[2] + (rankCount["10"] or 0) * 10
    scores[3] = scores[3] + (rankCount["J"] or 0) * 11
    scores[4] = scores[4] + (rankCount["Q"] or 0) * 12
    scores[5] = scores[5] + (rankCount["K"] or 0) * 13
    scores[6] = scores[6] + (rankCount["A"] or 0) * 15

    -- 가장 높은 숫자를 점수로 추가
    local highestRank = ranks[#ranks]
    scores[7] = rankOrder[highestRank] or 0

    -- 페어 카드가 있다면 그 카드의 숫자만큼 점수로 추가
    local pairCount = 0 -- 페어의 수를 저장할 변수 초기화
    local twoPairScore = 0 -- 투페어 점수를 저장할 변수 초기화

    for rank, count in pairs(rankCount) do
        if count >= 2 then -- 페어가 있으면
            pairCount = pairCount + 1 -- 페어가 있으면 페어 카운트 증가
            scores[8] = math.max(scores[8], (rankOrder[rank] or 0) * 2)
            twoPairScore = twoPairScore + (rankOrder[rank] or 0)
        end
        if count >= 3 then -- 트리플이 있으면 트리플 카드 숫자만큼 점수 추가
            scores[10] = math.max(scores[10], (rankOrder[rank] or 0) * 3)
        end
        if count >= 4 then -- 포카드가 있으면 포카드 카드 숫자만큼 점수 추가
            scores[14] = math.max(scores[14], (rankOrder[rank] or 0) * 4)
        end
    end
    -- 투페어를 감지하고 점수를 추가하는 코드
    if pairCount >= 2 then
        scores[9] = twoPairScore * 2
    end

    -- 스트레이트 감지 및 점수 추가
    if #ranks == 5 and
       rankOrder[ranks[1]] + 1 == rankOrder[ranks[2]] and
       rankOrder[ranks[2]] + 1 == rankOrder[ranks[3]] and
       rankOrder[ranks[3]] + 1 == rankOrder[ranks[4]] and
       rankOrder[ranks[4]] + 1 == rankOrder[ranks[5]] then
        scores[11] = 999 -- rankOrder[ranks[5]] * 5 
    end

    -- 플러시 감지 및 점수 추가
    if #suits == 5 and
       suitCount[suits[1]] == 5 then
        scores[12] = 999
    end

    -- 풀하우스 감지 및 점수 추가
    local hasThree = false
    local hasPair = false
    local threeRank = nil

    for rank, count in pairs(rankCount) do
        if count == 3 then
            hasThree = true
            threeRank = rank
        elseif count == 2 then
            hasPair = true
        end
    end

    if hasThree and hasPair then
        scores[13] = 1000 -- 풀하우스 점수 (임의 값)
    end

    -- 스트레이트 플러시 감지 및 점수 추가
    if scores[11] > 0 and scores[12] > 0 then
        scores[15] = 10000 -- 스트레이트 플러시 점수 (임의 값)
    else
        scores[15] = 0
    end
    

    return scores
end

return scoreboard -- 모듈 테이블 반환