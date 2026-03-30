/*
1. Напишіть SQL запит, який буде відображати таблицю order_details 
та поле customer_id з таблиці orders відповідно для кожного поля запису з таблиці order_details.
Це має бути зроблено за допомогою вкладеного запиту в операторі SELECT.

2. Напишіть SQL запит, який буде відображати таблицю order_details. 
Відфільтруйте результати так, щоб відповідний запис із таблиці orders виконував умову shipper_id=3.
Це має бути зроблено за допомогою вкладеного запиту в операторі WHERE.

3. Напишіть SQL запит, вкладений в операторі FROM, який буде обирати рядки з умовою 
quantity>10 з таблиці order_details. Для отриманих даних знайдіть середнє значення 
поля quantity — групувати слід за order_id.

4. Розв’яжіть завдання 3, використовуючи оператор WITH для створення тимчасової таблиці temp. 
Якщо ваша версія MySQL більш рання, ніж 8.0, створіть цей запит за аналогією до того, як це зроблено в конспекті.

5. Створіть функцію з двома параметрами, яка буде ділити перший параметр на другий. 
Обидва параметри та значення, що повертається, повинні мати тип FLOAT.

Використайте конструкцію DROP FUNCTION IF EXISTS. 
Застосуйте функцію до атрибута quantity таблиці order_details . Другим параметром може бути довільне число на ваш розсуд.
*/

-- Task 1
SELECT
	od.*,
    (SELECT
		o.customer_id as customer_id
	FROM
		orders as o
	WHERE
		o.id = od.order_id
	) as customer_id
FROM
	order_details as od; 
-- Alternative solution
SELECT
    od.*,
    o.customer_id
FROM order_details AS od
JOIN orders AS o
    ON o.id = od.order_id;
    
-- Task 2
SELECT
    od.*
FROM order_details AS od
WHERE od.order_id IN (
    SELECT o.id
    FROM orders AS o
    WHERE o.shipper_id = 3
);
-- Alternative solution
SELECT
    od.*
FROM order_details AS od
JOIN orders AS o
    ON o.id = od.order_id
    AND o.shipper_id = 3;
    
-- Task 3
SELECT
    temp.order_id,
    AVG(temp.quantity) AS avg_quantity
FROM (
    SELECT
        od.order_id,
        od.quantity
    FROM order_details AS od
    WHERE od.quantity > 10
) AS temp
GROUP BY temp.order_id;
-- Alternative solution
SELECT
    od.order_id,
    AVG(od.quantity) AS avg_quantity
FROM order_details AS od
    WHERE od.quantity > 10
GROUP BY od.order_id;

-- Task 4
WITH temp AS (
    SELECT
        od.order_id,
        od.quantity
    FROM order_details AS od
    WHERE od.quantity > 10
)
SELECT
    temp.order_id,
    AVG(temp.quantity) AS avg_quantity
FROM temp
GROUP BY temp.order_id;

-- Task 5
DROP FUNCTION IF EXISTS divide;

DELIMITER //

CREATE FUNCTION divide(numerator FLOAT, denominator FLOAT)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    IF denominator = 0 THEN
        RETURN NULL;
    END IF;
    RETURN numerator / denominator;
END//

DELIMITER ;

SELECT
    quantity,
    divide(quantity, 2) AS divided_value
FROM order_details;
