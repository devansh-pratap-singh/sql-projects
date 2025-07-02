-- Table set-up
CREATE TABLE public.customer_support_tickets
(
	ticket_id SERIAL NOT NULL,
    customer_name TEXT,
    customer_email TEXT,
    customer_age INTEGER,
    customer_gender TEXT,
    product_purchased TEXT,
    date_of_purchase DATE,
    ticket_type TEXT,
    ticket_subject TEXT,
    ticket_description TEXT,
    ticket_status TEXT,
    resolution TEXT,
    ticket_priority TEXT,
    ticket_channel TEXT,
    first_response_time TIMESTAMP,
    time_to_resolution TIMESTAMP,
    customer_satisfaction_rating NUMERIC(2,1),
	PRIMARY KEY (ticket_id)
);

ALTER TABLE IF EXISTS public.customer_support_tickets
	OWNER to postgres;

-- Data Check
SELECT * FROM customer_support_tickets LIMIT 10;

-- How many support tickets are in the dataset?
SELECT COUNT(*) AS total_tickets FROM customer_support_tickets;

-- What are the most common issue types reported?
SELECT ticket_type, COUNT(*) AS count FROM customer_support_tickets
GROUP BY ticket_type
ORDER BY count DESC;

-- How many tickets were submitted through each support channel?
SELECT ticket_channel, COUNT(*) AS count FROM customer_support_tickets
GROUP BY ticket_channel
ORDER BY count DESC;

-- What is the average resolution time across all tickets?
SELECT AVG(first_response_time - time_to_resolution) AS avg_resolution_time FROM customer_support_tickets
WHERE first_response_time IS NOT NULL AND time_to_resolution IS NOT NULL;

-- How many tickets were resolved on the same day they were submitted?
SELECT COUNT(*) AS same_day_resolutions FROM customer_support_tickets
WHERE DATE(first_response_time) = DATE(time_to_resolution);

-- How many tickets were submitted each month?
SELECT TO_CHAR(first_response_time, 'YYYY-MM') AS month, COUNT(*) AS ticket_count FROM customer_support_tickets
GROUP BY month
ORDER BY month;

-- What is the total number of unresolved tickets?
SELECT COUNT(*) AS unresolved_tickets FROM customer_support_tickets
WHERE time_to_resolution IS NULL;