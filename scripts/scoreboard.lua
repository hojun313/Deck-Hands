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

    -- 점수 계산 로직 (예시: 족보에 따라 점수 계산)
    -- fieldCards는 5개의 카드 정보가 담긴 테이블
    -- 각 카드 정보는 {suit = "spades", rank = "A"} 형태로 제공된다고 가정



    -- 예시 점수 계산 로직 (간단한 족보 체크)
    local rankCount = {} -- 각 숫자 몇번 등장했는지 저장
    for _, card in ipairs(fieldCards) do
        rankCount[card.rank] = (rankCount[card.rank] or 0) + 1

        if card.rank == "A" then
            scores[6] = scores[6] + 1 -- A 카드가 있으면 HIGH 카드
        end
    end

    -- 예시: 트리플, 풀하우스, 포카드 등 간단한 족보 체크
    for rank, count in pairs(rankCount) do
        if count == 4 then
            scores[14] = scores[14] + 7 -- 포카드
        end
        if count >= 3 then
            scores[10] = scores[10] + 3 -- 트리플
        end
        if count >= 2 then
            scores[8] = scores[8] + 1 -- 원페어
        end
    end

    return scores
end

return scoreboard -- 모듈 테이블 반환