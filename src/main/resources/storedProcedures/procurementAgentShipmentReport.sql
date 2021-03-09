CREATE DEFINER=`faspUser`@`localhost` PROCEDURE `procurementAgentShipmentReport`(VAR_START_DATE DATE, VAR_STOP_DATE DATE, VAR_PROCUREMENT_AGENT_IDS VARCHAR(255), VAR_PROGRAM_ID INT, VAR_VERSION_ID INT, VAR_PLANNING_UNIT_IDS TEXT, VAR_INCLUDE_PLANNED_SHIPMENTS TINYINT)
BEGIN
    -- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    -- Report no 13
    -- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    -- programId must be a single Program cannot be muti-program select or -1 for all programs
    -- versionId must be the actual version that you want to refer to for this report or -1 in which case it will automatically take the latest version (not approved or final just latest)
    -- procurementAgentIds is a list of the ProcurementAgents that you want to run the report for. Empty for all.
    -- report will be run using startDate and stopDate based on Delivered Date or Expected Delivery Date
    -- planningUnitIds is provided as a list of planningUnitId's or empty for all
    -- includePlannedShipments = 1 means the report will include all shipments that are Active and not Cancelled
    -- includePlannedShipments = 0 means only Approve, Shipped, Arrived, Delivered statuses will be included in the report
    -- FreightCost and ProductCost are converted to USD
    -- FreightPerc is in SUM(FREIGHT_COST)/SUM(PRODUCT_COST) for that ProcurementAgent and that PlanningUnit
    
    SET @programId = VAR_PROGRAM_ID;
    SET @versionId = VAR_VERSION_ID;
    IF @versionId = -1 THEN
	SELECT MAX(pv.VERSION_ID) INTO @versionId FROM rm_program_version pv WHERE pv.PROGRAM_ID=@programId;
    END IF;
    SET @startDate = CONCAT(VAR_START_DATE,' 00:00:00');
    SET @stopDate = CONCAT(VAR_STOP_DATE, ' 23:59:59');
    SET @includePlannedShipments = VAR_INCLUDE_PLANNED_SHIPMENTS;
    SET @planningUnitIds = VAR_PLANNING_UNIT_IDS;
    SET @procurementAgentIds = VAR_PROCUREMENT_AGENT_IDS;

    SELECT 
    	pa.PROCUREMENT_AGENT_ID, pa.PROCUREMENT_AGENT_CODE, pa.LABEL_ID `PROCUREMENT_AGENT_LABEL_ID`, pa.LABEL_EN `PROCUREMENT_AGENT_LABEL_EN`, pa.LABEL_FR `PROCUREMENT_AGENT_LABEL_FR`, pa.LABEL_SP `PROCUREMENT_AGENT_LABEL_SP`, pa.LABEL_PR `PROCUREMENT_AGENT_LABEL_PR`, 
    	pu.PLANNING_UNIT_ID, pu.LABEL_ID `PLANNING_UNIT_LABEL_ID`, pu.LABEL_EN `PLANNING_UNIT_LABEL_EN`, pu.LABEL_FR `PLANNING_UNIT_LABEL_FR`, pu.LABEL_SP `PLANNING_UNIT_LABEL_SP`, pu.LABEL_PR `PLANNING_UNIT_LABEL_PR`, 
    	SUM(st.SHIPMENT_QTY) QTY, SUM(st.PRODUCT_COST*s.CONVERSION_RATE_TO_USD) `PRODUCT_COST`, SUM(st.FREIGHT_COST*s.CONVERSION_RATE_TO_USD) `FREIGHT_COST`, SUM(st.FREIGHT_COST*s.CONVERSION_RATE_TO_USD)/SUM(st.PRODUCT_COST*s.CONVERSION_RATE_TO_USD)*100 `FREIGHT_PERC` 
    FROM 
    	(
    	SELECT 
            s.PROGRAM_ID, s.SHIPMENT_ID, s.CONVERSION_RATE_TO_USD, MAX(st.VERSION_ID) MAX_VERSION_ID 
    	FROM rm_shipment s 
    	LEFT JOIN rm_shipment_trans st ON s.SHIPMENT_ID=st.SHIPMENT_ID 
    	WHERE 
            s.PROGRAM_ID=@programId 
            AND st.VERSION_ID<=@versionId 
            AND st.SHIPMENT_TRANS_ID IS NOT NULL 
    	GROUP BY s.SHIPMENT_ID 
    ) AS s 
    LEFT JOIN rm_shipment s1 ON s.SHIPMENT_ID=s1.SHIPMENT_ID 
    LEFT JOIN rm_shipment_trans st ON s.SHIPMENT_ID=st.SHIPMENT_ID AND s.MAX_VERSION_ID=st.VERSION_ID 
    LEFT JOIN vw_procurement_agent pa ON st.PROCUREMENT_AGENT_ID=pa.PROCUREMENT_AGENT_ID 
    LEFT JOIN vw_planning_unit pu ON st.PLANNING_UNIT_ID = pu.PLANNING_UNIT_ID 
    LEFT JOIN rm_program_planning_unit ppu ON st.PLANNING_UNIT_ID = ppu.PLANNING_UNIT_ID AND s1.PROGRAM_ID=ppu.PROGRAM_ID 
    WHERE 
    	st.ACTIVE AND ppu.ACTIVE AND pu.ACTIVE  AND st.ACCOUNT_FLAG 
    	AND st.SHIPMENT_STATUS_ID != 8 
    	AND ((@includePlannedShipments=0 && st.SHIPMENT_STATUS_ID in (3,4,5,6,7)) OR @includePlannedShipments=1) 
    	AND COALESCE(st.RECEIVED_DATE, st.EXPECTED_DELIVERY_DATE) BETWEEN @startDate AND @stopDate 
	AND (LENGTH(@planningUnitIds)=0 OR FIND_IN_SET(st.PLANNING_UNIT_ID, @planningUnitIds)) 
       	AND (LENGTH(@procurementAgentIds)=0 OR FIND_IN_SET(st.PROCUREMENT_AGENT_ID, @procurementAgentIds)) 
    GROUP BY st.PROCUREMENT_AGENT_ID, st.PLANNING_UNIT_ID;
    
END$$

DELIMITER ;