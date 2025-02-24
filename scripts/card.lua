-- card.lua
-- 슈트 (무늬) 목록
local suits = {"Spades", "Hearts", "Diamonds", "Clubs"}
-- 랭크 (숫자/문자) 목록
local ranks = {"A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"}



-- 카드 덱 생성 함수
function createDeck()
    local deck = {} -- 빈 덱 테이블 생성
    for _, suit in ipairs(suits) do -- 슈트 목록 순회
        for _, rank in ipairs(ranks) do -- 랭크 목록 순회
            -- 카드 테이블 생성 및 덱에 추가
            table.insert(deck, {suit = suit, rank = rank})
        end
    end
    return deck -- 완성된 덱 반환
end

function shuffleDeck(deck)
    local n = #deck -- 덱의 카드 수
    for i = n, 2, -1 do -- 덱의 마지막 카드부터 두 번째 카드까지 순회
        local j = math.random(i) -- 1부터 i 사이의 랜덤한 인덱스 선택
        -- deck[i]와 deck[j] 카드 교환
        deck[i], deck[j] = deck[j], deck[i]
    end
    return deck -- 섞인 덱 반환
end

function drawCard(deck)
    if #deck > 0 then -- 덱에 카드가 남아있으면
        return table.remove(deck) -- 덱의 마지막 카드 뽑아서 반환 (덱에서 제거됨)
    else
        return nil -- 덱이 비어있으면 nil 반환
    end
end


