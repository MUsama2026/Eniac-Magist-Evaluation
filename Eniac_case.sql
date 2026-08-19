USE magist;

-- 1. How many orders are there in the dataset? 
SELECT 
    COUNT(*) as total_orders
FROM
    orders;

-- 2. Are orders actually delivered?
SELECT 
    order_status, COUNT(*) AS num_status
FROM
    orders
GROUP BY order_status;


-- 3. Is Magist having user growth?
SELECT 
    COUNT(customer_id) as num_orders,
    YEAR(order_purchase_timestamp) AS Byyear,
    MONTH(order_purchase_timestamp) AS Bymonth
FROM
    orders
GROUP BY Byyear , Bymonth
ORDER BY Byyear DESC, Bymonth DESC;

-- 4. How many products are there on the products table?
SELECT 
    COUNT(DISTINCT product_id) AS products_count
FROM
    products;
    
-- 5. How many products are there on the products table by categories?
SELECT
    pct.product_category_name_english,
    COUNT(p.product_id) AS num_prod
FROM
    product_category_name_translation AS pct
        INNER JOIN
    products AS p USING (product_category_name)
GROUP BY pct.product_category_name_english
ORDER BY num_prod DESC;

-- 6. How many of those products were present in actual transactions?
SELECT 
    COUNT(DISTINCT product_id) AS num_products
FROM
    order_items;

-- 7. How many tech products were present in actual transactions by categories?    
SELECT 
    pct.product_category_name_english,
    COUNT( DISTINCT ot.product_id) AS num_prod,
    COUNT( DISTINCT ot.product_id) * 100 / (SELECT 
            COUNT(DISTINCT product_id)
        FROM
            order_items) AS tech_perc
FROM
    order_items AS ot
        INNER JOIN
    products AS p USING (product_id)
        INNER JOIN
    product_category_name_translation AS pct USING (product_category_name)
WHERE
    pct.product_category_name_english IN ('computers_accessories' , 'telephony', 'electronics', 'computers')
GROUP BY pct.product_category_name_english
ORDER BY num_prod DESC;

-- 8. What’s the price for the most expensive and cheapest products?
SELECT 
    MAX(price) AS exp_prod,
    MIN(price) AS cheap_prod
FROM
    order_items;

-- 9. Which category the most expensive products belong?    
  SELECT 
    pct.product_category_name_english, product_id, price AS price
FROM
    order_items AS o
        INNER JOIN
    products AS p USING (product_id)
        INNER JOIN
    product_category_name_translation AS pct USING (product_category_name)
WHERE
    price = 6735;

-- 10. What are the highest and lowest payment values?
SELECT 
    AVG(payment_value) AS avg_payment
FROM
    order_payments
ORDER BY avg_payment DESC;

-- 11. What’s the average price of the products being sold?
SELECT 
    AVG(price) AS avg_price
FROM
    (SELECT DISTINCT
        product_id, price
    FROM
        order_items) AS unique_products; 

-- 12. What’s the average price of the tech products being sold?
SELECT 
    AVG(price) AS avg_tech_price
FROM
    (SELECT 
        pct.product_category_name_english, ot.product_id, ot.price
    FROM
        order_items AS ot
		INNER JOIN 
    products AS p USING (product_id)
		INNER JOIN 
    product_category_name_translation AS pct USING (product_category_name)
    WHERE
        pct.product_category_name_english IN ('computers_accessories' , 'telephony', 'electronics', 'computers')
    GROUP BY pct.product_category_name_english , ot.product_id , ot.price) AS tech_products; 

-- 13. Are expensive tech products popular? Direct Answer is NO. Low price tech products are more popular than the expensive.
SELECT 
    CASE
        WHEN ot.price <= 50 THEN 'Low Price'
        WHEN ot.price > 50 AND ot.price <= 130 THEN 'Medium Price'
        WHEN ot.price > 500 THEN 'Expensive Price'
        ELSE 'unk'
    END AS price_category,
    COUNT(*) AS num_sales,
    COUNT(DISTINCT ot.product_id) AS num_distinct_products,
    ROUND(COUNT(*) / COUNT(DISTINCT ot.product_id),
            2) AS avg_sales_per_product
FROM
    order_items AS ot
        INNER JOIN
    products AS p USING (product_id)
        INNER JOIN
    product_category_name_translation AS pct USING (product_category_name)
WHERE
    pct.product_category_name_english IN ('computers_accessories' , 'telephony', 'electronics', 'computers')
GROUP BY price_category
ORDER BY avg_sales_per_product DESC;
 
 -- 14. How many months of data are included in the magist database? Ans. 25 Months from 09-2016 to 10-2018
SELECT 
    COUNT(DISTINCT DATE_FORMAT(order_purchase_timestamp, '%Y-%m')) AS num_months
FROM
    orders;

-- 15. How many sellers are there? How many Tech sellers are there? What percentage of overall sellers are Tech sellers?

-- TOTAL SELLERS
SELECT 
    COUNT(DISTINCT seller_id) AS total_sellers
FROM
    sellers;

