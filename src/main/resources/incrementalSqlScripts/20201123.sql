CREATE TABLE `fasp`.`ap_integration_view` (
  `INTEGRATION_VIEW_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `INTEGRATION_VIEW_DESC` VARCHAR(45) NOT NULL,
  `INTEGRATION_VIEW_NAME` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`INTEGRATION_VIEW_ID`));
INSERT INTO ap_integration_view VALUES (null, "Full QAT View", "cc.altius.FASP.model.Views.InternalView.class"), (null, "Condensed View", "cc.altius.FASP.model.Views.ArtmisView.class"), (null, "Condensed View with Conversion Factor", "cc.altius.FASP.model.Views.GfpVanView.class");

CREATE TABLE `fasp`.`ap_integration` (
  `INTEGRATION_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `INTEGRATION_NAME` VARCHAR(45) NOT NULL,
  `REALM_ID` INT(10) UNSIGNED NOT NULL,
  `FOLDER_LOCATION` VARCHAR(45) NOT NULL ,
  `FILE_NAME` VARCHAR(255) NOT NULL,
  `INTEGRATION_VIEW_ID` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`INTEGRATION_ID`),
  INDEX `fk_ap_integration_realmId_idx` (`REALM_ID` ASC),
  INDEX `fk_ap_integration_integrationViewId_idx` (`INTEGRATION_VIEW_ID` ASC),
  CONSTRAINT `fk_ap_integration_realmId`
    FOREIGN KEY (`REALM_ID`)
    REFERENCES `fasp`.`rm_realm` (`REALM_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ap_integration_integrationViewId`
    FOREIGN KEY (`INTEGRATION_VIEW_ID`)
    REFERENCES `fasp`.`ap_integration_view` (`INTEGRATION_VIEW_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
INSERT INTO `ap_integration` values (null, 'Artmis',1,'Artmis','QAT_SupplyPlan_<%PROGRAM_CODE%>.json', 2), (null, 'GFPVAN',1,'GFPVAN','GHSC-PSM_GFPVAN_SupplyPlanReplace_1.0_[<%PROGRAM_ID%>.<%VERSION_ID%>]-<%YMDHMS%>.txt',3);

CREATE TABLE `fasp`.`rm_integration_program` (
  `INTEGRATION_PROGRAM_ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `INTEGRATION_ID` INT(10) UNSIGNED NOT NULL,
  `PROGRAM_ID` INT(10) UNSIGNED NOT NULL,
  `VERSION_TYPE_ID` INT(10) UNSIGNED NOT NULL COMMENT 'null for all versionTypes, for value for actual',
  `VERSION_STATUS_ID` INT(10) UNSIGNED NOT NULL COMMENT 'null for all versionStatuses, for value for actual',
  `ACTIVE` TINYINT(1) UNSIGNED NOT NULL,
  `CREATED_BY` INT(10) UNSIGNED NOT NULL,
  `CREATED_DATE` DATETIME NOT NULL,
  `LAST_MODIFIED_BY` INT(10) UNSIGNED NOT NULL,
  `LAST_MODIFIED_DATE` DATETIME NOT NULL,
  PRIMARY KEY (`INTEGRATION_PROGRAM_ID`),
  INDEX `fk_rm_integration_program_integrationId_idx` (`INTEGRATION_ID` ASC),
  INDEX `fk_rm_integration_program_programId_idx` (`PROGRAM_ID` ASC),
  INDEX `fk_rm_integration_program_versionTypeId_idx` (`VERSION_TYPE_ID` ASC),
  INDEX `fk_rm_integration_program_versionStatusId_idx` (`VERSION_STATUS_ID` ASC),
  INDEX `fk_rm_integration_program_createdBy_idx` (`CREATED_BY` ASC),
  INDEX `fk_rm_integration_program_lastModifiedBy_idx` (`LAST_MODIFIED_BY` ASC),
  CONSTRAINT `fk_rm_integration_program_integrationId`
    FOREIGN KEY (`INTEGRATION_ID`)
    REFERENCES `fasp`.`ap_integration` (`INTEGRATION_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rm_integration_program_programId`
    FOREIGN KEY (`PROGRAM_ID`)
    REFERENCES `fasp`.`rm_program` (`PROGRAM_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rm_integration_program_versionTypeId`
    FOREIGN KEY (`VERSION_TYPE_ID`)
    REFERENCES `fasp`.`ap_version_type` (`VERSION_TYPE_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rm_integration_program_versionStatusId`
    FOREIGN KEY (`VERSION_STATUS_ID`)
    REFERENCES `fasp`.`ap_version_status` (`VERSION_STATUS_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rm_integration_program_createdBy`
    FOREIGN KEY (`CREATED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rm_integration_program_lastModifiedBy`
    FOREIGN KEY (`LAST_MODIFIED_BY`)
    REFERENCES `fasp`.`us_user` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

INSERT INTO rm_integration_program VALUES 
    (null, 1, 2028, 2, 2, 1, 1, now(), 1, now()),
    (null, 1, 2029, 2, 2, 1, 1, now(), 1, now()),
    (null, 1, 2030, 2, 2, 1, 1, now(), 1, now()),
    (null, 1, 2137, 2, 2, 1, 1, now(), 1, now()),
    (null, 1, 2535, 2, 2, 1, 1, now(), 1, now()),
    (null, 2, 2028, 2, 2, 1, 1, now(), 1, now()),
    (null, 2, 2029, 2, 2, 1, 1, now(), 1, now()),
    (null, 2, 2030, 2, 2, 1, 1, now(), 1, now()),
    (null, 2, 2137, 2, 2, 1, 1, now(), 1, now()),
    (null, 2, 2535, 2, 2, 1, 1, now(), 1, now());


CREATE TABLE `fasp`.`rm_integration_program_completed` (
  `PROGRAM_VERSION_TRANS_ID` INT(10) UNSIGNED NOT NULL,
  `INTEGRATION_ID` INT(10) UNSIGNED NOT NULL,
  `COMPLETED_DATE` DATETIME NULL,
  PRIMARY KEY (`PROGRAM_VERSION_TRANS_ID`, `INTEGRATION_ID`),
  INDEX `fk_rm_integration_program_completed_integrationId_idx` (`INTEGRATION_ID` ASC),
  CONSTRAINT `fk_rm_integration_program_completed_programId`
    FOREIGN KEY (`PROGRAM_VERSION_TRANS_ID`)
    REFERENCES `fasp`.`rm_program_version_trans` (`PROGRAM_VERSION_TRANS_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rm_integration_program_completed_integrationId`
    FOREIGN KEY (`INTEGRATION_ID`)
    REFERENCES `fasp`.`ap_integration` (`INTEGRATION_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

/*[2:00:37 AM][ 50 ms]*/ ALTER TABLE `fasp`.`rm_manual_tagging` ADD COLUMN `CONVERSION_FACTOR` DECIMAL(15,4) NULL AFTER `NOTES`;

DELIMITER $$

USE `fasp`$$

DROP PROCEDURE IF EXISTS `getShipmentListForManualLinking`$$

CREATE DEFINER=`faspUser`@`localhost` PROCEDURE `getShipmentListForManualLinking`(PROGRAM_ID INT(10), PLANNING_UNIT_ID INT(10), VERSION_ID INT (10))
BEGIN
    SET @programId = PROGRAM_ID;
    SET @planningUnitId = PLANNING_UNIT_ID;
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
        st.ORDER_NO, st.PRIME_LINE_NO
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
            st.PLANNING_UNIT_ID, pu.LABEL_ID `PLANNING_UNIT_LABEL_ID`, pu.LABEL_EN `PLANNING_UNIT_LABEL_EN`, pu.LABEL_FR `PLANNING_UNIT_LABEL_FR`, pu.LABEL_SP `PLANNING_UNIT_LABEL_SP`, pu.LABEL_PR `PLANNING_UNIT_LABEL_PR`
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
    WHERE st.ERP_FLAG=0 AND st.ACTIVE AND st.SHIPMENT_STATUS_ID IN (3,4,5,6,9) AND st.PLANNING_UNIT_ID=@planningUnitId AND (mt.SHIPMENT_ID IS NULL OR mt.ACTIVE=0) AND st.PROCUREMENT_AGENT_ID=@procurementAgentId
) st
ORDER BY COALESCE(st.RECEIVED_DATE, st.EXPECTED_DELIVERY_DATE);
END$$

DELIMITER ;

DELIMITER $$

USE `fasp`$$

DROP PROCEDURE IF EXISTS `getShipmentListForDelinking`$$

CREATE DEFINER=`faspUser`@`localhost` PROCEDURE `getShipmentListForDelinking`(PROGRAM_ID INT(10), PLANNING_UNIT_ID INT(10), VERSION_ID INT (10))
BEGIN
    SET @programId = PROGRAM_ID;
    SET @planningUnitId = PLANNING_UNIT_ID;
    SET @versionId = VERSION_ID;
    SET @procurementAgentId = 1;

    IF @versionId = -1 THEN
        SELECT MAX(pv.VERSION_ID) INTO @versionId FROM rm_program_version pv WHERE pv.PROGRAM_ID=@programId;
    END IF;
   
SELECT
    st.SHIPMENT_ID, st.SHIPMENT_TRANS_ID, st.SHIPMENT_QTY, st.EXPECTED_DELIVERY_DATE, st.PLANNING_UNIT_ID, st.PRODUCT_COST, st.SKU_CODE,
    st.PROCUREMENT_AGENT_ID, st.PROCUREMENT_AGENT_CODE, st.`COLOR_HTML_CODE`, st.`PROCUREMENT_AGENT_LABEL_ID`, st.`PROCUREMENT_AGENT_LABEL_EN`, st.`PROCUREMENT_AGENT_LABEL_FR`, st.`PROCUREMENT_AGENT_LABEL_SP`, st.`PROCUREMENT_AGENT_LABEL_PR`,
    st.FUNDING_SOURCE_ID, st.FUNDING_SOURCE_CODE, st.`FUNDING_SOURCE_LABEL_ID`, st.`FUNDING_SOURCE_LABEL_EN`, st.`FUNDING_SOURCE_LABEL_FR`, st.`FUNDING_SOURCE_LABEL_SP`, st.`FUNDING_SOURCE_LABEL_PR`,
    st.BUDGET_ID, st.BUDGET_CODE, st.`BUDGET_LABEL_ID`, st.`BUDGET_LABEL_EN`, st.`BUDGET_LABEL_FR`, st.`BUDGET_LABEL_SP`, st.`BUDGET_LABEL_PR`,
    st.SHIPMENT_STATUS_ID, st.`SHIPMENT_STATUS_LABEL_ID`, st.`SHIPMENT_STATUS_LABEL_EN`, st.`SHIPMENT_STATUS_LABEL_FR`, st.`SHIPMENT_STATUS_LABEL_SP`, st.`SHIPMENT_STATUS_LABEL_PR`,
    st.`PLANNING_UNIT_LABEL_ID`, st.`PLANNING_UNIT_LABEL_EN`, st.`PLANNING_UNIT_LABEL_FR`, st.`PLANNING_UNIT_LABEL_SP`, st.`PLANNING_UNIT_LABEL_PR`,
    st.ORDER_NO, st.PRIME_LINE_NO
FROM (
    SELECT
        s.SHIPMENT_ID, st.RECEIVED_DATE, st.EXPECTED_DELIVERY_DATE,st.SHIPMENT_QTY, st.RATE, st.PRODUCT_COST, st.FREIGHT_COST, st.ACCOUNT_FLAG, st.SHIPMENT_TRANS_ID, st.PLANNING_UNIT_ID,papu.SKU_CODE,
        pa.PROCUREMENT_AGENT_ID, pa.PROCUREMENT_AGENT_CODE, pa.`COLOR_HTML_CODE`, pa.LABEL_ID `PROCUREMENT_AGENT_LABEL_ID`, pa.LABEL_EN `PROCUREMENT_AGENT_LABEL_EN`, pa.LABEL_FR `PROCUREMENT_AGENT_LABEL_FR`, pa.LABEL_SP `PROCUREMENT_AGENT_LABEL_SP`, pa.LABEL_PR `PROCUREMENT_AGENT_LABEL_PR`,
        fs.`FUNDING_SOURCE_ID`, fs.`FUNDING_SOURCE_CODE`, fs.LABEL_ID `FUNDING_SOURCE_LABEL_ID`, fs.LABEL_EN `FUNDING_SOURCE_LABEL_EN`, fs.LABEL_FR `FUNDING_SOURCE_LABEL_FR`, fs.LABEL_SP `FUNDING_SOURCE_LABEL_SP`, fs.LABEL_PR `FUNDING_SOURCE_LABEL_PR`,
        shs.SHIPMENT_STATUS_ID, shs.LABEL_ID `SHIPMENT_STATUS_LABEL_ID`, shs.LABEL_EN `SHIPMENT_STATUS_LABEL_EN`, shs.LABEL_FR `SHIPMENT_STATUS_LABEL_FR`, shs.LABEL_SP `SHIPMENT_STATUS_LABEL_SP`, shs.LABEL_PR `SHIPMENT_STATUS_LABEL_PR`,
        sc.CURRENCY_ID `SHIPMENT_CURRENCY_ID`, sc.`CURRENCY_CODE` `SHIPMENT_CURRENCY_CODE`, s.CONVERSION_RATE_TO_USD `SHIPMENT_CONVERSION_RATE_TO_USD`,
        sc.LABEL_ID `SHIPMENT_CURRENCY_LABEL_ID`, sc.LABEL_EN `SHIPMENT_CURRENCY_LABEL_EN`, sc.LABEL_FR `SHIPMENT_CURRENCY_LABEL_FR`, sc.LABEL_SP `SHIPMENT_CURRENCY_LABEL_SP`, sc.LABEL_PR `SHIPMENT_CURRENCY_LABEL_PR`,
        st.ACTIVE, st.`ORDER_NO`, st.`PRIME_LINE_NO`,
        b.BUDGET_ID, b.BUDGET_CODE, b.LABEL_ID `BUDGET_LABEL_ID`, b.LABEL_EN `BUDGET_LABEL_EN`, b.LABEL_FR `BUDGET_LABEL_FR`, b.LABEL_SP `BUDGET_LABEL_SP`, b.LABEL_PR `BUDGET_LABEL_PR`,
        pu.LABEL_ID `PLANNING_UNIT_LABEL_ID`, pu.LABEL_EN `PLANNING_UNIT_LABEL_EN`, pu.LABEL_FR `PLANNING_UNIT_LABEL_FR`, pu.LABEL_SP `PLANNING_UNIT_LABEL_SP`, pu.LABEL_PR `PLANNING_UNIT_LABEL_PR`
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
    LEFT JOIN rm_manual_tagging mt ON ts.SHIPMENT_ID=mt.SHIPMENT_ID
    LEFT JOIN rm_procurement_agent_planning_unit papu ON papu.PROCUREMENT_AGENT_ID=pa.PROCUREMENT_AGENT_ID AND papu.PLANNING_UNIT_ID=st.PLANNING_UNIT_ID
    WHERE st.PLANNING_UNIT_ID=@planningUnitId AND st.PROCUREMENT_AGENT_ID=@procurementAgentId AND mt.SHIPMENT_ID IS NOT NULL AND mt.ACTIVE
) st
ORDER BY COALESCE(st.RECEIVED_DATE, st.EXPECTED_DELIVERY_DATE);
END$$

DELIMITER ;


UPDATE ap_problem_status SET LABEL_ID=1128 WHERE PROBLEM_STATUS_ID=4;