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
    for i = 0, 14 do
        scores[i] = 0
    end

    -- 족보 계산에 필요한 변수 초기화
    local rankCount = {} -- 각 숫자별 등장 횟수
    local suitCount = {} -- 각 무늬별 등장 횟수
    local ranks = {}      -- 카드 숫자만 저장 (순서대로 정렬)
    local suits = {}      -- 카드 무늬만 저장

    for _, card in ipairs(fieldCards) do
        rankCount[card.rank] = (rankCount[card.rank] or 0) + 1
        suitCount[card.suit] = (suitCount[card.suit] or 0) + 1
        table.insert(ranks, card.rank)
        table.insert(suits, card.suit)
    end

    table.sort(ranks, function(a, b) -- 숫자 순서대로 정렬 (문자열 비교 주의)
        local rankOrder = {"2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"}
        local orderMap = {}
        for i, r in ipairs(rankOrder) do
            orderMap[r] = i
        end
        return orderMap[a] < orderMap[b]
    end)


    -- 플러쉬 체크
    local isFlush = false
    for suit, count in pairs(suitCount) do
        if count >= 5 then -- 5장 모두 같은 무늬면 플러쉬
            isFlush = true
            break
        end
    end

    -- -- 스트레이트 체크
    -- local isStraight = false
    -- local isWheelStraight = false -- A-2-3-4-5 스트레이트 (Wheel)
    -- local uniqueRanks = {}
    -- for _, rank in ipairs(ranks) { -- 중복 제거
    --     if not uniqueRanks[rank] then
    --         uniqueRanks[rank] = true
    --     }
    -- end
    -- local uniqueRankArray = {}
    -- for rank, _ in pairs(uniqueRanks) {
    --     table.insert(uniqueRankArray, rank)
    -- }
    -- table.sort(uniqueRankArray, function(a, b) -- 숫자 순서대로 정렬
    --     local rankOrder = {"2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"}
    --     local orderMap = {}
    --     for i, r in ipairs(rankOrder) do
    --         orderMap[r] = i
    --     end
    --     return orderMap[a] < orderMap[b]
    -- end)


    -- if #uniqueRankArray >= 5 then
    --     for i = 1, #uniqueRankArray - 4 do
    --         local straightRanks = {}
    --         for j = 0, 4 do
    --             table.insert(straightRanks, uniqueRankArray[i+j])
    --         end
    --         local straightValues = {}
    --         local rankOrder = {"2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"}
    --         local orderMap = {}
    --         for i_order, r in ipairs(rankOrder) do
    --             orderMap[r] = i_order
    --         end
    --         for _, r in ipairs(straightRanks) do
    --             table.insert(straightValues, orderMap[r])
    --         end
    --         local consecutive = true
    --         for k = 1, 4 do
    --             if straightValues[k+1] - straightValues[k] ~= 1 then
    --                 consecutive = false
    --                 break
    --             end
    --         end
    --         if consecutive then
    --             isStraight = true
    --             break
    --         end
    --     end


    --     -- Wheel 스트레이트 체크 (A-2-3-4-5)
    --     local wheelRanks = {"A", "2", "3", "4", "5"}
    --     local hasWheel = true
    --     for _, wheelRank in ipairs(wheelRanks) do
    --         local found = false
    --         for _, cardRank in ipairs(ranks) do
    --             if cardRank == wheelRank then
    --                 found = true
    --                 break
    --             end
    --         end
    --         if not found then
    --             hasWheel = false
    --             break
    --         end
    --     end
    --     if hasWheel then
    --         isWheelStraight = true
    --         isStraight = true -- Wheel 스트레이트도 스트레이트에 포함
    --     end
    -- end


    -- 로얄 플러쉬 체크 (10, J, Q, K, A 플러쉬)
    if isFlush and isStraight and ranks[#ranks] == "A" and ranks[1] == "10" then -- 가장 높은 스트레이트면서 플러쉬
        scores[1] = scores[1] + 10 -- 로얄 플러쉬 (가장 높은 점수)
    elseif isStraight and isFlush then
        scores[2] = scores[2] + 9 -- 스트레이트 플러쉬
    elseif rankCount["A"] == 4 or rankCount["K"] == 4 or rankCount["Q"] == 4 or rankCount["J"] == 4 or rankCount["10"] == 4 or rankCount["9"] == 4 or rankCount["8"] == 4 or rankCount["7"] == 4 or rankCount["6"] == 4 or rankCount["5"] == 4 or rankCount["4"] == 4 or rankCount["3"] == 4 or rankCount["2"] == 4 then
        scores[3] = scores[3] + 8 -- 포카드
    elseif (rankCount["A"] == 3 or rankCount["K"] == 3 or rankCount["Q"] == 3 or rankCount["J"] == 3 or rankCount["10"] == 3 or rankCount["9"] == 3 or rankCount["8"] == 3 or rankCount["7"] == 3 or rankCount["6"] == 3 or rankCount["5"] == 3 or rankCount["4"] == 3 or rankCount["3"] == 3 or rankCount["2"] == 3) and (rankCount["A"] == 2 or rankCount["K"] == 2 or rankCount["Q"] == 2 or rankCount["J"] == 2 or rankCount["10"] == 2 or rankCount["9"] == 2 or rankCount["8"] == 2 or rankCount["7"] == 2 or rankCount["6"] == 2 or rankCount["5"] == 2 or rankCount["4"] == 2 or rankCount["3"] == 2 or rankCount["2"] == 2) then
        scores[4] = scores[4] + 7 -- 풀하우스
    elseif isFlush then
        scores[5] = scores[5] + 6 -- 플러쉬
    elseif isStraight then
        scores[6] = scores[6] + 5 -- 스트레이트
    elseif rankCount["A"] == 3 or rankCount["K"] == 3 or rankCount["Q"] == 3 or rankCount["J"] == 3 or rankCount["10"] == 3 or rankCount["9"] == 3 or rankCount["8"] == 3 or rankCount["7"] == 3 or rankCount["6"] == 3 or rankCount["5"] == 3 or rankCount["4"] == 3 or rankCount["3"] == 3 or rankCount["2"] == 3 then
        scores[7] = scores[7] + 4 -- 트리플
    elseif (rankCount["A"] == 2 or rankCount["K"] == 2 or rankCount["Q"] == 2 or rankCount["J"] == 2 or rankCount["10"] == 2 or rankCount["9"] == 2 or rankCount["8"] == 2 or rankCount["7"] == 2 or rankCount["6"] == 2 or rankCount["5"] == 2 or rankCount["4"] == 2 or rankCount["3"] == 2 or rankCount["2"] == 2) then
        local pairCount = 0
        for rank, count in pairs(rankCount) do
            if count == 2 then
                pairCount = pairCount + 1
            end
        end
        if pairCount >= 2 then
            scores[9] = scores[9] + 3 -- 투페어
        else
            scores[8] = scores[8] + 2 -- 원페어
        end
    else
        -- High Card 점수 (예시: 가장 높은 카드 랭크에 따라 점수 부여, 필요에 따라 수정)
        local highCardRank = ranks[#ranks]
        if highCardRank == "A" then
            scores[10] = scores[10] + 1 -- A High Card
        elseif highCardRank == "K" then
            scores[11] = scores[11] + 1 -- K High Card
        elseif highCardRank == "Q" then
            scores[12] = scores[12] + 1 -- Q High Card
        elseif highCardRank == "J" then
            scores[13] = scores[13] + 1 -- J High Card
        elseif highCardRank == "10" then
            scores[14] = scores[14] + 1 -- 10 High Card
        end
    end

    -- 10카드, J카드 세기 (별도 점수, 필요에 따라 조정)
    scores[2] = scores[2] + (rankCount["10"] or 0) * 10
    scores[3] = scores[3] + (rankCount["J"] or 0) * 11
    scores[4] = scores[4] + (rankCount["Q"] or 0) * 12
    scores[5] = scores[5] + (rankCount["K"] or 0) * 13
    scores[6] = scores[6] + (rankCount["A"] or 0) * 15

    -- 가장 높은 숫자를 점수로 추가
    local highestRank = ranks[#ranks]
    local rankOrder = {["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5, ["6"] = 6, ["7"] = 7, ["8"] = 8, ["9"] = 9, ["10"] = 10, ["J"] = 11, ["Q"] = 12, ["K"] = 13, ["A"] = 15}
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
            scores[14] = math.max(scores[11], (rankOrder[rank] or 0) * 4)
        end
    end

    -- 투페어를 감지하고 점수를 추가하는 코드
    if pairCount >= 2 then
        scores[9] = twoPairScore * 2
    end




    return scores
end

return scoreboard -- 모듈 테이블 반환