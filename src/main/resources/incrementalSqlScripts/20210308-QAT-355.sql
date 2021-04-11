/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Author:  altius
 * Created: 08-Mar-2021
 */

CREATE TABLE `fasp`.`tr_artmis_country` (
  `RECEPIENT_NAME` VARCHAR(200) NOT NULL,
  `REALM_COUNTRY_ID` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`RECEPIENT_NAME`));
INSERT INTO tr_country VALUES ('Congo DRC', 11);
INSERT INTO tr_country VALUES ('Panama', 38);
INSERT INTO tr_country VALUES ('Vietnam', 49);


INSERT INTO `fasp`.`ap_export`(`EXPORT_ID`,`ERP_CODE`,`JOB_NAME`,`LAST_DATE`) VALUES ( NULL,'ARTMIS','QAT_Shipment_Linking',NOW()); 
UPDATE `fasp`.`em_email_template` SET `SUBJECT`='QAT data export error : <%ERROR_NAME%>' WHERE `EMAIL_TEMPLATE_ID`='4'; 

INSERT INTO `fasp`.`ap_static_label`(`STATIC_LABEL_ID`,`LABEL_CODE`,`ACTIVE`) VALUES (NULL,'static.mt.notLinkedQAT','1');  

SELECT MAX(l.STATIC_LABEL_ID) INTO @MAX FROM ap_static_label l ; 

 

INSERT INTO `fasp`.`ap_static_label_languages`(`STATIC_LABEL_LANGUAGE_ID`,`STATIC_LABEL_ID`,`LANGUAGE_ID`,`LABEL_TEXT`) VALUES ( NULL,@MAX,'1','Not Linked (QAT)');  

INSERT INTO `fasp`.`ap_static_label_languages`(`STATIC_LABEL_LANGUAGE_ID`,`STATIC_LABEL_ID`,`LANGUAGE_ID`,`LABEL_TEXT`) VALUES ( NULL,@MAX,'2','Non lié (QAT)');  

INSERT INTO `fasp`.`ap_static_label_languages`(`STATIC_LABEL_LANGUAGE_ID`,`STATIC_LABEL_ID`,`LANGUAGE_ID`,`LABEL_TEXT`) VALUES ( NULL,@MAX,'3','No vinculado (QAT)');  

INSERT INTO `fasp`.`ap_static_label_languages`(`STATIC_LABEL_LANGUAGE_ID`,`STATIC_LABEL_ID`,`LANGUAGE_ID`,`LABEL_TEXT`) VALUES ( NULL,@MAX,'4','Não vinculado (QAT)');  

 

 

 

INSERT INTO `fasp`.`ap_static_label`(`STATIC_LABEL_ID`,`LABEL_CODE`,`ACTIVE`) VALUES ( NULL,'static.mt.notLinkedERP','1');  

SELECT MAX(l.STATIC_LABEL_ID) INTO @MAX FROM ap_static_label l ; 

 

INSERT INTO `fasp`.`ap_static_label_languages`(`STATIC_LABEL_LANGUAGE_ID`,`STATIC_LABEL_ID`,`LANGUAGE_ID`,`LABEL_TEXT`) VALUES ( NULL,@MAX,'1','Not Linked (ERP)');  

INSERT INTO `fasp`.`ap_static_label_languages`(`STATIC_LABEL_LANGUAGE_ID`,`STATIC_LABEL_ID`,`LANGUAGE_ID`,`LABEL_TEXT`) VALUES ( NULL,@MAX,'2','Non lié (ERP)');  

INSERT INTO `fasp`.`ap_static_label_languages`(`STATIC_LABEL_LANGUAGE_ID`,`STATIC_LABEL_ID`,`LANGUAGE_ID`,`LABEL_TEXT`) VALUES ( NULL,@MAX,'3','No vinculado (ERP)');  

INSERT INTO `fasp`.`ap_static_label_languages`(`STATIC_LABEL_LANGUAGE_ID`,`STATIC_LABEL_ID`,`LANGUAGE_ID`,`LABEL_TEXT`) VALUES ( NULL,@MAX,'4','Não vinculado (ERP)');  

 

 

INSERT INTO `fasp`.`ap_static_label`(`STATIC_LABEL_ID`,`LABEL_CODE`,`ACTIVE`) VALUES ( NULL,'static.mt.linked','1');  

SELECT MAX(l.STATIC_LABEL_ID) INTO @MAX FROM ap_static_label l ; 

INSERT INTO `fasp`.`ap_static_label_languages`(`STATIC_LABEL_LANGUAGE_ID`,`STATIC_LABEL_ID`,`LANGUAGE_ID`,`LABEL_TEXT`) VALUES ( NULL,@MAX,'1','Linked');  

INSERT INTO `fasp`.`ap_static_label_languages`(`STATIC_LABEL_LANGUAGE_ID`,`STATIC_LABEL_ID`,`LANGUAGE_ID`,`LABEL_TEXT`) VALUES ( NULL,@MAX,'2','Lié');  

INSERT INTO `fasp`.`ap_static_label_languages`(`STATIC_LABEL_LANGUAGE_ID`,`STATIC_LABEL_ID`,`LANGUAGE_ID`,`LABEL_TEXT`) VALUES ( NULL,@MAX,'3','Vinculado');  

INSERT INTO `fasp`.`ap_static_label_languages`(`STATIC_LABEL_LANGUAGE_ID`,`STATIC_LABEL_ID`,`LANGUAGE_ID`,`LABEL_TEXT`) VALUES ( NULL,@MAX,'4','Vinculado');  

 

DELIMITER $$

USE `fasp`$$

DROP PROCEDURE IF EXISTS `getShipmentListForManualLinking`$$

CREATE DEFINER=`faspUser`@`%` PROCEDURE `getShipmentListForManualLinking`(PROGRAM_ID INT(10), PLANNING_UNIT_ID TEXT, VERSION_ID INT (10))
BEGIN
    SET @programId = PROGRAM_ID;
    SET @planningUnitIds = PLANNING_UNIT_ID;
    SET @procurementAgentId = 1;
    SET @versionId = VERSION_ID;
    IF @versionId = -1 THEN
        SELECT MAX(pv.VERSION_ID) INTO @versionId FROM rm_program_version pv WHERE pv.PROGRAM_ID=@programId;
    END IF;
   
