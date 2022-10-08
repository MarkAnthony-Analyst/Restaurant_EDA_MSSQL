SELECT * FROM Restaurant_Orders;

SELECT * FROM Restaurant_Details;

--I already check null values in excel so no need for checking nulls here

/*Order_Date has the same data which is "2022-01-01" so it's useless to have the datetime column
We need to extract the time so we can use it for further analysis
Add a new column called "Order_Time"*/
ALTER TABLE Restaurant_Orders
ADD Order_Time TIME;

--Convert the old order_date column from datetime to time(order_time)
UPDATE Restaurant_Orders
SET Order_Time = CONVERT(Time, Order_Date, 120);


--Delete the old date column
ALTER TABLE Restaurant_Orders
DROP COLUMN Order_Date;


--What is the total amount of orders?
SELECT SUM(o.order_amount)As Total_Amount
FROM Restaurant_Orders o;


--what is the total quantity of items sold?
SELECT SUM(o.Quantity_of_Items)As Total_Qty
FROM Restaurant_Orders o;


--what is the average delivery time?
SELECT AVG(o.[Delivery_Time_Taken (mins)]) As Average_Delivery_Time
FROM Restaurant_Orders o;


--what is the average rating for food?
SELECT AVG(o.Customer_Rating_Food) AS Avg_Food_Rating
FROM Restaurant_Orders o;


--Customer with Highest Amount of Order
SELECT Customer_Name, 
		SUM(Order_Amount) 'Total_Amount'
FROM Restaurant_Orders
GROUP BY Customer_Name
ORDER BY 2 DESC;


--Which restaurant received the most orders?
SELECT TOP 5 d.RestaurantName, 
		SUM(o.Order_Amount) 'Total_Amount'
FROM Restaurant_Orders o
JOIN Restaurant_Details d
ON o.Restaurant_ID = d.RestaurantID
GROUP BY d.RestaurantName
ORDER BY 2 DESC;

--Which customer ordered the most?
SELECT o.Customer_Name, 
		COUNT(Distinct o.Order_ID) 'Order Count'
FROM Restaurant_Orders o
GROUP BY o.Customer_Name
ORDER BY 2 DESC;

-
-Which customers has the highest quantity of orders?
SELECT o.Customer_Name, 
		SUM(o.Quantity_of_Items) 'Order Quantity'
FROM Restaurant_Orders o
GROUP BY o.Customer_Name
ORDER BY 2 DESC;


--When do customers order more in a day?
SELECT Order_Time, 
		COUNT(o.order_Id) AS Order_Count
FROM Restaurant_Orders o
GROUP BY o.Order_Time
ORDER BY 2 DESC;


-- Which is the most liked cuisine?
--Chinese and North Indian has the same amount of orders
SELECT d.Cuisine, 
		Count(O.Order_ID) 'Number of Orders'
FROM Restaurant_Orders o
JOIN Restaurant_Details d
ON o.Restaurant_ID = d.RestaurantID
GROUP BY d.Cuisine
ORDER BY 2 DESC;


--How much sales are we getting from each cuisine and how many quantity we are selling?
SELECT d.Cuisine, 
		SUM(o.Quantity_of_Items) AS Quantity,
		SUM(o.Order_Amount) AS Amount
FROM Restaurant_Orders o
JOIN Restaurant_Details d
ON o.Restaurant_ID = d.RestaurantID
GROUP BY d.Cuisine
ORDER BY 3 DESC;


--Which zone has the most sales?
SELECT d.Zone, 
		SUM(o.Order_Amount) AS Amount
FROM Restaurant_Orders o
JOIN Restaurant_Details d
ON o.Restaurant_ID = d.RestaurantID
GROUP BY d.Zone
ORDER BY d.Zone;


--What payment mode was used frequently by customers?
-- I will categorize it to two; Cash and card 
WITH Payment_Mode_CTE AS
(
Select o.Payment_Mode,
		CASE
		WHEN o.Payment_Mode = 'Debit Card' THEN 'Card'
		WHEN o.Payment_Mode = 'Credit Card' THEN 'Card'
		ELSE 'Cash'
		END AS 'Mode_of_Payment'
FROM Restaurant_Orders o
)
SELECT Mode_of_Payment, COUNT(Mode_of_Payment) AS 'Quantity'
FROM Payment_Mode_CTE
GROUP BY Mode_of_Payment
ORDER BY 'Quantity' DESC;


--What time of the day did customers order the most ?
WITH Time_Category AS
(
Select 
		CASE
		WHEN o.Order_Time BETWEEN '12:00:00' AND '17:59:00' THEN 'Afternoon'
		WHEN o.Order_Time BETWEEN '18:00:00' AND '23:59:00' THEN 'Night'
		ELSE 'Morning'
		END AS 'Time_of_the_day'
FROM Restaurant_Orders o
)
SELECT Time_of_the_day, COUNT(Time_of_the_day) AS 'Number_of_Orders'
FROM Time_Category
GROUP BY Time_of_the_day
ORDER BY 2 DESC;














