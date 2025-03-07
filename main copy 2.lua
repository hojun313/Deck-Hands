-- main.lua

-- card.lua 모듈 로드
local cardModule = require("scripts/card") -- "card"는 card.lua 파일 이름 (확장자 .lua 생략)
local lume = require("scripts/lume")

local clickedButton = ""

function love.load()
    -- lume.setup() -- lume 라이브러리 초기화
    -- gui = lume.canvas()
    
    math.randomseed(os.time()) -- 난수 생성기 시작 값 설정 (현재 시간 기준)
    love.window.setTitle("덱헨즈 게임 개발 환경 설정") -- 창 제목 변경

    love.graphics.setDefaultFilter("nearest", "nearest") -- 안티앨리어싱 끄기

    myFont = love.graphics.newFont("Assets/Fonts/Jua-Regular.ttf", 20)
    love.graphics.setFont(myFont)

    -- 카드 이미지 테이블 초기화
    cardImages = cardModule.load_card() -- 카드 이미지 로드 함수 호출

    -- 카드 덱 생성
    deck = cardModule.createDeck()
    -- 덱 섞기
    deck = lume.shuffle(deck) -- lume.shuffle() 함수 호출하여 덱 섞기

    field1, field2, field3, field4, field5 = nil, nil, nil, nil, nil
    deadPile = {} -- 죽은 카드 더미 초기화

    rebutton = {
        x = 0,
        y = 0,
        width = 100,
        height = 50,
        text = "버튼"
    }

    buttonStates = {false, false, false, false, false} -- 버튼 상태를 저장할 테이블 초기화
end

function isInsideRect(x, y, rectX, rectY, rectWidth, rectHeight)
    return x >= rectX and x <= rectX + rectWidth and y >= rectY and y <= rectY + rectHeight
end