SELECT
        st.SHIPMENT_ID, st.SHIPMENT_TRANS_ID, st.SHIPMENT_QTY, st.EXPECTED_DELIVERY_DATE, st.PRODUCT_COST, st.SKU_CODE,
        st.PROCUREMENT_AGENT_ID, st.PROCUREMENT_AGENT_CODE, st.`COLOR_HTML_CODE`, st.`PROCUREMENT_AGENT_LABEL_ID`, st.`PROCUREMENT_AGENT_LABEL_EN`, st.`PROCUREMENT_AGENT_LABEL_FR`, st.`PROCUREMENT_AGENT_LABEL_SP`, st.`PROCUREMENT_AGENT_LABEL_PR`,
        st.FUNDING_SOURCE_ID, st.FUNDING_SOURCE_CODE, st.`FUNDING_SOURCE_LABEL_ID`, st.`FUNDING_SOURCE_LABEL_EN`, st.`FUNDING_SOURCE_LABEL_FR`, st.`FUNDING_SOURCE_LABEL_SP`, st.`FUNDING_SOURCE_LABEL_PR`,
        st.BUDGET_ID, st.BUDGET_CODE, st.`BUDGET_LABEL_ID`, st.`BUDGET_LABEL_EN`, st.`BUDGET_LABEL_FR`, st.`BUDGET_LABEL_SP`, st.`BUDGET_LABEL_PR`,
        st.SHIPMENT_STATUS_ID, st.`SHIPMENT_STATUS_LABEL_ID`, st.`SHIPMENT_STATUS_LABEL_EN`, st.`SHIPMENT_STATUS_LABEL_FR`, st.`SHIPMENT_STATUS_LABEL_SP`, st.`SHIPMENT_STATUS_LABEL_PR`,
        st.PLANNING_UNIT_ID, st.`PLANNING_UNIT_LABEL_ID`, st.`PLANNING_UNIT_LABEL_EN`, st.`PLANNING_UNIT_LABEL_FR`, st.`PLANNING_UNIT_LABEL_SP`, st.`PLANNING_UNIT_LABEL_PR`,
        st.ORDER_NO, st.PRIME_LINE_NO,st.`NOTES`
FROM (
        SELECT
            s.SHIPMENT_ID, st.RECEIVED_DATE, st.EXPECTED_DELIVERY_DATE,st.SHIPMENT_QTY, st.RATE, st.PRODUCT_COST, st.FREIGHT_COST, st.ACCOUNT_FLAG, st.SHIPMENT_TRANS_ID, papu.SKU_CODE,
            pa.`PROCUREMENT_AGENT_ID`, pa.`PROCUREMENT_AGENT_CODE`, pa.`COLOR_HTML_CODE`, pa.`LABEL_ID` `PROCUREMENT_AGENT_LABEL_ID`, pa.`LABEL_EN` `PROCUREMENT_AGENT_LABEL_EN`, pa.LABEL_FR `PROCUREMENT_AGENT_LABEL_FR`, pa.LABEL_SP `PROCUREMENT_AGENT_LABEL_SP`, pa.LABEL_PR `PROCUREMENT_AGENT_LABEL_PR`,
            fs.`FUNDING_SOURCE_ID`, fs.`FUNDING_SOURCE_CODE`, fs.LABEL_ID `FUNDING_SOURCE_LABEL_ID`, fs.LABEL_EN `FUNDING_SOURCE_LABEL_EN`, fs.LABEL_FR `FUNDING_SOURCE_LABEL_FR`, fs.LABEL_SP `FUNDING_SOURCE_LABEL_SP`, fs.LABEL_PR `FUNDING_SOURCE_LABEL_PR`,
            shs.SHIPMENT_STATUS_ID, shs.LABEL_ID `SHIPMENT_STATUS_LABEL_ID`, shs.LABEL_EN `SHIPMENT_STATUS_LABEL_EN`, shs.LABEL_FR `SHIPMENT_STATUS_LABEL_FR`, shs.LABEL_SP `SHIPMENT_STATUS_LABEL_SP`, shs.LABEL_PR `SHIPMENT_STATUS_LABEL_PR`,
            sc.CURRENCY_ID `SHIPMENT_CURRENCY_ID`, sc.`CURRENCY_CODE` `SHIPMENT_CURRENCY_CODE`, s.CONVERSION_RATE_TO_USD `SHIPMENT_CONVERSION_RATE_TO_USD`,
            sc.LABEL_ID `SHIPMENT_CURRENCY_LABEL_ID`, sc.LABEL_EN `SHIPMENT_CURRENCY_LABEL_EN`, sc.LABEL_FR `SHIPMENT_CURRENCY_LABEL_FR`, sc.LABEL_SP `SHIPMENT_CURRENCY_LABEL_SP`, sc.LABEL_PR `SHIPMENT_CURRENCY_LABEL_PR`,
            st.ACTIVE, st.`ORDER_NO`, st.`PRIME_LINE_NO`,
            b.BUDGET_ID, b.BUDGET_CODE, b.LABEL_ID `BUDGET_LABEL_ID`, b.LABEL_EN `BUDGET_LABEL_EN`, b.LABEL_FR `BUDGET_LABEL_FR`, b.LABEL_SP `BUDGET_LABEL_SP`, b.LABEL_PR `BUDGET_LABEL_PR`,
            st.PLANNING_UNIT_ID, pu.LABEL_ID `PLANNING_UNIT_LABEL_ID`, pu.LABEL_EN `PLANNING_UNIT_LABEL_EN`, pu.LABEL_FR `PLANNING_UNIT_LABEL_FR`, pu.LABEL_SP `PLANNING_UNIT_LABEL_SP`, pu.LABEL_PR `PLANNING_UNIT_LABEL_PR`,st.`NOTES`
FROM (
    SELECT st.SHIPMENT_ID, MAX(st.VERSION_ID) MAX_VERSION_ID FROM rm_shipment s LEFT JOIN rm_shipment_trans st ON s.SHIPMENT_ID=st.SHIPMENT_ID WHERE (@versiONId=-1 OR st.VERSION_ID<=@versiONId) AND s.PROGRAM_ID=@programId GROUP BY st.SHIPMENT_ID
) ts
    LEFT JOIN rm_shipment s ON ts.SHIPMENT_ID=s.SHIPMENT_ID
    LEFT JOIN rm_shipment_trans st ON ts.SHIPMENT_ID=st.SHIPMENT_ID AND ts.MAX_VERSION_ID=st.VERSION_ID
    LEFT JOIN vw_planning_unit pu ON st.PLANNING_UNIT_ID=pu.PLANNING_UNIT_ID
    LEFT JOIN vw_procurement_agent pa ON st.PROCUREMENT_AGENT_ID=pa.PROCUREMENT_AGENT_ID
    LEFT JOIN vw_funding_source fs ON st.FUNDING_SOURCE_ID=fs.FUNDING_SOURCE_ID
    LEFT JOIN vw_shipment_status shs ON st.SHIPMENT_STATUS_ID=shs.SHIPMENT_STATUS_ID
    LEFT JOIN vw_currency sc ON s.CURRENCY_ID=sc.CURRENCY_ID
    LEFT JOIN vw_budget b ON st.BUDGET_ID=b.BUDGET_ID
    LEFT JOIN rm_manual_tagging mt ON mt.SHIPMENT_ID=ts.SHIPMENT_ID AND mt.ACTIVE
    LEFT JOIN rm_procurement_agent_planning_unit papu ON papu.PROCUREMENT_AGENT_ID=pa.PROCUREMENT_AGENT_ID AND papu.PLANNING_UNIT_ID=st.PLANNING_UNIT_ID
    WHERE st.ERP_FLAG=0 AND st.ACTIVE AND st.SHIPMENT_STATUS_ID IN (3,4,5,6,9) AND (LENGTH(@planningUnitIds)=0 OR FIND_IN_SET(st.PLANNING_UNIT_ID,@planningUnitIds))   AND (mt.SHIPMENT_ID IS NULL OR mt.ACTIVE=0) AND st.PROCUREMENT_AGENT_ID=@procurementAgentId
) st
ORDER BY COALESCE(st.RECEIVED_DATE, st.EXPECTED_DELIVERY_DATE);
END$$

