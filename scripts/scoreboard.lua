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
function scoreboard.drawScoreboard()
    
    love.graphics.setColor(1, 1, 1) -- 흰색으로 설정
    
    local player_names = {"플레이어", "플레이어 1", "플레이어 2"} -- 플레이어 이름 목록
    local jokbo_names = {"", "10", "J", "Q", "K", "A", "HIGH", "DOUBLE", "TWO PAIR", "TRIPLE", "STRAIGHT", "FLUSH", "FULL HOUSE", "FOUR CARD", "STRAIGHT FLUSH", "ROYAL STRAIGHT FLUSH"}

    for row_index = 0, num_rows - 1 do
        for col_index = 0, num_cols - 1 do
            local x = 70 + col_index * small_rect_width
            local y = 70 + row_index * small_rect_height
            love.graphics.rectangle("line", x, y, small_rect_width, small_rect_height)

            local text = ""

            if row_index == 0 and col_index ~= 0 then -- 첫 번째 줄 (row_index 가 0일 때)
                if jokbo_names[col_index + 1] then -- jokbo_names 테이블에 해당 인덱스가 있는지 확인
                    text = jokbo_names[col_index + 1] -- 족보 이름 가져오기
                end
            elseif col_index == 0 then -- 두 번째 줄부터, 가장 왼쪽 열 (col_index 가 0일 때)
                if player_names[row_index + 1] then
                    text = player_names[row_index + 1]
                end
            else
                text = "(" .. col_index .. ", " .. row_index .. ")" -- 그 외 칸에는 칸 번호 표시
            end

            love.graphics.print(text, x + 10, y + 10)
        end
    end
end

-- 점수 계산 함수 (점수 계산 로직이 생기면 여기에 추가)
function scoreboard.calculateScore()
    -- 점수 계산 로직 (미구현)
end

return scoreboard -- 모듈 테이블 반환