SQL Code for Usage Funnels with Warby Parker 
by Robert Hozeska

Step #1
=======
SELECT *
FROM survey
LIMIT 10;


Step #2
=======
SELECT question,
   COUNT(DISTINCT user_id)
FROM survey
GROUP BY question;

Step #3
=======
Data from Step #2 put into excel spreadsheet and doing calculations

Step #4
=======
SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;

Step #5
=======
SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id
LIMIT 10;

Step #6
=======
Nothing specified to be done, just a statement of what we could do?

OK, I have an Aggregate that shows the number of records, the number 
for try ons and the number of bought
====================================
WITH funnels AS (
	SELECT DISTINCT q.user_id,
   	h.user_id IS NOT NULL AS 'is_home_try_on',
   	h.number_of_pairs,
   	p.user_id IS NOT NULL AS 'is_purchase'
	FROM quiz q
	LEFT JOIN home_try_on h
   	ON q.user_id = h.user_id
	LEFT JOIN purchase p
   	ON p.user_id = q.user_id)
   
SELECT COUNT(*) as 'browse',
	SUM(is_home_try_on) as 'try',
  	SUM(is_purchase) as 'bought'
FROM funnels;


Total Purchase Rates
====================
WITH funnels AS (
	SELECT DISTINCT q.user_id,
   	h.user_id IS NOT NULL AS 'is_home_try_on',
   	h.number_of_pairs AS 'pairs',
   	p.user_id IS NOT NULL AS 'is_purchase',
  	p.price IS NULL AS 'NoSale'
	FROM quiz q
	LEFT JOIN home_try_on h
   	ON q.user_id = h.user_id
	LEFT JOIN purchase p
   	ON p.user_id = q.user_id)
 
SELECT COUNT(*) as 'U_IDs',
	SUM(is_purchase) AS 'bought_cnt',
  SUM(NoSale) AS 'NoSale_cnt',
  1.0 * SUM(is_purchase) / (SUM(is_purchase) +  SUM(NoSale))  AS 'bought_percent'
  
FROM funnels;


3 Pair Count, 5 Pair Count
==========================
WITH funnels AS (
	SELECT DISTINCT q.user_id,
   	h.user_id IS NOT NULL AS 'is_home_try_on',
   	h.number_of_pairs AS 'pairs',
   	p.user_id IS NOT NULL AS 'is_purchase'
	FROM quiz q
	LEFT JOIN home_try_on h
   	ON q.user_id = h.user_id
	LEFT JOIN purchase p
   	ON p.user_id = q.user_id)
   
SELECT COUNT(*) as 'browse',
	SUM(is_home_try_on) AS 'try',
  	SUM(is_purchase) AS 'bought',
  	SUM(pairs = '3 pairs') AS '3pair',
  	SUM(pairs = '5 pairs') AS '5pair'
FROM funnels;


3 Pair Percent vs TryOn
=======================
WITH funnels AS (
	SELECT DISTINCT q.user_id,
   	h.user_id IS NOT NULL AS 'is_home_try_on',
   	h.number_of_pairs AS 'pairs',
   	p.user_id IS NOT NULL AS 'is_purchase'
	FROM quiz q
	LEFT JOIN home_try_on h
   	ON q.user_id = h.user_id
	LEFT JOIN purchase p
   	ON p.user_id = q.user_id
WHERE h.number_of_pairs LIKE '%3%')

SELECT COUNT(*) as 'browse',
	SUM(is_home_try_on) AS 'try3',
  	SUM(is_purchase) AS 'bought3’,
 	1.0 * SUM(is_purchase) / SUM(is_home_try_on)  AS 'percent'
FROM funnels;


5 Pair Percent vs TryOn
=======================
WITH funnels AS (
	SELECT DISTINCT q.user_id,
   	h.user_id IS NOT NULL AS 'is_home_try_on',
   	h.number_of_pairs AS 'pairs',
   	p.user_id IS NOT NULL AS 'is_purchase'
	FROM quiz q
	LEFT JOIN home_try_on h
   	ON q.user_id = h.user_id
	LEFT JOIN purchase p
   	ON p.user_id = q.user_id
WHERE h.number_of_pairs LIKE '%5%')

SELECT COUNT(*) as 'browse',
	SUM(is_home_try_on) AS 'try5’,
 	SUM(is_purchase) AS 'bought5’,
 	1.0 * SUM(is_purchase) / SUM(is_home_try_on)  AS 'percent'
FROM funnels;


Most Common Type Purchased
==========================
SELECT  p.model_name as 'Model',
	COUNT(DISTINCT(p.user_id)) as 'Count'
FROM purchase p
GROUP BY p.model_name
ORDER BY Count DESC;