DELIMITER $$

USE `fasp`$$

DROP PROCEDURE IF EXISTS `getShipmentListForAlreadyLinkedShipments`$$

CREATE DEFINER=`faspUser`@`%` PROCEDURE `getShipmentListForAlreadyLinkedShipments`(PROGRAM_ID INT(10), PLANNING_UNIT_ID TEXT, VERSION_ID INT (10))
BEGIN
    SET @programId = PROGRAM_ID;
    SET @planningUnitIds = PLANNING_UNIT_ID;
    SET @procurementAgentId = 1;
    SET @versionId = VERSION_ID;
    IF @versionId = -1 THEN
        SELECT MAX(pv.VERSION_ID) INTO @versionId FROM rm_program_version pv WHERE pv.PROGRAM_ID=@programId;
    END IF;
   
SELECT
        st.SHIPMENT_ID, st.SHIPMENT_TRANS_ID, st.SHIPMENT_QTY, st.EXPECTED_DELIVERY_DATE, st.PRODUCT_COST, st.SKU_CODE,
        st.PROCUREMENT_AGENT_ID, st.PROCUREMENT_AGENT_CODE, st.`COLOR_HTML_CODE`, st.`PROCUREMENT_AGENT_LABEL_ID`, st.`PROCUREMENT_AGENT_LABEL_EN`, st.`PROCUREMENT_AGENT_LABEL_FR`, st.`PROCUREMENT_AGENT_LABEL_SP`, st.`PROCUREMENT_AGENT_LABEL_PR`,
        st.FUNDING_SOURCE_ID, st.FUNDING_SOURCE_CODE, st.`FUNDING_SOURCE_LABEL_ID`, st.`FUNDING_SOURCE_LABEL_EN`, st.`FUNDING_SOURCE_LABEL_FR`, st.`FUNDING_SOURCE_LABEL_SP`, st.`FUNDING_SOURCE_LABEL_PR`,
        st.BUDGET_ID, st.BUDGET_CODE, st.`BUDGET_LABEL_ID`, st.`BUDGET_LABEL_EN`, st.`BUDGET_LABEL_FR`, st.`BUDGET_LABEL_SP`, st.`BUDGET_LABEL_PR`,
        st.SHIPMENT_STATUS_ID, st.`SHIPMENT_STATUS_LABEL_ID`, st.`SHIPMENT_STATUS_LABEL_EN`, st.`SHIPMENT_STATUS_LABEL_FR`, st.`SHIPMENT_STATUS_LABEL_SP`, st.`SHIPMENT_STATUS_LABEL_PR`,
        st.PLANNING_UNIT_ID, st.`PLANNING_UNIT_LABEL_ID`, st.`PLANNING_UNIT_LABEL_EN`, st.`PLANNING_UNIT_LABEL_FR`, st.`PLANNING_UNIT_LABEL_SP`, st.`PLANNING_UNIT_LABEL_PR`,
        st.ORDER_NO, st.PRIME_LINE_NO,st.`NOTES`,st.CONVERSION_FACTOR,st.PARENT_SHIPMENT_ID,st.ERP_PRODUCT_LABEL_EN,st.ERP_PRODUCT_LABEL_FR,st.ERP_PRODUCT_LABEL_SP,st.ERP_PRODUCT_LABEL_PR,st.ERP_PRODUCT_ID,st.ERP_PRODUCT_LABEL_ID,st.RO_NO,st.RO_PRIME_LINE_NO
