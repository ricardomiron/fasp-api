/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/SQLTemplate.sql to edit this template
 */
/**
 * Author:  altius
 * Created: 10-Oct-2022
 */

USE `fasp`;
DROP procedure IF EXISTS `getNotLinkedQatShipments`;

USE `fasp`;
DROP procedure IF EXISTS `fasp`.`getNotLinkedQatShipments`;
;

DELIMITER $$
USE `fasp`$$
CREATE DEFINER=`faspUser`@`%` PROCEDURE `getNotLinkedQatShipments`(VAR_PROGRAM_ID INT(10), VAR_VERSION_ID INT (10), VAR_PROCUREMENT_AGENT_ID INT (10),VAR_PLANNING_UNIT_IDS TEXT)
BEGIN
    SET @programId = VAR_PROGRAM_ID;
    SET @versionId = VAR_VERSION_ID;
    SET @procurementAgentId = VAR_PROCUREMENT_AGENT_ID;
    SET @shipmentActive = 1;
    SET @planningUnitActive = 1;
    SET @planningUnitIds = VAR_PLANNING_UNIT_IDS;
    SET @sql1 = "";	
    IF @versionId = -1 THEN
        SELECT MAX(pv.VERSION_ID) INTO @versionId FROM rm_program_version pv WHERE pv.PROGRAM_ID=@programId;
    END IF;
      
    SELECT 
        st.*, stbi.SHIPMENT_TRANS_BATCH_INFO_ID, stbi.BATCH_ID, bi.PLANNING_UNIT_ID `BATCH_PLANNING_UNIT_ID`, bi.BATCH_NO, bi.AUTO_GENERATED, bi.EXPIRY_DATE, bi.CREATED_DATE `BATCH_CREATED_DATE`, stbi.BATCH_SHIPMENT_QTY `BATCH_SHIPMENT_QTY` 
    FROM (
        SELECT
            s.SHIPMENT_ID, s.PARENT_SHIPMENT_ID,null as PARENT_LINKED_SHIPMENT_ID, st.EXPECTED_DELIVERY_DATE, st.PLANNED_DATE, st.SUBMITTED_DATE, st.APPROVED_DATE, st.SHIPPED_DATE, st.ARRIVED_DATE, st.RECEIVED_DATE, st.SHIPMENT_QTY, st.SHIPMENT_RCPU_QTY, pu.MULTIPLIER `CONVERSION_FACTOR`, st.RATE, st.PRODUCT_COST, st.FREIGHT_COST, st.SHIPMENT_MODE, s.SUGGESTED_QTY, st.ACCOUNT_FLAG, st.ERP_FLAG, st.ORDER_NO, st.PRIME_LINE_NO, st.VERSION_ID, st.NOTES, st.SHIPMENT_TRANS_ID, 
            p.PROGRAM_ID, p.LABEL_ID `PROGRAM_LABEL_ID`, p.LABEL_EN `PROGRAM_LABEL_EN`, p.LABEL_FR `PROGRAM_LABEL_FR`, p.LABEL_SP `PROGRAM_LABEL_SP`, p.LABEL_PR `PROGRAM_LABEL_PR`,
            pa.PROCUREMENT_AGENT_ID, pa.PROCUREMENT_AGENT_CODE, pa.`COLOR_HTML_CODE`, pa.LABEL_ID `PROCUREMENT_AGENT_LABEL_ID`, pa.LABEL_EN `PROCUREMENT_AGENT_LABEL_EN`, pa.LABEL_FR `PROCUREMENT_AGENT_LABEL_FR`, pa.LABEL_SP `PROCUREMENT_AGENT_LABEL_SP`, pa.LABEL_PR `PROCUREMENT_AGENT_LABEL_PR`,
            pu.PLANNING_UNIT_ID, pu.LABEL_ID `PLANNING_UNIT_LABEL_ID`, pu.LABEL_EN `PLANNING_UNIT_LABEL_EN`, pu.LABEL_FR `PLANNING_UNIT_LABEL_FR`, pu.LABEL_SP `PLANNING_UNIT_LABEL_SP`, pu.LABEL_PR `PLANNING_UNIT_LABEL_PR`,
            rcpu.REALM_COUNTRY_PLANNING_UNIT_ID as RCPU_ID, rcpu.LABEL_ID `RCPU_LABEL_ID`, rcpu.LABEL_EN `RCPU_LABEL_EN`, rcpu.LABEL_FR `RCPU_LABEL_FR`, rcpu.LABEL_SP `RCPU_LABEL_SP`, rcpu.LABEL_PR `RCPU_LABEL_PR`, rcpu.MULTIPLIER `RCPU_MULTIPLIER`,
            fu.FORECASTING_UNIT_ID, fu.LABEL_ID `FORECASTING_UNIT_LABEL_ID`, fu.LABEL_EN `FORECASTING_UNIT_LABEL_EN`, fu.LABEL_FR `FORECASTING_UNIT_LABEL_FR`, fu.LABEL_SP `FORECASTING_UNIT_LABEL_SP`, fu.LABEL_PR `FORECASTING_UNIT_LABEL_PR`,
            pc.PRODUCT_CATEGORY_ID, pc.LABEL_ID `PRODUCT_CATEGORY_LABEL_ID`, pc.LABEL_EN `PRODUCT_CATEGORY_LABEL_EN`, pc.LABEL_FR `PRODUCT_CATEGORY_LABEL_FR`, pc.LABEL_SP `PRODUCT_CATEGORY_LABEL_SP`, pc.LABEL_PR `PRODUCT_CATEGORY_LABEL_PR`,
            pru.PROCUREMENT_UNIT_ID, pru.LABEL_ID `PROCUREMENT_UNIT_LABEL_ID`, pru.LABEL_EN `PROCUREMENT_UNIT_LABEL_EN`, pru.LABEL_FR `PROCUREMENT_UNIT_LABEL_FR`, pru.LABEL_SP `PROCUREMENT_UNIT_LABEL_SP`, pru.LABEL_PR `PROCUREMENT_UNIT_LABEL_PR`,
            su.SUPPLIER_ID, su.LABEL_ID `SUPPLIER_LABEL_ID`, su.LABEL_EN `SUPPLIER_LABEL_EN`, su.LABEL_FR `SUPPLIER_LABEL_FR`, su.LABEL_SP `SUPPLIER_LABEL_SP`, su.LABEL_PR `SUPPLIER_LABEL_PR`,
            shs.SHIPMENT_STATUS_ID, shs.LABEL_ID `SHIPMENT_STATUS_LABEL_ID`, shs.LABEL_EN `SHIPMENT_STATUS_LABEL_EN`, shs.LABEL_FR `SHIPMENT_STATUS_LABEL_FR`, shs.LABEL_SP `SHIPMENT_STATUS_LABEL_SP`, shs.LABEL_PR `SHIPMENT_STATUS_LABEL_PR`,
            ds.DATA_SOURCE_ID, ds.LABEL_ID `DATA_SOURCE_LABEL_ID`, ds.LABEL_EN `DATA_SOURCE_LABEL_EN`, ds.LABEL_FR `DATA_SOURCE_LABEL_FR`, ds.LABEL_SP `DATA_SOURCE_LABEL_SP`, ds.LABEL_PR `DATA_SOURCE_LABEL_PR`,
            sc.CURRENCY_ID `SHIPMENT_CURRENCY_ID`, sc.`CURRENCY_CODE` `SHIPMENT_CURRENCY_CODE`, s.CONVERSION_RATE_TO_USD `SHIPMENT_CONVERSION_RATE_TO_USD`, 
            sc.LABEL_ID `SHIPMENT_CURRENCY_LABEL_ID`, sc.LABEL_EN `SHIPMENT_CURRENCY_LABEL_EN`, sc.LABEL_FR `SHIPMENT_CURRENCY_LABEL_FR`, sc.LABEL_SP `SHIPMENT_CURRENCY_LABEL_SP`, sc.LABEL_PR `SHIPMENT_CURRENCY_LABEL_PR`,
            st.EMERGENCY_ORDER, st.LOCAL_PROCUREMENT, 
            cb.USER_ID `CB_USER_ID`, cb.USERNAME `CB_USERNAME`, s.CREATED_DATE, lmb.USER_ID `LMB_USER_ID`, lmb.USERNAME `LMB_USERNAME`, st.LAST_MODIFIED_DATE, st.ACTIVE,
            bc.CURRENCY_ID `BUDGET_CURRENCY_ID`, bc.CURRENCY_CODE `BUDGET_CURRENCY_CODE`, b.CONVERSION_RATE_TO_USD `BUDGET_CURRENCY_CONVERSION_RATE_TO_USD`, bc.LABEL_ID `BUDGET_CURRENCY_LABEL_ID`, bc.LABEL_EN `BUDGET_CURRENCY_LABEL_EN`, bc.LABEL_FR `BUDGET_CURRENCY_LABEL_FR`, bc.LABEL_SP `BUDGET_CURRENCY_LABEL_SP`, bc.LABEL_PR `BUDGET_CURRENCY_LABEL_PR`, 
            b.BUDGET_ID, b.BUDGET_CODE, b.LABEL_ID `BUDGET_LABEL_ID`, b.LABEL_EN `BUDGET_LABEL_EN`, b.LABEL_FR `BUDGET_LABEL_FR`, b.LABEL_SP `BUDGET_LABEL_SP`, b.LABEL_PR `BUDGET_LABEL_PR`,
            fs.FUNDING_SOURCE_ID, fs.FUNDING_SOURCE_CODE, fs.LABEL_ID `FUNDING_SOURCE_LABEL_ID`, fs.LABEL_EN `FUNDING_SOURCE_LABEL_EN`, fs.LABEL_FR `FUNDING_SOURCE_LABEL_FR`, fs.LABEL_SP `FUNDING_SOURCE_LABEL_SP`, fs.LABEL_PR `FUNDING_SOURCE_LABEL_PR`
        FROM (
            SELECT st.SHIPMENT_ID, MAX(st.VERSION_ID) MAX_VERSION_ID FROM rm_shipment s LEFT JOIN rm_shipment_trans st ON s.SHIPMENT_ID=st.SHIPMENT_ID WHERE (@versiONId=-1 OR st.VERSION_ID<=@versiONId) AND s.PROGRAM_ID=@programId GROUP BY st.SHIPMENT_ID
        ) ts 
        LEFT JOIN rm_shipment s ON ts.SHIPMENT_ID=s.SHIPMENT_ID
        LEFT JOIN rm_shipment_trans st ON ts.SHIPMENT_ID=st.SHIPMENT_ID AND ts.MAX_VERSION_ID=st.VERSION_ID
        LEFT JOIN vw_program p ON s.PROGRAM_ID=p.PROGRAM_ID
        LEFT JOIN vw_procurement_agent pa ON st.PROCUREMENT_AGENT_ID=pa.PROCUREMENT_AGENT_ID
        LEFT JOIN vw_planning_unit pu ON st.PLANNING_UNIT_ID=pu.PLANNING_UNIT_ID
        LEFT JOIN vw_realm_country_planning_unit rcpu ON st.REALM_COUNTRY_PLANNING_UNIT_ID=rcpu.REALM_COUNTRY_PLANNING_UNIT_ID
        LEFT JOIN vw_forecasting_unit fu ON pu.FORECASTING_UNIT_ID=fu.FORECASTING_UNIT_ID
        LEFT JOIN vw_product_category pc ON fu.PRODUCT_CATEGORY_ID=pc.PRODUCT_CATEGORY_ID
        LEFT JOIN vw_procurement_unit pru ON st.PROCUREMENT_UNIT_ID=pru.PROCUREMENT_UNIT_ID
        LEFT JOIN vw_supplier su ON st.SUPPLIER_ID=su.SUPPLIER_ID
        LEFT JOIN vw_shipment_status shs ON st.SHIPMENT_STATUS_ID=shs.SHIPMENT_STATUS_ID
        LEFT JOIN vw_data_source ds ON st.DATA_SOURCE_ID=ds.DATA_SOURCE_ID
        LEFT JOIN us_user cb ON s.CREATED_BY=cb.USER_ID
        LEFT JOIN us_user lmb ON st.LAST_MODIFIED_BY=lmb.USER_ID
        LEFT JOIN vw_currency sc ON s.CURRENCY_ID=sc.CURRENCY_ID
        LEFT JOIN vw_budget b ON st.BUDGET_ID=b.BUDGET_ID
        LEFT JOIN vw_currency bc ON b.CURRENCY_ID=bc.CURRENCY_ID
        LEFT JOIN vw_funding_source fs ON st.FUNDING_SOURCE_ID=fs.FUNDING_SOURCE_ID 
        WHERE 
			(@shipmentActive = FALSE OR st.ACTIVE) 
            AND (FIND_IN_SET(st.PLANNING_UNIT_ID, @planningUnitIds) OR @planningUnitIds='') 
            AND st.ERP_FLAG=0 
            AND st.ACCOUNT_FLAG 
            AND st.SHIPMENT_STATUS_ID IN (3,4,5,6,9,7)
            AND st.PROCUREMENT_AGENT_ID=@procurementAgentId
            AND 
            -- IF(COALESCE(st.RECEIVED_DATE,st.EXPECTED_DELIVERY_DATE) < CURDATE() - INTERVAL 6 MONTH, st.SHIPMENT_STATUS_ID!=7 , 
            st.SHIPMENT_STATUS_ID IN (3,4,5,6,9,7)
            -- )
    ) st  
    LEFT JOIN rm_shipment_trans_batch_info stbi ON st.SHIPMENT_TRANS_ID = stbi.SHIPMENT_TRANS_ID
    LEFT JOIN rm_program_planning_unit ppu ON st.PLANNING_UNIT_ID=ppu.PLANNING_UNIT_ID AND ppu.PROGRAM_ID=@programId
    LEFT JOIN rm_batch_info bi ON stbi.BATCH_ID=bi.BATCH_ID
    WHERE (@planningUnitActive = FALSE OR ppu.ACTIVE) 
    ORDER BY st.PLANNING_UNIT_ID, COALESCE(st.RECEIVED_DATE, st.EXPECTED_DELIVERY_DATE), bi.EXPIRY_DATE, bi.BATCH_ID; 
