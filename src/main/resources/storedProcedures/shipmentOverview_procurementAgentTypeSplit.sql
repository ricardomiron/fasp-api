CREATE DEFINER=`faspUser`@`%` PROCEDURE `shipmentOverview_procurementAgentTypeSplit`(
    VAR_USER_ID INT(10), 
    VAR_REALM_ID INT(10), 
    VAR_START_DATE DATE, 
    VAR_STOP_DATE DATE, 
    VAR_REALM_COUNTRY_IDS TEXT, 
    VAR_PROGRAM_IDS TEXT, 
    VAR_FUNDING_SOURCE_IDS TEXT, 
    VAR_PLANNING_UNIT_IDS TEXT, 
    VAR_SHIPMENT_STATUS_IDS VARCHAR(255), 
    VAR_APPROVED_SUPPLY_PLAN_ONLY TINYINT(1))
BEGIN
        
 -- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 -- Report no 20 - Part 3 ProcurementAgentType Split
 -- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 -- Only Month and Year will be considered for StartDate and StopDate
 -- Must be a valid RealmId that you want to see the Global Report for
 -- RealmCountryIds is the list of Realm Countries you want to run the report for 
 -- Empty RealmCountryIds means you want to run the report for all the Realm Countries
 -- ProgramIds is the list of the Programs that you want to run the report for
 -- Empty ProgramIds means you want to run the report for all the Programs in the Realm
 -- PlanningUnitIds is the list of Planning Units you want to run the report for. 
 -- Empty PlanningUnitIds means you want to run the report for all the Planning Units
 -- FundingSourceIds is the list of Funding Sources that you want to run the report for
 -- Empty FundingSourceIds means you want to run for all the Funding Sources
 -- ShipmentStatusIds is the list of ShipmentStatuses that you want to run the report for
 -- Empty ShipmentStatusIds means you want to run for all Shipment Statuses
 
    DECLARE done INT DEFAULT 0;
    DECLARE procurementAgentId INT(10) DEFAULT 0;
    DECLARE procurementAgentCode VARCHAR(10) DEFAULT "";
    DECLARE curRealmCountryId INT;
    DECLARE curHealthAreaId INT;
    DECLARE curOrganisationId INT;
    DECLARE curProgramId INT;
    DECLARE procurement_cursor CURSOR FOR SELECT pat.PROCUREMENT_AGENT_TYPE_ID, pat.PROCUREMENT_AGENT_TYPE_CODE
        FROM 
            (
            SELECT pv.PROGRAM_ID, pv.VERSION_ID, s.SHIPMENT_ID, MAX(st.VERSION_ID) `MAX_VERSION_ID` 
            FROM 
                ( 
                SELECT p.PROGRAM_ID, MAX(pv.VERSION_ID) VERSION_ID 
                FROM rm_program p 
                LEFT JOIN rm_realm_country rc ON p.REALM_COUNTRY_ID=rc.REALM_COUNTRY_ID         
                LEFT JOIN rm_program_planning_unit ppu ON p.PROGRAM_ID=ppu.PROGRAM_ID AND (LENGTH(@planningUnitIds)=0 OR FIND_IN_SET(ppu.PLANNING_UNIT_ID,@planningUnitIds))
                LEFT JOIN rm_planning_unit pu ON ppu.PLANNING_UNIT_ID=pu.PLANNING_UNIT_ID
                LEFT JOIN rm_program_version pv ON p.PROGRAM_ID=pv.PROGRAM_ID 
                WHERE 
                    TRUE AND rc.REALM_ID=@realmId AND ppu.ACTIVE AND pu.ACTIVE AND ppu.PROGRAM_PLANNING_UNIT_ID IS NOT NULL 
                    AND (LENGTH(@realmCountryIds)=0 OR FIND_IN_SET(p.REALM_COUNTRY_ID, @realmCountryIds))
                    AND (@approvedSupplyPlanOnly=0 OR (pv.VERSION_TYPE_ID=2 and pv.VERSION_STATUS_ID=2))
                    AND (LENGTH(@programIds)=0 OR FIND_IN_SET(p.PROGRAM_ID, @programIds))
                GROUP BY p.PROGRAM_ID 
            ) pv 
            LEFT JOIN rm_program p ON pv.PROGRAM_ID=p.PROGRAM_ID 
            LEFT JOIN rm_shipment s ON p.PROGRAM_ID=s.PROGRAM_ID 
            LEFT JOIN rm_shipment_trans st ON s.SHIPMENT_ID=st.SHIPMENT_ID AND st.VERSION_ID<=pv.VERSION_ID 
            WHERE 
                (LENGTH(@planningUnitIds)=0 OR FIND_IN_SET(st.PLANNING_UNIT_ID,@planningUnitIds))
                AND (LENGTH(@fundingSourceIds)=0 OR FIND_IN_SET(st.FUNDING_SOURCE_ID,@fundingSourceIds))
                AND (LENGTH(@shipmentStatusIds)=0 OR FIND_IN_SET(st.SHIPMENT_STATUS_ID,@shipmentStatusIds))
                AND st.ACTIVE AND st.ACCOUNT_FLAG
                AND st.SHIPMENT_STATUS_ID != 8 
                AND COALESCE(st.RECEIVED_DATE, st.EXPECTED_DELIVERY_DATE) BETWEEN @startDate AND @stopDate 
            GROUP BY s.SHIPMENT_ID 
        ) AS s1 
        LEFT JOIN rm_program p ON s1.PROGRAM_ID=p.PROGRAM_ID 
        LEFT JOIN rm_shipment s ON s1.SHIPMENT_ID=s.SHIPMENT_ID 
        LEFT JOIN rm_shipment_trans st ON s1.SHIPMENT_ID=st.SHIPMENT_ID AND s1.MAX_VERSION_ID=st.VERSION_ID 
        LEFT JOIN rm_procurement_agent pa ON st.PROCUREMENT_AGENT_ID=pa.PROCUREMENT_AGENT_ID
        LEFT JOIN rm_procurement_agent_type pat ON pa.PROCUREMENT_AGENT_TYPE_ID=pat.PROCUREMENT_AGENT_TYPE_ID
        GROUP BY pa.PROCUREMENT_AGENT_TYPE_ID;
    DECLARE cursor_acl CURSOR FOR SELECT acl.REALM_COUNTRY_ID, acl.HEALTH_AREA_ID, acl.ORGANISATION_ID, acl.PROGRAM_ID FROM us_user_acl acl WHERE acl.USER_ID=VAR_USER_ID;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    SET @startDate = VAR_START_DATE;
    SET @stopDate = VAR_STOP_DATE;
    SET @realmId = VAR_REALM_ID;
    SET @sqlStringProcurementAgent = "";
    SET @approvedSupplyPlanOnly = VAR_APPROVED_SUPPLY_PLAN_ONLY;
    SET @realmCountryIds = VAR_REALM_COUNTRY_IDS;
    SET @programIds = VAR_PROGRAM_IDS;
    SET @planningUnitIds = VAR_PLANNING_UNIT_IDS;
    SET @fundingSourceIds = VAR_FUNDING_SOURCE_IDS;
    SET @shipmentStatusIds = VAR_SHIPMENT_STATUS_IDS;

    SET @aclSqlString = CONCAT("       AND (FALSE ");
    OPEN cursor_acl;
        read_loop: LOOP
        FETCH cursor_acl INTO curRealmCountryId, curHealthAreaId, curOrganisationId, curProgramId;
        IF done THEN
            LEAVE read_loop;
        END IF;
        -- For each loop build the sql for acl
        SET @aclSqlString = CONCAT(@aclSqlString,"       OR (");
        SET @aclSqlString = CONCAT(@aclSqlString,"           (p.PROGRAM_ID IS NULL OR ",IFNULL(curRealmCountryId,-1),"=-1 OR p.REALM_COUNTRY_ID=",IFNULL(curRealmCountryId,-1),")");
        SET @aclSqlString = CONCAT(@aclSqlString,"       AND (p.PROGRAM_ID IS NULL OR ",IFNULL(curHealthAreaId,-1)  ,"=-1 OR FIND_IN_SET(",IFNULL(curHealthAreaId,-1),",p.HEALTH_AREA_ID))");
        SET @aclSqlString = CONCAT(@aclSqlString,"       AND (p.PROGRAM_ID IS NULL OR ",IFNULL(curOrganisationId,-1),"=-1 OR p.ORGANISATION_ID=" ,IFNULL(curOrganisationId,-1),")");
        SET @aclSqlString = CONCAT(@aclSqlString,"       AND (p.PROGRAM_ID IS NULL OR ",IFNULL(curProgramId,-1)     ,"=-1 OR p.PROGRAM_ID="      ,IFNULL(curProgramId,-1)     ,")");
        SET @aclSqlString = CONCAT(@aclSqlString,"       )");
    END LOOP;
    CLOSE cursor_acl;
    SET @aclSqlString = CONCAT(@aclSqlString, ") ");
    
    SET done = 0;
        OPEN procurement_cursor;
    getProcurementAgent: LOOP
        FETCH procurement_cursor into procurementAgentId, procurementAgentCode;
        IF done = 1 THEN 
            LEAVE getProcurementAgent;
        END IF;
        SET @sqlStringProcurementAgent = CONCAT(@sqlStringProcurementAgent, " ,SUM(IF(pa.PROCUREMENT_AGENT_TYPE_ID=",procurementAgentId,", st.SHIPMENT_QTY, 0)) `PA_",procurementAgentCode,"` ");
    END LOOP getProcurementAgent;
    
    SET @sqlString = "";
    SET @sqlString = CONCAT(@sqlString, "SELECT pu.PLANNING_UNIT_ID, pu.LABEL_ID `PLANNING_UNIT_LABEL_ID`, pu.LABEL_EN `PLANNING_UNIT_LABEL_EN`, pu.LABEL_FR `PLANNING_UNIT_LABEL_FR`, pu.LABEL_SP `PLANNING_UNIT_LABEL_SP`, pu.LABEL_PR `PLANNING_UNIT_LABEL_PR`, pu.MULTIPLIER, SUM(st.SHIPMENT_QTY) `SHIPMENT_QTY` ");
    SET @sqlString = CONCAT(@sqlString, @sqlStringProcurementAgent);
    SET @sqlString = CONCAT(@sqlString, "FROM ");
    SET @sqlString = CONCAT(@sqlString, "       ( ");
    SET @sqlString = CONCAT(@sqlString, "       SELECT pv.PROGRAM_ID, pv.VERSION_ID, s.SHIPMENT_ID, MAX(st.VERSION_ID) `MAX_VERSION_ID` ");
    SET @sqlString = CONCAT(@sqlString, "       FROM ");
    SET @sqlString = CONCAT(@sqlString, "           ( ");
    SET @sqlString = CONCAT(@sqlString, "       SELECT p.PROGRAM_ID, MAX(pv.VERSION_ID) VERSION_ID ");
    SET @sqlString = CONCAT(@sqlString, "       FROM vw_program p ");
    SET @sqlString = CONCAT(@sqlString, "       LEFT JOIN rm_realm_country rc ON p.REALM_COUNTRY_ID=rc.REALM_COUNTRY_ID         ");
    SET @sqlString = CONCAT(@sqlString, "       LEFT JOIN rm_program_version pv ON p.PROGRAM_ID=pv.PROGRAM_ID ");
    SET @sqlString = CONCAT(@sqlString, "       WHERE TRUE ");
    SET @sqlString = CONCAT(@sqlString, "       AND rc.REALM_ID=@realmId ");
    SET @sqlString = CONCAT(@sqlString, "       AND (LENGTH(@realmCountryIds)=0 OR FIND_IN_SET(p.REALM_COUNTRY_ID, @realmCountryIds))");
    SET @sqlString = CONCAT(@sqlString, "       AND (LENGTH(@programIds)=0 OR FIND_IN_SET(p.PROGRAM_ID,@programIds))");
    SET @sqlString = CONCAT(@sqlString, "       AND (@approvedSupplyPlanOnly=0 OR (pv.VERSION_TYPE_ID=2 and pv.VERSION_STATUS_ID=2)) ");
    SET @sqlString = CONCAT(@sqlString, @aclSqlString);
    SET @sqlString = CONCAT(@sqlString, "       GROUP BY p.PROGRAM_ID ");
    SET @sqlString = CONCAT(@sqlString, "       ) pv ");
    SET @sqlString = CONCAT(@sqlString, "       LEFT JOIN rm_program p ON pv.PROGRAM_ID=p.PROGRAM_ID ");
    SET @sqlString = CONCAT(@sqlString, "       LEFT JOIN rm_shipment s ON p.PROGRAM_ID=s.PROGRAM_ID  ");
    SET @sqlString = CONCAT(@sqlString, "       LEFT JOIN rm_shipment_trans st ON s.SHIPMENT_ID=st.SHIPMENT_ID AND st.VERSION_ID<=pv.VERSION_ID ");
    SET @sqlString = CONCAT(@sqlString, "       WHERE TRUE ");
    SET @sqlString = CONCAT(@sqlString, "       GROUP BY s.SHIPMENT_ID ");
    SET @sqlString = CONCAT(@sqlString, "       ) AS s1 ");
    SET @sqlString = CONCAT(@sqlString, "       LEFT JOIN rm_program p ON s1.PROGRAM_ID=p.PROGRAM_ID ");
    SET @sqlString = CONCAT(@sqlString, "       LEFT JOIN rm_shipment s ON s1.SHIPMENT_ID=s.SHIPMENT_ID ");
    SET @sqlString = CONCAT(@sqlString, "       LEFT JOIN rm_shipment_trans st ON s1.SHIPMENT_ID=st.SHIPMENT_ID AND s1.MAX_VERSION_ID=st.VERSION_ID ");
    SET @sqlString = CONCAT(@sqlString, "       LEFT JOIN rm_procurement_agent pa ON st.PROCUREMENT_AGENT_ID=pa.PROCUREMENT_AGENT_ID ");
    SET @sqlString = CONCAT(@sqlString, "       LEFT JOIN vw_planning_unit pu ON st.PLANNING_UNIT_ID=pu.PLANNING_UNIT_ID ");
    SET @sqlString = CONCAT(@sqlString, "       LEFT JOIN rm_program_planning_unit ppu ON p.PROGRAM_ID=ppu.PROGRAM_ID AND pu.PLANNING_UNIT_ID=ppu.PLANNING_UNIT_ID ");
    SET @sqlString = CONCAT(@sqlString, "       WHERE pu.ACTIVE AND ppu.PROGRAM_PLANNING_UNIT_ID IS NOT NULL AND ppu.ACTIVE AND ");
    SET @sqlString = CONCAT(@sqlString, "           st.ACTIVE AND st.ACCOUNT_FLAG AND st.SHIPMENT_STATUS_ID != 8 ");
    SET @sqlString = CONCAT(@sqlString, "       AND (LENGTH(@planningUnitIds)=0 OR FIND_IN_SET(st.PLANNING_UNIT_ID,@planningUnitIds)) ");
    SET @sqlString = CONCAT(@sqlString, "       AND (LENGTH(@shipmentStatusIds)=0 OR FIND_IN_SET(st.SHIPMENT_STATUS_ID,@shipmentStatusIds)) ");
    SET @sqlString = CONCAT(@sqlString, "       AND COALESCE(st.RECEIVED_DATE, st.EXPECTED_DELIVERY_DATE) BETWEEN @startDate AND @stopDate ");
    SET @sqlString = CONCAT(@sqlString, "       AND (LENGTH(@fundingSourceIds)=0 OR FIND_IN_SET(st.FUNDING_SOURCE_ID,@fundingSourceIds)) ");
    SET @sqlString = CONCAT(@sqlString, "       GROUP BY st.PLANNING_UNIT_ID");
        
    PREPARE S1 FROM @sqlString;
    EXECUTE S1;
END