function love.draw()
    love.graphics.print("덱 생성 완료. 콘솔(터미널) 출력을 확인하세요!", 100, 100)

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    local cardWidth = cardImages["card_back"]:getWidth() * 4
    local cardHeight = cardImages["card_back"]:getHeight() * 4
    local totalWidth = (4) * 60 * 4 + cardWidth -- 간격을 줄임
    local startX = (screenWidth - totalWidth) / 2
    local startY = (screenHeight - cardHeight) / 2

    -- 화면 위쪽에 직사각형 그리기

    local num_cols = 1 + 5 + 9
    local num_rows = 3
    local small_rect_width = 1900 / num_cols
    local small_rect_height = 250 / num_rows
    
    for row_index = 0, num_rows - 1 do
        for col_index = 0, num_cols - 1 do
            local x = 70 + col_index * small_rect_width
            local y = 70 + row_index * small_rect_height
            love.graphics.rectangle("line", x, y, small_rect_width, small_rect_height)
        end
    end



    local fields = {field1, field2, field3, field4, field5}
    for i, card in ipairs(fields) do
        if card then
            local cardImage = cardImages[card.image]
            if cardImage then
                love.graphics.draw(cardImage, startX + (i - 1) * 60 * 4, startY, 0, 4, 4) -- 간격을 줄임
                -- 카드 위에 버튼 그리기
                if buttonStates[i] then
                    love.graphics.setColor(0, 1, 0) -- 버튼이 눌린 상태면 초록색으로 표시
                else
                    love.graphics.setColor(1, 1, 1) -- 버튼이 눌리지 않은 상태면 흰색으로 표시
                end
                love.graphics.rectangle("line", startX + (i - 1) * 60 * 4 + 20, startY - 30, cardWidth - 40, 30)
                love.graphics.printf("버튼 " .. i, startX + (i - 1) * 60 * 4, startY - 30 + 10, cardWidth, "center")
                love.graphics.setColor(1, 1, 1) -- 색상 초기화
            end
        else
            love.graphics.draw(cardImages["card_place"], startX + (i - 1) * 60 * 4, startY, 0, 4, 4) -- 간격을 줄임
        end
    end

    -- 아직 안 뽑은 카드 더미 그리기 (위쪽)
    local deckImage = #deck > 0 and "card_back" or "card_place"
    love.graphics.draw(cardImages[deckImage], startX + totalWidth + 100, startY - cardHeight / 2 - 80, 0, 4, 4)
    love.graphics.print("남은 카드 수: " .. #deck, startX + totalWidth + 100 + cardWidth / 4, startY + 60)

    -- 버튼 그리기
    rebutton.x = startX + totalWidth + 100 + 80
    rebutton.y = startY - cardHeight / 2 + 230
    love.graphics.rectangle("line", rebutton.x, rebutton.y, rebutton.width, rebutton.height)
    love.graphics.printf(rebutton.text, rebutton.x, rebutton.y + 15, rebutton.width, "center")

    -- 죽은 카드 더미 그리기 (아래쪽)
    local deadPileImage = #deadPile > 0 and "card_back" or "card_place"
    love.graphics.draw(cardImages[deadPileImage], startX + totalWidth + 100, startY + cardHeight / 2 + 80, 0, 4, 4)
    love.graphics.print("죽은 카드 수: " .. #deadPile, startX + totalWidth + 100 + cardWidth / 4, startY + 180)

    local totalCards = #fields + #deck + #deadPile
    love.graphics.print("전체 카드 수: " .. totalCards, 100, 90)
    love.graphics.print("뽑은 카드 수: " .. #fields, 100, 120 + 30 * (#fields + 1))

    -- 덱에 남아있는 카드 표시
    local deckX = 100
    local deckY = 120 + 30 * (#fields + 2)
    love.graphics.print("덱에 남아있는 카드:", deckX, deckY)
    for i, card in ipairs(deck) do
        love.graphics.print(card.suit .. " " .. card.rank, deckX, deckY + 20 * i)
    end

    -- 클릭된 버튼 출력
    love.graphics.print(clickedButton, 100, 150)
end

function love.mousepressed(x, y, mouseButton, istouch, presses)
    if mouseButton == 1 then
        if isInsideRect(x, y, rebutton.x, rebutton.y, rebutton.width, rebutton.height) then
            clickedButton = "버튼이 눌렸습니다."

            local fields = {field1, field2, field3, field4, field5}
            local newFields = {nil, nil, nil, nil, nil}
            local newButtonStates = {false, false, false, false, false}

            -- 필드에 있던 카드들을 새로운 테이블로 옮기기 (눌린 카드는 그대로, 나머지는 deadPile로)
            for i, card in ipairs(fields) do
                if buttonStates[i] then
                    newFields[i] = card
                    newButtonStates[i] = buttonStates[i]
                else
                    table.insert(deadPile, card)
                end
            end

            -- 덱에서 카드 뽑아서 필드에 추가하기
            local deck_num = #deck
            local cardsToDraw = 5 - lume.count(newFields, function(v) return v ~= nil end)
            if deck_num < cardsToDraw then
                for i = 1, deck_num do
                    local card = cardModule.drawCard(deck)
                    card.image = card.suit:lower() .. "_" .. card.rank
                    for j = 1, 5 do
                        if not newFields[j] then
                            newFields[j] = card
                            newButtonStates[j] = false
                            break
                        end
                    end
                end
                for i = #deadPile, 1, -1 do
                    table.insert(deck, table.remove(deadPile, i))
                end
                deck = lume.shuffle(deck)
                for i = 1, cardsToDraw - deck_num do
                    local card = cardModule.drawCard(deck)
                    card.image = card.suit:lower() .. "_" .. card.rank
                    for j = 1, 5 do
                        if not newFields[j] then
                            newFields[j] = card
                            newButtonStates[j] = false
                            break
                        end
                    end
                end
            else
                for i = 1, cardsToDraw do
                    local card = cardModule.drawCard(deck)
                    card.image = card.suit:lower() .. "_" .. card.rank
                    for j = 1, 5 do
                        if not newFields[j] then
                            newFields[j] = card
                            newButtonStates[j] = false
                            break
                        end
                    end
                end
            end

            field1, field2, field3, field4, field5 = newFields[1], newFields[2], newFields[3], newFields[4], newFields[5]
            buttonStates = newButtonStates
        end

        -- 카드 버튼 클릭 처리
        local fields = {field1, field2, field3, field4, field5}
        for i, card in ipairs(fields) do
            local cardX = (love.graphics.getWidth() - ((#fields - 1) * 60 * 4 + cardImages["card_back"]:getWidth() * 4)) / 2 + (i - 1) * 60 * 4
            local cardY = (love.graphics.getHeight() - cardImages["card_back"]:getHeight() * 4) / 2
            if isInsideRect(x, y, cardX + 20, cardY - 30, cardImages["card_back"]:getWidth() * 4 - 40, 30) then
                buttonStates[i] = not buttonStates[i] -- 버튼 상태 토글
                clickedButton = "버튼 " .. i .. (buttonStates[i] and "이 눌렸습니다." or "이 해제되었습니다.")
            end
        end
    end
end