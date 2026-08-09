USE project;
GO

BULK INSERT customers
FROM '/var/opt/mssql/data/olist_customers_dataset.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, MAXERRORS = 1000);

BULK INSERT geolocation
FROM '/var/opt/mssql/data/olist_geolocation_dataset.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, MAXERRORS = 1000);

BULK INSERT sellers
FROM '/var/opt/mssql/data/olist_sellers_dataset.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, MAXERRORS = 1000);

BULK INSERT products
FROM '/var/opt/mssql/data/olist_products_dataset.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, MAXERRORS = 1000);

BULK INSERT product_category_translation
FROM '/var/opt/mssql/data/product_category_name_translation.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, MAXERRORS = 1000);

BULK INSERT orders
FROM '/var/opt/mssql/data/olist_orders_dataset.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, MAXERRORS = 1000);

BULK INSERT order_items
FROM '/var/opt/mssql/data/olist_order_items_dataset.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, MAXERRORS = 1000);

BULK INSERT order_payments
FROM '/var/opt/mssql/data/olist_order_payments_dataset.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, MAXERRORS = 1000);

BULK INSERT order_reviews
FROM '/var/opt/mssql/data/olist_order_reviews_dataset.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, MAXERRORS = 1000);
