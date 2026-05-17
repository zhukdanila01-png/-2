USE master;
DROP DATABASE IF EXISTS BookmakerDB;
GO
CREATE DATABASE BookmakerDB;
GO
USE BookmakerDB;
GO

-- ==========================================
-- 1. СОЗДАНИЕ ТАБЛИЦ УЗЛОВ (NODES)
-- ==========================================

CREATE TABLE Player
(
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    balance DECIMAL(10, 2) NOT NULL
) AS NODE;

CREATE TABLE Match
(
    id INT NOT NULL PRIMARY KEY,
    teams NVARCHAR(100) NOT NULL,
    sport_type NVARCHAR(30) NOT NULL,
    match_date DATETIME NOT NULL
) AS NODE;

CREATE TABLE Odds
(
    id INT NOT NULL PRIMARY KEY,
    outcome_name NVARCHAR(50) NOT NULL, 
    value DECIMAL(5, 2) NOT NULL        
) AS NODE;


-- ==========================================
-- 2. СОЗДАНИЕ ТАБЛИЦ РЁБЕР (EDGES) И ОГРАНИЧЕНИЙ
-- ==========================================

CREATE TABLE PlacedBet (bet_amount DECIMAL(10, 2), bet_date DATETIME) AS EDGE; 
CREATE TABLE BelongsTo AS EDGE; 
CREATE TABLE FollowsPlayer AS EDGE; 

ALTER TABLE PlacedBet
ADD CONSTRAINT EC_PlacedBet CONNECTION (Player TO Odds);

ALTER TABLE BelongsTo
ADD CONSTRAINT EC_BelongsTo CONNECTION (Odds TO Match);

ALTER TABLE FollowsPlayer
ADD CONSTRAINT EC_FollowsPlayer CONNECTION (Player TO Player);
GO


-- ==========================================
-- 3. ЗАПОЛНЕНИЕ ТАБЛИЦ УЗЛОВ
-- ==========================================

INSERT INTO Player (id, name, balance)
VALUES 
    (1, N'Иван', 5000.00),
    (2, N'Алексей', 12000.50),
    (3, N'Дмитрий', 350.00),
    (4, N'Елена', 25000.00),
    (5, N'Артем', 1500.00),
    (6, N'Никита', 800.00),
    (7, N'Михаил', 43000.00),
    (8, N'Анна', 7000.00),
    (9, N'Сергей', 9500.00),
    (10, N'Павел', 150.00);

INSERT INTO Match (id, teams, sport_type, match_date)
VALUES 
    (1, N'Реал Мадрид - Барселона', N'Футбол', '20260520 21:45:00'),
    (2, N'Ливерпуль - Манчестер Сити', N'Футбол', '20260521 22:00:00'),
    (3, N'Лейкерс - Селтикс', N'Баскетбол', '20260522 04:00:00'),
    (4, N'Джокович - Алькарас', N'Теннис', '20260523 15:00:00'),
    (5, N'Спартак - Зенит', N'Футбол', '20260524 19:00:00'),
    (6, N'ЦСКА - СКА', N'Хоккей', '20260525 19:30:00'),
    (7, N'Чикаго Буллз - Майами Хит', N'Баскетбол', '20260526 03:30:00'),
    (8, N'Медведев - Синнер', N'Теннис', '20260527 16:00:00'),
    (9, N'Милан - Интер', N'Футбол', '20260528 21:45:00'),
    (10, N'ПСЖ - Бавария', N'Футбол', '20260529 22:00:00');

INSERT INTO Odds (id, outcome_name, value)
VALUES 
    (1, N'Победа Реал Мадрид', 2.10),
    (2, N'Победа Барселоны', 3.40),
    (3, N'Победа Ливерпуля', 2.50),
    (4, N'Победа Лейкерс', 1.85),
    (5, N'Победа Джоковича', 1.65),
    (6, N'Победа Спартака', 2.90),
    (7, N'Победа ЦСКА', 2.15),
    (8, N'Победа Чикаго Буллз', 2.20),
    (9, N'Победа Медведева', 2.40),
    (10, N'Победа ПСЖ', 2.05);