FROM (
        SELECT
            s.SHIPMENT_ID, st.RECEIVED_DATE, st.EXPECTED_DELIVERY_DATE,st.SHIPMENT_QTY, st.RATE, st.PRODUCT_COST, st.FREIGHT_COST, st.ACCOUNT_FLAG, st.SHIPMENT_TRANS_ID, papu.SKU_CODE,
            pa.`PROCUREMENT_AGENT_ID`, pa.`PROCUREMENT_AGENT_CODE`, pa.`COLOR_HTML_CODE`, pa.`LABEL_ID` `PROCUREMENT_AGENT_LABEL_ID`, pa.`LABEL_EN` `PROCUREMENT_AGENT_LABEL_EN`, pa.LABEL_FR `PROCUREMENT_AGENT_LABEL_FR`, pa.LABEL_SP `PROCUREMENT_AGENT_LABEL_SP`, pa.LABEL_PR `PROCUREMENT_AGENT_LABEL_PR`,
            fs.`FUNDING_SOURCE_ID`, fs.`FUNDING_SOURCE_CODE`, fs.LABEL_ID `FUNDING_SOURCE_LABEL_ID`, fs.LABEL_EN `FUNDING_SOURCE_LABEL_EN`, fs.LABEL_FR `FUNDING_SOURCE_LABEL_FR`, fs.LABEL_SP `FUNDING_SOURCE_LABEL_SP`, fs.LABEL_PR `FUNDING_SOURCE_LABEL_PR`,
            shs.SHIPMENT_STATUS_ID, shs.LABEL_ID `SHIPMENT_STATUS_LABEL_ID`, shs.LABEL_EN `SHIPMENT_STATUS_LABEL_EN`, shs.LABEL_FR `SHIPMENT_STATUS_LABEL_FR`, shs.LABEL_SP `SHIPMENT_STATUS_LABEL_SP`, shs.LABEL_PR `SHIPMENT_STATUS_LABEL_PR`,
            sc.CURRENCY_ID `SHIPMENT_CURRENCY_ID`, sc.`CURRENCY_CODE` `SHIPMENT_CURRENCY_CODE`, s.CONVERSION_RATE_TO_USD `SHIPMENT_CONVERSION_RATE_TO_USD`,
            sc.LABEL_ID `SHIPMENT_CURRENCY_LABEL_ID`, sc.LABEL_EN `SHIPMENT_CURRENCY_LABEL_EN`, sc.LABEL_FR `SHIPMENT_CURRENCY_LABEL_FR`, sc.LABEL_SP `SHIPMENT_CURRENCY_LABEL_SP`, sc.LABEL_PR `SHIPMENT_CURRENCY_LABEL_PR`,
            mt.ACTIVE, st.`ORDER_NO`, st.`PRIME_LINE_NO`,
            b.BUDGET_ID, b.BUDGET_CODE, b.LABEL_ID `BUDGET_LABEL_ID`, b.LABEL_EN `BUDGET_LABEL_EN`, b.LABEL_FR `BUDGET_LABEL_FR`, b.LABEL_SP `BUDGET_LABEL_SP`, b.LABEL_PR `BUDGET_LABEL_PR`,
            st.PLANNING_UNIT_ID, pu.LABEL_ID `PLANNING_UNIT_LABEL_ID`, pu.LABEL_EN `PLANNING_UNIT_LABEL_EN`, pu.LABEL_FR `PLANNING_UNIT_LABEL_FR`, pu.LABEL_SP `PLANNING_UNIT_LABEL_SP`, pu.LABEL_PR `PLANNING_UNIT_LABEL_PR`,mt.`NOTES`,mt.CONVERSION_FACTOR,s.PARENT_SHIPMENT_ID,pu1.LABEL_EN AS ERP_PRODUCT_LABEL_EN,pu1.LABEL_FR AS ERP_PRODUCT_LABEL_FR,pu1.LABEL_SP AS ERP_PRODUCT_LABEL_SP,pu1.LABEL_PR AS ERP_PRODUCT_LABEL_PR,pu1.PLANNING_UNIT_ID AS ERP_PRODUCT_ID,pu1.LABEL_ID AS ERP_PRODUCT_LABEL_ID,eo.RO_NO,eo.RO_PRIME_LINE_NO
FROM (
    SELECT st.SHIPMENT_ID, MAX(st.VERSION_ID) MAX_VERSION_ID FROM rm_shipment s LEFT JOIN rm_shipment_trans st ON s.SHIPMENT_ID=st.SHIPMENT_ID WHERE (@versiONId=-1 OR st.VERSION_ID<=@versiONId) AND s.PROGRAM_ID=@programId GROUP BY st.SHIPMENT_ID
) ts
    LEFT JOIN rm_shipment s ON ts.SHIPMENT_ID=s.SHIPMENT_ID
    LEFT JOIN rm_shipment_trans st ON ts.SHIPMENT_ID=st.SHIPMENT_ID AND ts.MAX_VERSION_ID=st.VERSION_ID
    LEFT JOIN vw_planning_unit pu ON st.PLANNING_UNIT_ID=pu.PLANNING_UNIT_ID
    LEFT JOIN vw_procurement_agent pa ON st.PROCUREMENT_AGENT_ID=pa.PROCUREMENT_AGENT_ID
    LEFT JOIN vw_funding_source fs ON st.FUNDING_SOURCE_ID=fs.FUNDING_SOURCE_ID
    LEFT JOIN vw_shipment_status shs ON st.SHIPMENT_STATUS_ID=shs.SHIPMENT_STATUS_ID
    LEFT JOIN vw_currency sc ON s.CURRENCY_ID=sc.CURRENCY_ID
    LEFT JOIN vw_budget b ON st.BUDGET_ID=b.BUDGET_ID
    LEFT JOIN rm_manual_tagging mt ON mt.ORDER_NO=st.ORDER_NO AND mt.PRIME_LINE_NO=st.PRIME_LINE_NO AND mt.ACTIVE
    LEFT JOIN rm_procurement_agent_planning_unit papu ON papu.PROCUREMENT_AGENT_ID=pa.PROCUREMENT_AGENT_ID AND papu.PLANNING_UNIT_ID=st.PLANNING_UNIT_ID
    LEFT JOIN (SELECT e.PLANNING_UNIT_SKU_CODE,e.RO_NO,e.RO_PRIME_LINE_NO,e.ORDER_NO,e.PRIME_LINE_NO FROM rm_erp_order e WHERE e.`ERP_ORDER_ID` IN (SELECT MAX(e.`ERP_ORDER_ID`)  AS ERP_ORDER_ID FROM rm_erp_order e
                 GROUP BY e.`RO_NO`,e.`RO_PRIME_LINE_NO`,e.`ORDER_NO`,e.`PRIME_LINE_NO`)) AS eo ON eo.ORDER_NO=st.ORDER_NO AND eo.PRIME_LINE_NO=st.PRIME_LINE_NO
    LEFT JOIN rm_procurement_agent_planning_unit papu1 ON papu1.PROCUREMENT_AGENT_ID=pa.PROCUREMENT_AGENT_ID AND LEFT(papu1.SKU_CODE,12)=eo.PLANNING_UNIT_SKU_CODE
    LEFT JOIN vw_planning_unit pu1 ON papu1.PLANNING_UNIT_ID=pu1.PLANNING_UNIT_ID
    WHERE st.ERP_FLAG=1 AND st.ACTIVE AND st.SHIPMENT_STATUS_ID IN (3,4,5,6,7,9) AND (LENGTH(@planningUnitIds)=0 OR FIND_IN_SET(st.PLANNING_UNIT_ID,@planningUnitIds))   
--    AND (mt.SHIPMENT_ID IS not NULL AND mt.ACTIVE=1) 
    AND st.PROCUREMENT_AGENT_ID=@procurementAgentId
) st
ORDER BY COALESCE(st.RECEIVED_DATE, st.EXPECTED_DELIVERY_DATE);
END$$

