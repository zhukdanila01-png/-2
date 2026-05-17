USE BookmakerDB;
GO

CREATE OR ALTER VIEW v_GraphEdgesForPowerBI AS
-- 1. Ребра ставок: Игрок -> Исход (Тип связи: Ставка)
SELECT 
    P.name AS [Source], 
    O.outcome_name AS [Target], 
    N'Ставка' AS [LinkType],
    PB.bet_amount AS [Weight]
FROM Player P, PlacedBet PB, Odds O
WHERE MATCH(P-(PB)->O)

UNION ALL

-- 2. Ребра структуры: Исход -> Матч (Тип связи: Матч)
SELECT 
    O.outcome_name AS [Source], 
    M.teams AS [Target], 
    N'Структура' AS [LinkType],
    1000.00 AS [Weight] 
FROM Odds O, BelongsTo B, Match M
WHERE MATCH(O-(B)->M)

UNION ALL

-- 3. Социальные ребра: Игрок -> Игрок (Тип связи: Подписка)
SELECT 
    P1.name AS [Source], 
    P2.name AS [Target], 
    N'Подписка' AS [LinkType],
    500.00 AS [Weight] 
FROM Player P1, FollowsPlayer F, Player P2
WHERE MATCH(P1-(F)->P2);
GO

SELECT * FROM v_GraphEdgesForPowerBI;