GO


-- ==========================================
-- 4. ЗАПОЛНЕНИЕ ТАБЛИЦ РЁБЕР (СВЯЗИ)
-- ==========================================

INSERT INTO BelongsTo ($from_id, $to_id)
VALUES 
    ((SELECT $node_id FROM Odds WHERE id = 1), (SELECT $node_id FROM Match WHERE id = 1)),
    ((SELECT $node_id FROM Odds WHERE id = 2), (SELECT $node_id FROM Match WHERE id = 1)),
    ((SELECT $node_id FROM Odds WHERE id = 3), (SELECT $node_id FROM Match WHERE id = 2)),
    ((SELECT $node_id FROM Odds WHERE id = 4), (SELECT $node_id FROM Match WHERE id = 3)),
    ((SELECT $node_id FROM Odds WHERE id = 5), (SELECT $node_id FROM Match WHERE id = 4)),
    ((SELECT $node_id FROM Odds WHERE id = 6), (SELECT $node_id FROM Match WHERE id = 5)),
    ((SELECT $node_id FROM Odds WHERE id = 7), (SELECT $node_id FROM Match WHERE id = 6)),
    ((SELECT $node_id FROM Odds WHERE id = 8), (SELECT $node_id FROM Match WHERE id = 7)),
    ((SELECT $node_id FROM Odds WHERE id = 9), (SELECT $node_id FROM Match WHERE id = 8)),
    ((SELECT $node_id FROM Odds WHERE id = 10), (SELECT $node_id FROM Match WHERE id = 10));

INSERT INTO PlacedBet ($from_id, $to_id, bet_amount, bet_date)
VALUES 
    ((SELECT $node_id FROM Player WHERE id = 1), (SELECT $node_id FROM Odds WHERE id = 1), 500.00, '20260515'),
    ((SELECT $node_id FROM Player WHERE id = 2), (SELECT $node_id FROM Odds WHERE id = 1), 2000.00, '20260515'),
    ((SELECT $node_id FROM Player WHERE id = 3), (SELECT $node_id FROM Odds WHERE id = 2), 150.00, '20260516'),
    ((SELECT $node_id FROM Player WHERE id = 4), (SELECT $node_id FROM Odds WHERE id = 3), 5000.00, '20260516'),
    ((SELECT $node_id FROM Player WHERE id = 5), (SELECT $node_id FROM Odds WHERE id = 4), 300.00, '20260516'),
    ((SELECT $node_id FROM Player WHERE id = 6), (SELECT $node_id FROM Odds WHERE id = 5), 400.00, '20260517'),
    ((SELECT $node_id FROM Player WHERE id = 7), (SELECT $node_id FROM Odds WHERE id = 1), 10000.00, '20260517'),
    ((SELECT $node_id FROM Player WHERE id = 8), (SELECT $node_id FROM Odds WHERE id = 6), 1200.00, '20260517'),
    ((SELECT $node_id FROM Player WHERE id = 9), (SELECT $node_id FROM Odds WHERE id = 7), 800.00, '20260517'),
    ((SELECT $node_id FROM Player WHERE id = 10), (SELECT $node_id FROM Odds WHERE id = 8), 100.00, '20260517');

INSERT INTO FollowsPlayer ($from_id, $to_id)
VALUES 
    ((SELECT $node_id FROM Player WHERE id = 2), (SELECT $node_id FROM Player WHERE id = 1)), 
    ((SELECT $node_id FROM Player WHERE id = 3), (SELECT $node_id FROM Player WHERE id = 2)), 
    ((SELECT $node_id FROM Player WHERE id = 5), (SELECT $node_id FROM Player WHERE id = 3)), 
    ((SELECT $node_id FROM Player WHERE id = 6), (SELECT $node_id FROM Player WHERE id = 5)),
    ((SELECT $node_id FROM Player WHERE id = 8), (SELECT $node_id FROM Player WHERE id = 7)), 
    ((SELECT $node_id FROM Player WHERE id = 9), (SELECT $node_id FROM Player WHERE id = 8)), 
    ((SELECT $node_id FROM Player WHERE id = 10), (SELECT $node_id FROM Player WHERE id = 9));