DELIMITER ;


USE `fasp`;
DROP procedure IF EXISTS `getErpShipmentForNotLinked`;

DELIMITER ;


USE `fasp`;
DROP PROCEDURE IF EXISTS `getErpShipmentForNotLinked`;

DELIMITER $$
USE `fasp`$$
CREATE DEFINER=`faspUser`@`%` PROCEDURE `getErpShipmentForNotLinked`(
    VAR_REALM_COUNTRY_ID INT(10), 
    VAR_PRODUCT_CATEGORY_IDS TEXT, 
    VAR_PLANNING_UNIT_IDS TEXT
    )
BEGIN

    SET @productCategoryIds = VAR_PRODUCT_CATEGORY_IDS;
    SET @planningUnitIds = VAR_PLANNING_UNIT_IDS;
    
    SELECT GROUP_CONCAT(pc2.PRODUCT_CATEGORY_ID) INTO @finalProductCategoryIds FROM rm_product_category pc LEFT JOIN rm_product_category pc2 ON pc2.SORT_ORDER LIKE CONCAT(pc.SORT_ORDER,"%") WHERE FIND_IN_SET(pc.PRODUCT_CATEGORY_ID, @productCategoryIds);
    
    SELECT COALESCE(ac.RECEPIENT_NAME, c.LABEL_EN) INTO @recpientCountry 
    FROM rm_realm_country rc 
    LEFT JOIN vw_country c ON rc.COUNTRY_ID=c.COUNTRY_ID 
    LEFT JOIN tr_artmis_country ac ON rc.REALM_COUNTRY_ID=ac.REALM_COUNTRY_ID
    WHERE rc.REALM_COUNTRY_ID=VAR_REALM_COUNTRY_ID;
    
    SELECT 
        o.ORDER_NO, o.PRIME_LINE_NO, o.`RO_NO`,o.`RO_PRIME_LINE_NO`,o.ERP_ORDER_ID,
        pu.PLANNING_UNIT_ID, pu.LABEL_ID `PLANNING_UNIT_LABEL_ID`, pu.LABEL_EN `PLANNING_UNIT_LABEL_EN`, pu.LABEL_FR `PLANNING_UNIT_LABEL_FR`, pu.LABEL_SP `PLANNING_UNIT_LABEL_SP`, pu.LABEL_PR `PLANNING_UNIT_LABEL_PR`,
        COALESCE(o.CURRENT_ESTIMATED_DELIVERY_DATE,o.AGREED_DELIVERY_DATE, o.REQ_DELIVERY_DATE) `EXPECTED_DELIVERY_DATE`, o.`STATUS`, o.QTY
    FROM rm_erp_order o 
    LEFT JOIN (SELECT o.ERP_ORDER_ID FROM rm_erp_order o GROUP BY o.`RO_NO`,o.`RO_PRIME_LINE_NO`,o.ORDER_NO, o.PRIME_LINE_NO) o1 ON o.ERP_ORDER_ID=o1.ERP_ORDER_ID 
    LEFT JOIN rm_manual_tagging mt ON mt.ORDER_NO=o.ORDER_NO AND mt.PRIME_LINE_NO=o.PRIME_LINE_NO AND mt.ACTIVE 
    LEFT JOIN rm_procurement_agent_planning_unit papu ON o.PLANNING_UNIT_SKU_CODE=LEFT(papu.SKU_CODE,12) 
    LEFT JOIN vw_planning_unit pu ON papu.PLANNING_UNIT_ID=pu.PLANNING_UNIT_ID 
    LEFT JOIN rm_forecasting_unit fu ON pu.FORECASTING_UNIT_ID=fu.FORECASTING_UNIT_ID 
    WHERE  
        o1.ERP_ORDER_ID IS NOT NULL  
        AND mt.SHIPMENT_ID IS NULL  
        AND o.RECPIENT_COUNTRY!=''  
        AND o.RECPIENT_COUNTRY=@recpientCountry  
        AND (LENGTH(@finalProductCategoryIds)=0 OR FIND_IN_SET(fu.PRODUCT_CATEGORY_ID, @finalProductCategoryIds))
        AND (LENGTH(@planningUnitIds)=0 OR FIND_IN_SET(papu.PLANNING_UNIT_ID, @planningUnitIds));
END$$

DELIMITER ;

