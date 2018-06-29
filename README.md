# DataWarehouse_ForeignKeys
Add Foreign Keys in SQL Server to Hundreds+ Data Warehouse tables with Dynamic SQL 

When working in Data Warehousing environments, its typical to come across the need to add Foreign Key's across the entire structure,
so instead of manually adding them, this Dynamic SQL will add one across everything found in INFORMATION SCHEMA that has
that column name.

Note the base table has default schema of dbo, you may need to change that.