GO


-- ==========================================
-- 5. ЗАПРОСЫ С ИСПОЛЬЗОВАНИЕМ MATCH
-- ==========================================

-- Запрос 1: Игроки, поставившие на матч "Реал Мадрид - Барселона"
SELECT P.name AS PlayerName, O.outcome_name, PB.bet_amount
FROM Player P, PlacedBet PB, Odds O, BelongsTo B, Match M
WHERE MATCH(P-(PB)->O-(B)->M)
  AND M.teams = N'Реал Мадрид - Барселона';

-- Запрос 2: Матчи и исходы, на которые ставил игрок "Алексей"
SELECT M.teams, O.outcome_name, PB.bet_amount
FROM Player P, PlacedBet PB, Odds O, BelongsTo B, Match M
WHERE MATCH(P-(PB)->O-(B)->M)
  AND P.name = N'Алексей';

-- Запрос 3: Сумма ставок на каждый вид спорта
SELECT M.sport_type, SUM(PB.bet_amount) AS TotalStaked
FROM Player P, PlacedBet PB, Odds O, BelongsTo B, Match M
WHERE MATCH(P-(PB)->O-(B)->M)
GROUP BY M.sport_type;

-- Запрос 4: Подписчики, чьи капперы ставят больше 1000
SELECT P1.name AS Follower, P2.name AS Capper, O.outcome_name, PB.bet_amount
FROM Player P1, FollowsPlayer F, Player P2, PlacedBet PB, Odds O
WHERE MATCH(P1-(F)->P2-(PB)->O)
  AND PB.bet_amount > 1000;

-- Запрос 5: Игроки, выбравшие один исход
SELECT P1.name AS Player1, P2.name AS Player2, O.outcome_name AS CommonOutcome
FROM Player P1, PlacedBet PB1, Odds O, PlacedBet PB2, Player P2
WHERE MATCH(P1-(PB1)->O<-(PB2)-P2)
  AND P1.id < P2.id;
GO


-- ==========================================
-- 6. ЗАПРОСЫ С SHORTEST_PATH 
-- ==========================================

-- Запрос 6 (Шаблон "+"): Цепочка от Никиты до Ивана
WITH ChainCTE AS (
    SELECT 
        P1.name AS StartPlayer, 
        STRING_AGG(P2.name, ' -> ') WITHIN GROUP (GRAPH PATH) AS ChainOfInfluence,
        LAST_VALUE(P2.$node_id) WITHIN GROUP (GRAPH PATH) AS LastNodeId 
    FROM 
        Player AS P1,
        FollowsPlayer FOR PATH AS fp,
        Player FOR PATH AS P2
    WHERE MATCH(SHORTEST_PATH(P1(-(fp)->P2)+))
      AND P1.name = N'Никита'
)
SELECT 
    CTE.StartPlayer, 
    CTE.ChainOfInfluence
FROM 
    ChainCTE CTE
JOIN 
    Player TargetPlayer ON CTE.LastNodeId = TargetPlayer.$node_id
WHERE 
    TargetPlayer.name = N'Иван';



-- Запрос 7 (Шаблон "{1,n}"): 
WITH RecommendationCTE AS (
    SELECT 
        P1.name AS SubscribedPlayer,
        STRING_AGG(P2.name, ' -> ') WITHIN GROUP (GRAPH PATH) AS RecommendationPath,
        LAST_VALUE(P2.$node_id) WITHIN GROUP (GRAPH PATH) AS TargetNodeId 
    FROM 
        Player AS P1,
        FollowsPlayer FOR PATH AS fp,
        Player FOR PATH AS P2
    WHERE MATCH(SHORTEST_PATH(P1(-(fp)->P2){1,3}))
      AND P1.name = N'Павел'
)
SELECT 
    CTE.SubscribedPlayer,
    CTE.RecommendationPath,
    TargetPlayer.name AS TargetCapper 
FROM 
    RecommendationCTE CTE
JOIN 
    Player TargetPlayer ON CTE.TargetNodeId = TargetPlayer.$node_id;
GO