CREATE TABLE `fasp`.`rm_erp_notification`( `NOTIFICATION_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT , `ORDER_NO` VARCHAR(100) NOT NULL , `PRIME_LINE_NO` INT NOT NULL , `TYPE_ID` INT NOT NULL COMMENT '1-SKU CHANGE 2-CANCELLED', `SHIPMENT_ID` INT NOT NULL , `ADDRESSED` BOOLEAN NOT NULL DEFAULT '0' , `ACTIVE` BOOLEAN NOT NULL DEFAULT '0' , `CREATED_DATE` DATETIME NOT NULL , `CREATED_BY` INT NOT NULL , `LAST_MODIFIED_DATE` DATETIME NOT NULL , `LAST_MODIFIED_BY` INT NOT NULL , PRIMARY KEY (`NOTIFICATION_ID`) ); 

DELIMITER $$

USE `fasp`$$

DROP PROCEDURE IF EXISTS `getNotLinkedShipments`$$

CREATE DEFINER=`faspUser`@`%` PROCEDURE `getNotLinkedShipments`(REALM_COUNTRY_ID INT(10), PLANNING_UNIT_ID INT(10), VERSION_ID INT (10))
BEGIN
    SET @realmCountryId = REALM_COUNTRY_ID;
    SET @planningUnitIds = PLANNING_UNIT_ID;
    SET @procurementAgentId = 1;
    SET @versionId = VERSION_ID;
    -- IF @versionId = -1 THEN
        -- SELECT MAX(pv.VERSION_ID) INTO @versionId FROM rm_program_version pv WHERE pv.PROGRAM_ID=@programId;
    -- END IF;
   
SELECT
        st.SHIPMENT_ID, st.SHIPMENT_TRANS_ID, st.SHIPMENT_QTY, st.EXPECTED_DELIVERY_DATE, st.PRODUCT_COST, st.SKU_CODE,
        st.PROCUREMENT_AGENT_ID, st.PROCUREMENT_AGENT_CODE, st.`COLOR_HTML_CODE`, st.`PROCUREMENT_AGENT_LABEL_ID`, st.`PROCUREMENT_AGENT_LABEL_EN`, st.`PROCUREMENT_AGENT_LABEL_FR`, st.`PROCUREMENT_AGENT_LABEL_SP`, st.`PROCUREMENT_AGENT_LABEL_PR`,
        st.FUNDING_SOURCE_ID, st.FUNDING_SOURCE_CODE, st.`FUNDING_SOURCE_LABEL_ID`, st.`FUNDING_SOURCE_LABEL_EN`, st.`FUNDING_SOURCE_LABEL_FR`, st.`FUNDING_SOURCE_LABEL_SP`, st.`FUNDING_SOURCE_LABEL_PR`,
        st.BUDGET_ID, st.BUDGET_CODE, st.`BUDGET_LABEL_ID`, st.`BUDGET_LABEL_EN`, st.`BUDGET_LABEL_FR`, st.`BUDGET_LABEL_SP`, st.`BUDGET_LABEL_PR`,
        st.SHIPMENT_STATUS_ID, st.`SHIPMENT_STATUS_LABEL_ID`, st.`SHIPMENT_STATUS_LABEL_EN`, st.`SHIPMENT_STATUS_LABEL_FR`, st.`SHIPMENT_STATUS_LABEL_SP`, st.`SHIPMENT_STATUS_LABEL_PR`,
        st.PLANNING_UNIT_ID, st.`PLANNING_UNIT_LABEL_ID`, st.`PLANNING_UNIT_LABEL_EN`, st.`PLANNING_UNIT_LABEL_FR`, st.`PLANNING_UNIT_LABEL_SP`, st.`PLANNING_UNIT_LABEL_PR`,
        st.ORDER_NO, st.PRIME_LINE_NO,st.`NOTES`
FROM (
        SELECT
            s.SHIPMENT_ID, st.RECEIVED_DATE, st.EXPECTED_DELIVERY_DATE,st.SHIPMENT_QTY, st.RATE, st.PRODUCT_COST, st.FREIGHT_COST, st.ACCOUNT_FLAG, st.SHIPMENT_TRANS_ID, papu.SKU_CODE,
            pa.`PROCUREMENT_AGENT_ID`, pa.`PROCUREMENT_AGENT_CODE`, pa.`COLOR_HTML_CODE`, pa.`LABEL_ID` `PROCUREMENT_AGENT_LABEL_ID`, pa.`LABEL_EN` `PROCUREMENT_AGENT_LABEL_EN`, pa.LABEL_FR `PROCUREMENT_AGENT_LABEL_FR`, pa.LABEL_SP `PROCUREMENT_AGENT_LABEL_SP`, pa.LABEL_PR `PROCUREMENT_AGENT_LABEL_PR`,
            fs.`FUNDING_SOURCE_ID`, fs.`FUNDING_SOURCE_CODE`, fs.LABEL_ID `FUNDING_SOURCE_LABEL_ID`, fs.LABEL_EN `FUNDING_SOURCE_LABEL_EN`, fs.LABEL_FR `FUNDING_SOURCE_LABEL_FR`, fs.LABEL_SP `FUNDING_SOURCE_LABEL_SP`, fs.LABEL_PR `FUNDING_SOURCE_LABEL_PR`,
            shs.SHIPMENT_STATUS_ID, shs.LABEL_ID `SHIPMENT_STATUS_LABEL_ID`, shs.LABEL_EN `SHIPMENT_STATUS_LABEL_EN`, shs.LABEL_FR `SHIPMENT_STATUS_LABEL_FR`, shs.LABEL_SP `SHIPMENT_STATUS_LABEL_SP`, shs.LABEL_PR `SHIPMENT_STATUS_LABEL_PR`,
            sc.CURRENCY_ID `SHIPMENT_CURRENCY_ID`, sc.`CURRENCY_CODE` `SHIPMENT_CURRENCY_CODE`, s.CONVERSION_RATE_TO_USD `SHIPMENT_CONVERSION_RATE_TO_USD`,
            sc.LABEL_ID `SHIPMENT_CURRENCY_LABEL_ID`, sc.LABEL_EN `SHIPMENT_CURRENCY_LABEL_EN`, sc.LABEL_FR `SHIPMENT_CURRENCY_LABEL_FR`, sc.LABEL_SP `SHIPMENT_CURRENCY_LABEL_SP`, sc.LABEL_PR `SHIPMENT_CURRENCY_LABEL_PR`,
            st.ACTIVE, st.`ORDER_NO`, st.`PRIME_LINE_NO`,
            b.BUDGET_ID, b.BUDGET_CODE, b.LABEL_ID `BUDGET_LABEL_ID`, b.LABEL_EN `BUDGET_LABEL_EN`, b.LABEL_FR `BUDGET_LABEL_FR`, b.LABEL_SP `BUDGET_LABEL_SP`, b.LABEL_PR `BUDGET_LABEL_PR`,
            st.PLANNING_UNIT_ID, pu.LABEL_ID `PLANNING_UNIT_LABEL_ID`, pu.LABEL_EN `PLANNING_UNIT_LABEL_EN`, pu.LABEL_FR `PLANNING_UNIT_LABEL_FR`, pu.LABEL_SP `PLANNING_UNIT_LABEL_SP`, pu.LABEL_PR `PLANNING_UNIT_LABEL_PR`,st.`NOTES`
FROM (
    SELECT st.SHIPMENT_ID, MAX(st.VERSION_ID) MAX_VERSION_ID 
FROM rm_shipment s LEFT JOIN rm_shipment_trans st ON s.SHIPMENT_ID=st.SHIPMENT_ID 
LEFT JOIN rm_program p ON p.`PROGRAM_ID`=s.`PROGRAM_ID`
WHERE (@versiONId=-1 OR st.VERSION_ID<=@versiONId) AND p.`REALM_COUNTRY_ID`=@realmCountryId GROUP BY st.SHIPMENT_ID
) ts
    LEFT JOIN rm_shipment s ON ts.SHIPMENT_ID=s.SHIPMENT_ID
    LEFT JOIN rm_shipment_trans st ON ts.SHIPMENT_ID=st.SHIPMENT_ID AND ts.MAX_VERSION_ID=st.VERSION_ID
    LEFT JOIN vw_planning_unit pu ON st.PLANNING_UNIT_ID=pu.PLANNING_UNIT_ID
    LEFT JOIN vw_procurement_agent pa ON st.PROCUREMENT_AGENT_ID=pa.PROCUREMENT_AGENT_ID
    LEFT JOIN vw_funding_source fs ON st.FUNDING_SOURCE_ID=fs.FUNDING_SOURCE_ID
    LEFT JOIN vw_shipment_status shs ON st.SHIPMENT_STATUS_ID=shs.SHIPMENT_STATUS_ID
    LEFT JOIN vw_currency sc ON s.CURRENCY_ID=sc.CURRENCY_ID
    LEFT JOIN vw_budget b ON st.BUDGET_ID=b.BUDGET_ID
    LEFT JOIN rm_manual_tagging mt ON mt.SHIPMENT_ID=ts.SHIPMENT_ID AND mt.ACTIVE
    LEFT JOIN rm_procurement_agent_planning_unit papu ON papu.PROCUREMENT_AGENT_ID=pa.PROCUREMENT_AGENT_ID AND papu.PLANNING_UNIT_ID=st.PLANNING_UNIT_ID
    WHERE st.ERP_FLAG=0 AND st.ACTIVE AND st.SHIPMENT_STATUS_ID IN (3,4,5,6,9) AND st.PLANNING_UNIT_ID=@planningUnitIds   AND (mt.SHIPMENT_ID IS NULL OR mt.ACTIVE=0) AND st.PROCUREMENT_AGENT_ID=@procurementAgentId
) st
ORDER BY COALESCE(st.RECEIVED_DATE, st.EXPECTED_DELIVERY_DATE);
END$$

DELIMITER ;

CREATE TABLE `fasp`.`ap_notification_type`( `NOTIFICATION_TYPE_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT , `LABEL_ID` INT NOT NULL , `ACTIVE` TINYINT NOT NULL DEFAULT '1' , `CREATED_DATE` DATETIME NOT NULL , `CREATED_BY` INT NOT NULL , `LAST_MODIFIED_DATE` DATETIME NOT NULL , `LAST_MODIFIED_BY` INT NOT NULL , PRIMARY KEY (`NOTIFICATION_TYPE_ID`) ); 