function load_card()
    cardImages = {} -- 카드 이미지 테이블 생성

    cardImages["card_back"] = love.graphics.newImage("Assets/Cards/card_back.png") -- 뒷면 이미지
    cardImages["card_place"] = love.graphics.newImage("Assets/Cards/card_place.png") -- 카드 놓는 공간 이미지

    -- 클로버 (Clubs) 카드 이미지 로드
    cardImages["clubs_2"] = love.graphics.newImage("Assets/Cards/card_clubs_02.png")
    cardImages["clubs_3"] = love.graphics.newImage("Assets/Cards/card_clubs_03.png")
    cardImages["clubs_4"] = love.graphics.newImage("Assets/Cards/card_clubs_04.png")
    cardImages["clubs_5"] = love.graphics.newImage("Assets/Cards/card_clubs_05.png")
    cardImages["clubs_6"] = love.graphics.newImage("Assets/Cards/card_clubs_06.png")
    cardImages["clubs_7"] = love.graphics.newImage("Assets/Cards/card_clubs_07.png")
    cardImages["clubs_8"] = love.graphics.newImage("Assets/Cards/card_clubs_08.png")
    cardImages["clubs_9"] = love.graphics.newImage("Assets/Cards/card_clubs_09.png")
    cardImages["clubs_10"] = love.graphics.newImage("Assets/Cards/card_clubs_10.png")
    cardImages["clubs_J"] = love.graphics.newImage("Assets/Cards/card_clubs_J.png")
    cardImages["clubs_Q"] = love.graphics.newImage("Assets/Cards/card_clubs_Q.png")
    cardImages["clubs_K"] = love.graphics.newImage("Assets/Cards/card_clubs_K.png")
    cardImages["clubs_A"] = love.graphics.newImage("Assets/Cards/card_clubs_A.png")

    -- 다이아몬드 (Diamonds) 카드 이미지 로드
    cardImages["diamonds_2"] = love.graphics.newImage("Assets/Cards/card_diamonds_02.png")
    cardImages["diamonds_3"] = love.graphics.newImage("Assets/Cards/card_diamonds_03.png")
    cardImages["diamonds_4"] = love.graphics.newImage("Assets/Cards/card_diamonds_04.png")
    cardImages["diamonds_5"] = love.graphics.newImage("Assets/Cards/card_diamonds_05.png")
    cardImages["diamonds_6"] = love.graphics.newImage("Assets/Cards/card_diamonds_06.png")
    cardImages["diamonds_7"] = love.graphics.newImage("Assets/Cards/card_diamonds_07.png")
    cardImages["diamonds_8"] = love.graphics.newImage("Assets/Cards/card_diamonds_08.png")
    cardImages["diamonds_9"] = love.graphics.newImage("Assets/Cards/card_diamonds_09.png")
    cardImages["diamonds_10"] = love.graphics.newImage("Assets/Cards/card_diamonds_10.png")
    cardImages["diamonds_J"] = love.graphics.newImage("Assets/Cards/card_diamonds_J.png")
    cardImages["diamonds_Q"] = love.graphics.newImage("Assets/Cards/card_diamonds_Q.png")
    cardImages["diamonds_K"] = love.graphics.newImage("Assets/Cards/card_diamonds_K.png")
    cardImages["diamonds_A"] = love.graphics.newImage("Assets/Cards/card_diamonds_A.png")

    -- 하트 (Hearts) 카드 이미지 로드
    cardImages["hearts_2"] = love.graphics.newImage("Assets/Cards/card_hearts_02.png")
    cardImages["hearts_3"] = love.graphics.newImage("Assets/Cards/card_hearts_03.png")
    cardImages["hearts_4"] = love.graphics.newImage("Assets/Cards/card_hearts_04.png")
    cardImages["hearts_5"] = love.graphics.newImage("Assets/Cards/card_hearts_05.png")
    cardImages["hearts_6"] = love.graphics.newImage("Assets/Cards/card_hearts_06.png")
    cardImages["hearts_7"] = love.graphics.newImage("Assets/Cards/card_hearts_07.png")
    cardImages["hearts_8"] = love.graphics.newImage("Assets/Cards/card_hearts_08.png")
    cardImages["hearts_9"] = love.graphics.newImage("Assets/Cards/card_hearts_09.png")
    cardImages["hearts_10"] = love.graphics.newImage("Assets/Cards/card_hearts_10.png")
    cardImages["hearts_J"] = love.graphics.newImage("Assets/Cards/card_hearts_J.png")
    cardImages["hearts_Q"] = love.graphics.newImage("Assets/Cards/card_hearts_Q.png")
    cardImages["hearts_K"] = love.graphics.newImage("Assets/Cards/card_hearts_K.png")
    cardImages["hearts_A"] = love.graphics.newImage("Assets/Cards/card_hearts_A.png")

    -- 스페이드 (Spades) 카드 이미지 로드
    cardImages["spades_2"] = love.graphics.newImage("Assets/Cards/card_spades_02.png")
    cardImages["spades_3"] = love.graphics.newImage("Assets/Cards/card_spades_03.png")
    cardImages["spades_4"] = love.graphics.newImage("Assets/Cards/card_spades_04.png")
    cardImages["spades_5"] = love.graphics.newImage("Assets/Cards/card_spades_05.png")
    cardImages["spades_6"] = love.graphics.newImage("Assets/Cards/card_spades_06.png")
    cardImages["spades_7"] = love.graphics.newImage("Assets/Cards/card_spades_07.png")
    cardImages["spades_8"] = love.graphics.newImage("Assets/Cards/card_spades_08.png")
    cardImages["spades_9"] = love.graphics.newImage("Assets/Cards/card_spades_09.png")
    cardImages["spades_10"] = love.graphics.newImage("Assets/Cards/card_spades_10.png")
    cardImages["spades_J"] = love.graphics.newImage("Assets/Cards/card_spades_J.png")
    cardImages["spades_Q"] = love.graphics.newImage("Assets/Cards/card_spades_Q.png")
    cardImages["spades_K"] = love.graphics.newImage("Assets/Cards/card_spades_K.png")
    cardImages["spades_A"] = love.graphics.newImage("Assets/Cards/card_spades_A.png")
    return cardImages
end

return {
    createDeck = createDeck,
    shuffleDeck = shuffleDeck,
    drawCard = drawCard,
    load_card = load_card
}