-- TECH SELLERS
SELECT 
    COUNT(DISTINCT s.seller_id) AS num_sellers
FROM
    sellers AS s
        INNER JOIN
    order_items AS ot USING (seller_id)
        INNER JOIN
    products AS p USING (product_id)
        INNER JOIN
    product_category_name_translation AS pct USING (product_category_name)
WHERE
    pct.product_category_name_english IN ('computers_accessories' , 'telephony', 'electronics', 'computers');

-- 16. What is the total amount earned by all sellers? What is the total amount earned by all Tech sellers?

-- By all Sellers (Answer: 13591643.7 Euros)
SELECT 
    ROUND(SUM(price),2) as total_amount_all_seller
FROM
    sellers AS s
        INNER JOIN
    order_items USING (seller_id);

-- By tech Sellers (Answer:  1618831.72 Euros)
SELECT 
    ROUND(SUM(price),2) as total_amount_all_seller
FROM
    sellers AS s
        INNER JOIN
    order_items AS ot USING (seller_id)
        INNER JOIN
    products AS p USING (product_id)
        INNER JOIN
    product_category_name_translation AS pct USING (product_category_name)
WHERE
    pct.product_category_name_english IN ('computers_accessories' , 'telephony', 'electronics', 'computers');

-- 17. Can you work out the average monthly income of all sellers? Can you work out the average monthly income of Tech sellers?

-- Approx. 12 percent of total amount by all sellers are the contribution by tech sellers
-- By all Sellers (Answer: 543665.75 Euros)
SELECT 
    ROUND(SUM(price),2)/25 as total_amount_all_seller
FROM
    sellers AS s
        INNER JOIN
    order_items USING (seller_id);

-- By tech Sellers (Answer:  64753.27 Euros)
SELECT 
    ROUND(SUM(price),2)/25 as total_amount_all_seller
FROM
    sellers AS s
        INNER JOIN
    order_items AS ot USING (seller_id)
        INNER JOIN
    products AS p USING (product_id)
        INNER JOIN
    product_category_name_translation AS pct USING (product_category_name)
WHERE
    pct.product_category_name_english IN ('computers_accessories' , 'telephony', 'electronics', 'computers');

-- 18. What’s the average time between the order being placed and the product being delivered? Answer: ~12.5 days
SELECT 
    AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) AS avg_days_to_deliver
FROM
    orders;
    
-- 19. How many orders are delivered on time vs orders delivered with a delay? Answer: 89% orders are delivered on time
SELECT 
    CASE
        WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 'On time'
        WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 'Delayed'
        ELSE 'Not yet delivered'
    END AS delivery_status,
    COUNT(*) AS num_orders
FROM
    orders
GROUP BY 
    delivery_status
ORDER BY 
    num_orders DESC; 

-- 20. Check if tech products are delivered late? Answer: Approx. 90 % tech orders were delivered on time.
SELECT 
    CASE
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 'On time'
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'Delayed'
        ELSE 'Not yet delivered'
    END AS delivery_status,
    COUNT(DISTINCT order_id) AS num_orders
FROM
		orders as o
        INNER JOIN
    order_items AS ot USING (order_id)
        INNER JOIN
    products AS p USING (product_id)
        INNER JOIN
    product_category_name_translation AS pct USING (product_category_name)
WHERE
    pct.product_category_name_english IN ('computers_accessories' , 'telephony', 'electronics', 'computers')
GROUP BY 
    delivery_status
ORDER BY 
    num_orders DESC;   

-- 21. Check the review score of the tech products?
SELECT 
    review_score, COUNT(review_score)
FROM
    order_reviews
        INNER JOIN
    orders as o USING (order_id)
        INNER JOIN
    order_items AS ot USING (order_id)
        INNER JOIN
    products AS p USING (product_id)
        INNER JOIN
    product_category_name_translation AS pct USING (product_category_name)
WHERE
    pct.product_category_name_english IN ('computers_accessories' , 'telephony', 'electronics', 'computers')
Group by review_score
ORDER BY review_score DESC;
    
-- 22. Check the payment type considered for the tech products?
SELECT 
    op.payment_type, COUNT(op.payment_type)
FROM
    order_payments as op
		INNER JOIN
    orders as o USING (order_id)
        INNER JOIN
    order_items AS ot USING (order_id)
        INNER JOIN
    products AS p USING (product_id)
        INNER JOIN
    product_category_name_translation AS pct USING (product_category_name)
WHERE
    pct.product_category_name_english IN ('computers_accessories' , 'telephony', 'electronics', 'computers')
GROUP BY op.payment_type;

-- 23. Do delayed orders get worse reviews than on-time ones?

-- For All products:
SELECT 
    CASE
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 'On time'
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'Delayed'
        ELSE 'Not yet delivered'
    END AS delivery_status,
    COUNT(*) AS num_orders,
    ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM
    orders AS o
        INNER JOIN
    order_reviews AS r USING (order_id)
GROUP BY 
    delivery_status
ORDER BY 
    avg_review_score DESC;
    
-- For Tech products only:

