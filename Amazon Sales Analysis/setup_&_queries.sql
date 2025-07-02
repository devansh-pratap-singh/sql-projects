-- Table set-up
CREATE TABLE public.amazon_sales
(
    index serial NOT NULL,
    order_id text,
    order_date date,
    status text,
    fulfilment text,
    sales_channel text,
    ship_service_level text,
    style text,
    sku text,
    category text,
    size text,
    asin text,
    courier_status text,
    qty integer,
    currency text,
    amount numeric(10, 2),
    ship_city text,
    ship_state text,
    ship_postal_code text,
    ship_country text,
    promotion_ids text,
    b2b boolean,
    fulfilled_by text,
    PRIMARY KEY (index)
);

ALTER TABLE IF EXISTS public.amazon_sales
    OWNER to postgres;

-- Data Check
SELECT * FROM amazon_sales LIMIT 10;

-- How many total rows (sales records) are in the dataset?
SELECT COUNT(*) AS total_sales_record FROM amazon_sales;

-- What is the total revenue generated across all sales?
SELECT SUM(amount) AS total_revenue FROM amazon_sales
WHERE status NOT IN ('Cancelled', 'Shipped - Rejected by Buyer', 'Shipped - Returned to Seller', 'Shipped - Returning to Seller');

-- Which product category had the highest total quantity sold?
SELECT category, SUM(qty) AS total_quantity_sold FROM amazon_sales
WHERE status NOT IN ('Cancelled', 'Shipped - Rejected by Buyer', 'Shipped - Returned to Seller', 'Shipped - Returning to Seller')
GROUP BY category
ORDER BY total_quantity_sold DESC
LIMIT 1;

-- What is the average sales amount per transaction?
SELECT AVG(amount) AS average_sales_amount FROM amazon_sales
WHERE status NOT IN ('Cancelled', 'Shipped - Rejected by Buyer', 'Shipped - Returned to Seller', 'Shipped - Returning to Seller');

-- How many unique SKUs were sold?
SELECT COUNT(DISTINCT sku) AS unique_skus_sold FROM amazon_sales
WHERE status NOT IN ('Cancelled', 'Shipped - Rejected by Buyer', 'Shipped - Returned to Seller', 'Shipped - Returning to Seller');

-- What are the top 5 most sold SKUs based on quantity?
SELECT sku, SUM(qty) AS total_quantity_sold FROM amazon_sales
WHERE status NOT IN ('Cancelled', 'Shipped - Rejected by Buyer', 'Shipped - Returned to Seller', 'Shipped - Returning to Seller')
GROUP BY sku
ORDER BY total_quantity_sold DESC
LIMIT 5;

-- Which month had the highest total sales revenue?
SELECT TO_CHAR(order_date, 'YYYY-MM') AS month, SUM(amount) AS total_revenue FROM amazon_sales
WHERE status NOT IN ('Cancelled', 'Shipped - Rejected by Buyer', 'Shipped - Returned to Seller', 'Shipped - Returning to Seller')
GROUP BY month
ORDER BY total_revenue DESC
LIMIT 1;

-- How many sales were B2B transactions vs non-B2B?
SELECT b2b, COUNT(*) AS total_transactions FROM amazon_sales
WHERE status NOT IN ('Cancelled', 'Shipped - Rejected by Buyer', 'Shipped - Returned to Seller', 'Shipped - Returning to Seller')
GROUP BY b2b;

-- Which fulfilment method was used most frequently?
SELECT fulfilment, COUNT(*) AS total_orders FROM amazon_sales
WHERE status NOT IN ('Cancelled', 'Shipped - Rejected by Buyer', 'Shipped - Returned to Seller', 'Shipped - Returning to Seller')
GROUP BY fulfilment
ORDER BY total_orders DESC
LIMIT 1;

-- How many sales were made for each product size?
SELECT size, SUM(qty) AS total_quantity_sold FROM amazon_sales
WHERE status NOT IN ('Cancelled', 'Shipped - Rejected by Buyer', 'Shipped - Returned to Seller', 'Shipped - Returning to Seller')
GROUP BY size
ORDER BY total_quantity_sold DESC;