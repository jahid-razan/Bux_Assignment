# 1. Background & Objective of the Project

The objective of this project is to create a data model and a dashboard by using the BUX data provided in the three tables to answer the following questions: 

            - What securities/market categories are traded the most?
            - What kind of order types (market/limit/basic) are clients placing?
            - What is the sentiment in terms of buying/selling?
            - What is the total, average/median order volume per day?
            - Who are the most engaged clients, and where do they come from?

The business users would also like to be able to filter the data based on the following dimensions:
            - Period
            - Country (based on country of residence)
            - EU vs US securities
            - Latest order state


## 2. Dataset
BUX Zero is a mobile app that allows users to buy and sell stocks. The data used in this project is generated by the Trading Team that supports the BUX Zero app. The dataset consists of three tables:

+ **1.BROKER_ACCOUNTS_DOMAINEVENTS**: Contains BrokerAccountCreated events*, which are triggered when a new account has been created.

+ **2.BROKER_MASTERDATA_DOMAINEVENTS:** Contains event data about the instruments (=securities) that are offered in BUX Zero and their states.

+ **3.BROKER_ORDERS_DOMAINEVENTS:** Contains event data about orders and order partial executions


## 3. Database schema design and ETL pipeline

A dimensional model helps to arrange the data in a way that is easier to retrieve and generate customized reports fit for purpose. In this case for instance- BUX stakeholders need to see some summary statistics to make business decisions.  

A dimensional model is comprised of dimensions and facts. Dimensions provide the context of the business process and give us the who, where and what information surrounding the business. In this case- Accounts, Masterdata, and the Orders tables are dimension tables since these tables contain the information, that needs to answer the questions for the BUX stakeholders[2].

Facts can be described as "a collection of related data items, which consist of measures and context data. Each fact typically represents a business item, a business transaction, or an event that can be used in analysing the business or business processes"[1]. In this case, a business transaction is an order that Bux clients make through using the Bux trading service. 

Hence, the fact table contains measurements/ facts and the foreign keys to the dimension tables through which they are connected to the dimension table. In this context- records that are required to calculate the current deposit for an account and the foreign keys are the facts. 
The building of a dimensional model can be summarized in a 05-step process [2].

        1.	**Identify Business Process**: In this step, the associated business processes such as finance, legal, sales etc. and the need of the model is identified. In our case, the need is- BUX needs to find the answer to some of the key questions. 

        2.	**Identify Grain**: This step describes the level of detail at which the data is stored also known as granularity. For instance, in this case, every client transaction is captured at all the time along with the timestamp and afterwards month and year level data is used.  

        3.	**Identify Dimensions**: Dimensions are the nouns where all the data are stored. In our case, the Accounts, Orders and Masterdata tables hold the necessary dimensions.

        4.	**Identify Facts**: The facts entail what questions we need to answer. In this case, we need the following:
        
                        - Market categories 
                        - Order types (market/limit/basic) 
                        - Sentiment 
                        - Total, average/median order volume 
                        - Most engaged clients, and where do they come from
                        - Country of residence
                        - Period
                        - Latest Order State
                        - EU vs US securities


            

        5.	**Schema design**: This is the final stage of the dimensional data modelling. In his stage, the schema is built. Two popular schemas are:
        
           **Star Schema**: In a star schema fact table remains at the centre while dimension tables are radiated from the centre. The shape ultimately looks like a star and hence is the name. 
           
           **Snowflake Schema**:  In a snowflake schema, each dimension is normalized and connected to more dimension tables.

Due to the limited number of dimensional tables for this exercise a STAR schema is a good fit. The order_summary table shown below is the Star schema that combines the data from the Accounts, Orders and Masterdata:

![ERD.jpg](https://github.com/jahid-razan/Bux_Assignment/blob/main/ERD.JPG)


# 4. Steps

1. From the given tables three tables have been created, these are Accounts, Orders, and Masterdata. These newly created tables contains the dimension information that has been extracted from the JSON data types of the payload columns.

**Accounts:** 
![Accounts](https://github.com/jahid-razan/Bux_Assignment/blob/main/accounts.JPG)


**Orders:**
![Orders](https://github.com/jahid-razan/Bux_Assignment/blob/main/orders.JPG)


**Masterdata:** 
![MASTERDATA](https://github.com/jahid-razan/Bux_Assignment/blob/main/MASTERDATA.JPG)

2. The master data table only contains the unique name of the companies and the security id
3. All the necessary columns have been taken to prepare the fact table that is the order summary table.

**order_summary:** 
![order_summary](https://github.com/jahid-razan/Bux_Assignment/blob/main/order_summary.JPG)

4. The order_summary table is used in the tableau to prepare the visualizations/dashboard. 
5. The codes used to extract the new tables has been added in a [separate file](https://github.com/jahid-razan/Bux_Assignment/blob/main/Bux_codes.sql).
6. The Accounts and Orders Tables can be joined based on the common user_id column and the Masterdata and Orders can be joined using the security id column. 
7. Most engaged clients have been calculated by summing the value of orders per country per category 
8. To calculate the market sentiment 250 moving average vs 50 days of moving average for order quantity has been compared.

# 5. Vizualizations

Following dashboards have been created:

![dashboard-1](https://github.com/jahid-razan/Bux_Assignment/blob/main/dashboard_1.JPG)

![dashboard-2](https://github.com/jahid-razan/Bux_Assignment/blob/main/dashboard_2.JPG)

# 6. References:

1. Basics explanation of [Fact and Dimension Table](https://medium.com/@BluePi_In/deep-diving-in-the-world-of-data-warehousing-78c0d52f49a)

2. [What is Dimensional Modeling in Data Warehouse?](https://www.guru99.com/dimensional-model-data-warehouse.html)

3. [HOW TO ANALYZE JSON WITH SQL - Snowflake](https://www.snowflake.com/wp-content/uploads/2017/08/Snowflake-How-to-Analyze-JSON-with-SQL.pdf)
4. [Market Sentiment](https://www.investopedia.com/terms/m/marketsentiment.asp)