ALTER TABLE `fasp`.`rm_erp_notification` CHANGE `TYPE_ID` `NOTIFICATION_TYPE_ID` INT(11) NOT NULL COMMENT '1-SKU CHANGE 2-CANCELLED'; 

DELIMITER $$

USE `fasp`$$

DROP PROCEDURE IF EXISTS `getShipmentLinkingNotifications`$$

CREATE DEFINER=`faspUser`@`%` PROCEDURE `getShipmentLinkingNotifications`(PROGRAM_ID INT(10), PLANNING_UNIT_ID TEXT, VERSION_ID INT (10))
BEGIN
    SET @programId = PROGRAM_ID;
    SET @planningUnitIds = PLANNING_UNIT_ID;
    SET @procurementAgentId = 1;
    SET @versionId = VERSION_ID;
    IF @versionId = -1 THEN
        SELECT MAX(pv.VERSION_ID) INTO @versionId FROM rm_program_version pv WHERE pv.PROGRAM_ID=@programId;
    END IF;
   
SELECT n.`NOTIFICATION_ID`,n.ADDRESSED,n.NOTIFICATION_TYPE_ID,lnt.*,st.`SHIPMENT_ID`,st.`ORDER_NO`,st.`PRIME_LINE_NO`,eo.RO_NO,eo.RO_PRIME_LINE_NO,
st.PLANNING_UNIT_ID, pu.LABEL_ID `PLANNING_UNIT_LABEL_ID`, pu.LABEL_EN `PLANNING_UNIT_LABEL_EN`, pu.LABEL_FR `PLANNING_UNIT_LABEL_FR`,
 pu.LABEL_SP `PLANNING_UNIT_LABEL_SP`, pu.LABEL_PR `PLANNING_UNIT_LABEL_PR`,
 papu1.PLANNING_UNIT_ID AS ERP_PLANNING_UNIT_ID, pu1.LABEL_ID `ERP_PLANNING_UNIT_LABEL_ID`, pu1.LABEL_EN `ERP_PLANNING_UNIT_LABEL_EN`, pu1.LABEL_FR `ERP_PLANNING_UNIT_LABEL_FR`,
 pu1.LABEL_SP `ERP_PLANNING_UNIT_LABEL_SP`, pu1.LABEL_PR `ERP_PLANNING_UNIT_LABEL_PR`,st.`EXPECTED_DELIVERY_DATE`,
 ss.`SHIPMENT_STATUS_ID`,ss.`LABEL_EN` AS SHIPMENT_STATUS_LABEL_EN,ss.`LABEL_FR` AS SHIPMENT_STATUS_LABEL_FR,ss.`LABEL_ID`  AS SHIPMENT_STATUS_LABEL_ID,ss.`LABEL_PR` AS SHIPMENT_STATUS_LABEL_PR,ss.`LABEL_SP` AS SHIPMENT_STATUS_LABEL_SP,
 pa.`PROCUREMENT_AGENT_ID`, pa.`PROCUREMENT_AGENT_CODE`, pa.`COLOR_HTML_CODE`, pa.`LABEL_ID` `PROCUREMENT_AGENT_LABEL_ID`, pa.`LABEL_EN` `PROCUREMENT_AGENT_LABEL_EN`, pa.LABEL_FR `PROCUREMENT_AGENT_LABEL_FR`, pa.LABEL_SP `PROCUREMENT_AGENT_LABEL_SP`, pa.LABEL_PR `PROCUREMENT_AGENT_LABEL_PR`,st.`SHIPMENT_QTY`,
 n.NOTES,m.CONVERSION_FACTOR,n.SHIPMENT_ID AS PARENT_SHIPMENT_ID
 FROM (
SELECT st.SHIPMENT_ID, MAX(st.VERSION_ID) MAX_VERSION_ID 
FROM rm_shipment s LEFT JOIN rm_shipment_trans st ON s.SHIPMENT_ID=st.SHIPMENT_ID 
WHERE (@versiONId=-1 OR st.VERSION_ID<=@versiONId) AND s.PROGRAM_ID=@programId GROUP BY st.SHIPMENT_ID
)  ts
LEFT JOIN rm_shipment s ON s.`SHIPMENT_ID`=ts.`SHIPMENT_ID`
LEFT JOIN rm_erp_notification n ON n.`SHIPMENT_ID`=s.`PARENT_SHIPMENT_ID`
LEFT JOIN ap_notification_type nt ON nt.`NOTIFICATION_TYPE_ID`=n.`NOTIFICATION_TYPE_ID`
LEFT JOIN ap_label lnt ON lnt.`LABEL_ID`=nt.`LABEL_ID`
LEFT JOIN rm_shipment_trans st ON ts.SHIPMENT_ID=st.SHIPMENT_ID AND ts.MAX_VERSION_ID=st.VERSION_ID
LEFT JOIN vw_planning_unit pu ON st.PLANNING_UNIT_ID=pu.PLANNING_UNIT_ID
LEFT JOIN rm_procurement_agent_planning_unit papu ON papu.PROCUREMENT_AGENT_ID=1 AND papu.PLANNING_UNIT_ID=st.PLANNING_UNIT_ID
LEFT JOIN (SELECT e.PLANNING_UNIT_SKU_CODE,e.RO_NO,e.RO_PRIME_LINE_NO,e.ORDER_NO,e.PRIME_LINE_NO ,e.`STATUS`
FROM rm_erp_order e WHERE e.`ERP_ORDER_ID` IN (SELECT MAX(e.`ERP_ORDER_ID`)  AS ERP_ORDER_ID 
FROM rm_erp_order e
GROUP BY e.`RO_NO`,e.`RO_PRIME_LINE_NO`,e.`ORDER_NO`,e.`PRIME_LINE_NO`)) AS eo 
ON eo.ORDER_NO=st.ORDER_NO AND eo.PRIME_LINE_NO=st.PRIME_LINE_NO 
LEFT JOIN rm_procurement_agent_planning_unit papu1 ON papu1.PROCUREMENT_AGENT_ID=1 AND LEFT(papu1.SKU_CODE,12)=eo.PLANNING_UNIT_SKU_CODE
LEFT JOIN vw_planning_unit pu1 ON papu1.PLANNING_UNIT_ID=pu1.PLANNING_UNIT_ID
LEFT JOIN rm_shipment_status_mapping ssm ON ssm.`EXTERNAL_STATUS_STAGE`=eo.STATUS
LEFT JOIN vw_shipment_status ss ON ss.`SHIPMENT_STATUS_ID`=ssm.`SHIPMENT_STATUS_ID`
LEFT JOIN vw_procurement_agent pa ON st.PROCUREMENT_AGENT_ID=pa.PROCUREMENT_AGENT_ID
LEFT JOIN rm_manual_tagging m ON m.ORDER_NO=n.ORDER_NO AND m.PRIME_LINE_NO=n.PRIME_LINE_NO AND m.SHIPMENT_ID=n.SHIPMENT_ID AND m.ACTIVE
WHERE n.`NOTIFICATION_ID` IS NOT NULL AND n.ACTIVE AND (LENGTH(@planningUnitIds)=0 OR FIND_IN_SET(st.PLANNING_UNIT_ID,@planningUnitIds))   
    AND st.PROCUREMENT_AGENT_ID=@procurementAgentId;