SELECT 
    CASE
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 'On time'
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'Delayed'
        ELSE 'Not yet delivered'
    END AS delivery_status,
    COUNT(DISTINCT o.order_id) AS num_orders,
    ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM
    orders AS o
        INNER JOIN
    order_reviews AS r USING (order_id)
        INNER JOIN
    order_items AS ot USING (order_id)
        INNER JOIN
    products AS p USING (product_id)
        INNER JOIN
    product_category_name_translation AS pct USING (product_category_name)
WHERE
    pct.product_category_name_english IN ('computers_accessories', 'telephony', 'electronics', 'computers')
GROUP BY 
    delivery_status
ORDER BY 
    avg_review_score DESC;
    
-- 24. Delivery time of tech product from placement to delivered status?
SELECT 
    CASE
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 'On time'
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'Delayed'
        ELSE 'Not yet delivered'
    END AS delivery_status,
    COUNT(DISTINCT order_id) AS num_orders,
    AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)) AS avg_days_to_deliver
FROM
		orders as o
        INNER JOIN
    order_items AS ot USING (order_id)
        INNER JOIN
    products AS p USING (product_id)
        INNER JOIN
    product_category_name_translation AS pct USING (product_category_name)
WHERE
    pct.product_category_name_english IN ('computers_accessories' , 'telephony', 'electronics', 'computers')
GROUP BY 
    delivery_status
ORDER BY 
    num_orders DESC;
    
-- 25. Check the tech customers location? Answer: Most of the customers are from the urban cities.
SELECT 
    state, COUNT(state) AS num_customers
FROM
    customers AS c
        JOIN
    geo AS g ON c.customer_zip_code_prefix = g.zip_code_prefix
        INNER JOIN
    orders AS o USING (customer_id)
        INNER JOIN
    order_items AS ot USING (order_id)
        INNER JOIN
    products AS p USING (product_id)
        INNER JOIN
    product_category_name_translation AS pct USING (product_category_name)
WHERE
    pct.product_category_name_english IN ('computers_accessories' , 'telephony', 'electronics', 'computers')
GROUP BY state
ORDER BY num_customers DESC;

-- 26. Check the sellers location? Answer: Most of the sellers are from the urban cities. 14 tech sellers
SELECT 
    state, COUNT(state) AS num_sellers
FROM
    geo AS g
        INNER JOIN
    sellers AS s ON s.seller_zip_code_prefix = g.zip_code_prefix
        INNER JOIN
    order_items AS ot USING (seller_id)
        INNER JOIN
    products AS p USING (product_id)
        INNER JOIN
    product_category_name_translation AS pct USING (product_category_name)
WHERE
    pct.product_category_name_english IN ('computers_accessories' , 'telephony', 'electronics', 'computers')
GROUP BY state
ORDER BY num_sellers DESC;
    
-- 27. Delivery time of the tech products for customers based in Sao Paulo and RJ?
SELECT 
    CASE
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 'On time'
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'Delayed'
        ELSE 'Not yet delivered'
    END AS delivery_status,
    COUNT(DISTINCT order_id) AS num_orders,
    AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)) AS avg_days_to_deliver,
    g.state as State
FROM
		geo AS g
        INNER JOIN
    customers AS c ON c.customer_zip_code_prefix = g.zip_code_prefix
		INNER JOIN
	orders AS o USING (customer_id)
        INNER JOIN
    order_items as ot USING (order_id)
        INNER JOIN
    products AS p USING (product_id)
        INNER JOIN
    product_category_name_translation AS pct USING (product_category_name)
WHERE
    pct.product_category_name_english IN ('computers_accessories' , 'telephony', 'electronics', 'computers') AND g.state IN ('SP','RJ')
GROUP BY 
    g.state, delivery_status
ORDER BY 
    num_orders DESC;
    
-- 28. Percentage of tech sales priced above 300, 500 and 1000 Euros.
-- For 300 ==> 4.56 percent
-- For 500 ==> 2.99 percent
-- For 1000 ==> 1.13 percent

SELECT 
    ROUND(SUM(CASE
                WHEN ot.price > 1000 THEN 1
                ELSE 0
            END) * 100.0 /15342 ,2) AS pct_above_300
FROM
    order_items AS ot
        INNER JOIN
    products AS p USING (product_id)
        INNER JOIN
    product_category_name_translation AS pct USING (product_category_name)
WHERE
    pct.product_category_name_english IN ('computers_accessories' , 'telephony', 'electronics', 'computers');

-- 29. How many tech sellers are based in 'SP' or 'RJ' out of 444 total tech sellers?
-- SP ==> 268
-- RJ ==> 22
SELECT 
    COUNT(DISTINCT s.seller_id) AS num_sellers
FROM
    geo as g join 
    sellers AS s ON g.zip_code_prefix = s.seller_zip_code_prefix
        INNER JOIN
    order_items AS ot USING (seller_id)
        INNER JOIN
    products AS p USING (product_id)
        INNER JOIN
    product_category_name_translation AS pct USING (product_category_name)
WHERE
    pct.product_category_name_english IN ('computers_accessories' , 'telephony', 'electronics', 'computers') AND g.state IN ('RJ');