-- create BROKER_ACCOUNT TABLE

CREATE VIEW ACCOUNTS as(

SELECT
	PAYLOAD:id::string as id,
      PAYLOAD:event.userId::string as user_id,
	PAYLOAD:event.currentAddress.country::string as residence_country


FROM "EXT_ANALYTICS_ENGINEER_JRAZAN"."TEST_JR"."BROKER_ACCOUNTS_DOMAINEVENTS"
);


-- create BROKER_MASTERDATA_VIEW
CREATE VIEW MASTERDATA as(
 
SELECT
      DISTINCT(PAYLOAD:event.name::string) as event_name,
      PAYLOAD:event.category::string as category, 
      PAYLOAD:event.isin::string as security_id
     
 FROM "EXT_ANALYTICS_ENGINEER_JRAZAN"."TEST_JR"."BROKER_MASTERDATA_DOMAINEVENTS"
 WHERE event_name IS NOT NULL);


-- create ORDER_VIEW

CREATE VIEW ORDERS as(

SELECT  
        PAYLOAD:event.userId::string as user_id,
        TIMESTAMP as time,
        YEAR(TIMESTAMP) as order_year,
        MONTH(TIMESTAMP) as order_month,
        DAY(TIMESTAMP) as order_date,
        PAYLOAD:event.securityId::string as security_id,
        PAYLOAD:event.orderType::string as order_type,
        PAYLOAD:event.partialQuantity::string as partial_quantity,
        PAYLOAD:event.roundedPartialValue.amount::integer as order_value,
        PAYLOAD:type::string as latest_order_state,
        CASE WHEN (LEFT(PAYLOAD:event.securityId,2)::string) = 'US' THEN 'US'
                    ELSE 'EU' END as location

FROM "EXT_ANALYTICS_ENGINEER_JRAZAN"."TEST_JR"."BROKER_ORDERS_DOMAINEVENTS" 
WHERE security_id IS NOT NULL AND 
      order_value IS NOT NULL
      ORDER BY 3 DESC, 
            4 DESC, 
            5 DESC);



-- all joins
CREATE VIEW order_summary as(
SELECT 
      a.user_id,
      a.time,
      a.security_id,
      a.order_year,	
      a.order_month,	
      a.order_date,	
      a.order_type,
      a.partial_quantity,	
      a.ordeR_value,
      a.latest_order_state,	
      a.location,
      b.residence_country,
      c.event_name,
      c.category
    
FROM "EXT_ANALYTICS_ENGINEER_JRAZAN"."TEST_JR"."ORDERS" a
JOIN "EXT_ANALYTICS_ENGINEER_JRAZAN"."TEST_JR"."ACCOUNTS" b
ON a.user_id = b.user_id 
JOIN "EXT_ANALYTICS_ENGINEER_JRAZAN"."TEST_JR"."MASTERDATA" c
ON a.security_id = c.security_id )