END$$

DELIMITER ;

ALTER TABLE `fasp`.`rm_erp_notification` ADD COLUMN `NOTES` TEXT NULL AFTER `LAST_MODIFIED_BY`; 

ALTER TABLE `fasp`.`rm_erp_notification` ADD COLUMN `CONVERSION_FACTOR` DECIMAL(12,4) NULL AFTER `NOTES`; 

INSERT INTO `fasp`.`ap_label_source`(`SOURCE_ID`,`SOURCE_DESC`) VALUES ( NULL,'ap_notification_type'); 

INSERT INTO `fasp`.`ap_label_source`(`SOURCE_ID`,`SOURCE_DESC`) VALUES ( NULL,'ap_notification_type'); 
INSERT INTO `fasp`.`ap_label`(`LABEL_ID`,`LABEL_EN`,`LABEL_FR`,`LABEL_SP`,`LABEL_PR`,`CREATED_BY`,`CREATED_DATE`,`LAST_MODIFIED_BY`,`LAST_MODIFIED_DATE`,`SOURCE_ID`) VALUES ( NULL,'Cancellation',NULL,NULL,NULL,'1',NOW(),'1',NOW(),'36'); 
INSERT INTO `fasp`.`ap_notification_type`(`NOTIFICATION_TYPE_ID`,`LABEL_ID`,`ACTIVE`,`CREATED_DATE`,`CREATED_BY`,`LAST_MODIFIED_DATE`,`LAST_MODIFIED_BY`) VALUES ( NULL,LAST_INSERT_ID(),'1',NOW(),'1',NOW(),'1'); 

INSERT INTO `fasp`.`ap_label`(`LABEL_ID`,`LABEL_EN`,`LABEL_FR`,`LABEL_SP`,`LABEL_PR`,`CREATED_BY`,`CREATED_DATE`,`LAST_MODIFIED_BY`,`LAST_MODIFIED_DATE`,`SOURCE_ID`) VALUES ( NULL,'ERP Product Change',NULL,NULL,NULL,'1',NOW(),'1',NOW(),'36'); 
INSERT INTO `fasp`.`ap_notification_type`(`NOTIFICATION_TYPE_ID`,`LABEL_ID`,`ACTIVE`,`CREATED_DATE`,`CREATED_BY`,`LAST_MODIFIED_DATE`,`LAST_MODIFIED_BY`) VALUES ( NULL,LAST_INSERT_ID(),'1',NOW(),'1',NOW(),'1'); 