END$$

DELIMITER ;
;

update ap_static_label l 
left join ap_static_label_languages ll on l.STATIC_LABEL_ID=ll.STATIC_LABEL_ID
set ll.LABEL_TEXT='You might have an older version. You should control+F5 now.'
where l.LABEL_CODE='static.coreui.oldVersion' and ll.LANGUAGE_ID=1;

update ap_static_label l 
left join ap_static_label_languages ll on l.STATIC_LABEL_ID=ll.STATIC_LABEL_ID
set ll.LABEL_TEXT='Vous avez peut-être une version plus ancienne. Vous devriez contrôler + F5 maintenant.'
where l.LABEL_CODE='static.coreui.oldVersion' and ll.LANGUAGE_ID=2;

update ap_static_label l 
left join ap_static_label_languages ll on l.STATIC_LABEL_ID=ll.STATIC_LABEL_ID
set ll.LABEL_TEXT='Es posible que tenga una versión anterior. Deberías controlar+F5 ahora.'
where l.LABEL_CODE='static.coreui.oldVersion' and ll.LANGUAGE_ID=3;

update ap_static_label l 
left join ap_static_label_languages ll on l.STATIC_LABEL_ID=ll.STATIC_LABEL_ID
set ll.LABEL_TEXT='Você pode ter uma versão mais antiga. Você deve controlar + F5 agora.'
where l.LABEL_CODE='static.coreui.oldVersion' and ll.LANGUAGE_ID=4;

