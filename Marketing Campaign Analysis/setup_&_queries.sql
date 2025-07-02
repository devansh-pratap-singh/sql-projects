-- Table set-up
CREATE TABLE public.marketing_campaign
(
	ID INTEGER NOT NULL,
	Year_Birth INTEGER,
	Education VARCHAR(20),
	Marital_Status VARCHAR(20),
	Income NUMERIC(10,2),
	Kidhome SMALLINT,
	Teenhome SMALLINT,
	Dt_Customer DATE,
	Recency INTEGER,
	MntWines NUMERIC(10,2),
	MntFruits NUMERIC(10,2),
	MntMeatProducts NUMERIC(10,2),
	MntFishProducts NUMERIC(10,2),
	MntSweetProducts NUMERIC(10,2),
	MntGoldProds NUMERIC(10,2),
	NumDealsPurchases INTEGER,
	NumWebPurchases INTEGER,
	NumCatalogPurchases INTEGER,
	NumStorePurchases INTEGER,
	NumWebVisitsMonth INTEGER,
	AcceptedCmp3 SMALLINT,
	AcceptedCmp4 SMALLINT,
	AcceptedCmp5 SMALLINT,
	AcceptedCmp1 SMALLINT,
	AcceptedCmp2 SMALLINT,
	Complain SMALLINT,
	Z_CostContact SMALLINT,
	Z_Revenue SMALLINT,
	Response SMALLINT,
	PRIMARY KEY (ID)
);

ALTER TABLE IF EXISTS public.marketing_campaign
	OWNER to postgres;

-- Data Check
SELECT * FROM marketing_campaign LIMIT 10;

-- How many customer records are in the dataset?
SELECT COUNT(*) AS total_customers FROM marketing_campaign;

-- How many customers accepted each of the five marketing campaigns?
SELECT
	COUNT(*) FILTER (WHERE AcceptedCmp1 = 1) AS accepted_cmp1,
	COUNT(*) FILTER (WHERE AcceptedCmp2 = 1) AS accepted_cmp2,
	COUNT(*) FILTER (WHERE AcceptedCmp3 = 1) AS accepted_cmp3,
	COUNT(*) FILTER (WHERE AcceptedCmp4 = 1) AS accepted_cmp4,
	COUNT(*) FILTER (WHERE AcceptedCmp5 = 1) AS accepted_cmp5
FROM marketing_campaign;

-- What is the overall acceptance rate across all marketing campaigns?
SELECT
	COUNT(*) FILTER (
		WHERE AcceptedCmp1 = 1 OR AcceptedCmp2 = 1 OR AcceptedCmp3 = 1 OR AcceptedCmp4 = 1 OR AcceptedCmp5 = 1
	) * 100.0 / COUNT(*) AS overall_acceptance_rate_percentage
FROM marketing_campaign;

-- How many customers belong to each education level?
SELECT Education, COUNT(*) AS customer_count FROM marketing_campaign
GROUP BY Education
ORDER BY customer_count DESC;

-- What is the average income of customers who accepted the most recent campaign?
SELECT AVG(Income) AS avg_income_responders FROM marketing_campaign
WHERE Response = 1;

-- Which purchase channel had the highest number of purchases?
SELECT channel, total_purchases
FROM (
	SELECT 'Web' AS channel, SUM(NumWebPurchases) AS total_purchases FROM marketing_campaign
	UNION ALL
	SELECT 'Catalog', SUM(NumCatalogPurchases) FROM marketing_campaign
	UNION ALL
	SELECT 'Store', SUM(NumStorePurchases) FROM marketing_campaign
	UNION ALL
	SELECT 'Deals', SUM(NumDealsPurchases) FROM marketing_campaign
) AS channels
ORDER BY total_purchases DESC
LIMIT 1;

-- How many customers visited the website more than five times in the last month?
SELECT COUNT(*) AS customers_with_high_web_visits FROM marketing_campaign
WHERE NumWebVisitsMonth > 5;

-- What is the average number of days since the last purchase across all customers?
SELECT AVG(Recency) AS avg_days_since_last_purchase FROM marketing_campaign;

-- How many customers made at least one purchase using a discount?
SELECT COUNT(*) AS customers_with_discount_purchase FROM marketing_campaign
WHERE NumDealsPurchases > 0;