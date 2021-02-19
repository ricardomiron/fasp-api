ALTER TABLE `fasp`.`rm_procurement_agent_planning_unit` 
CHANGE COLUMN `VOLUME` `VOLUME` DECIMAL(18,6) UNSIGNED NULL DEFAULT NULL ,
CHANGE COLUMN `WEIGHT` `WEIGHT` DECIMAL(18,6) UNSIGNED NULL DEFAULT NULL ;

ALTER TABLE `fasp`.`rm_procurement_unit` 
CHANGE COLUMN `WIDTH_QTY` `WIDTH_QTY` DECIMAL(16,6) UNSIGNED NULL DEFAULT NULL COMMENT 'Width' ,
CHANGE COLUMN `HEIGHT_QTY` `HEIGHT_QTY` DECIMAL(16,6) UNSIGNED NULL DEFAULT NULL COMMENT 'Height' ,
CHANGE COLUMN `LENGTH_QTY` `LENGTH_QTY` DECIMAL(16,6) UNSIGNED NULL DEFAULT NULL COMMENT 'Length' ,
CHANGE COLUMN `WEIGHT_QTY` `WEIGHT_QTY` DECIMAL(16,6) UNSIGNED NULL DEFAULT NULL COMMENT 'Weight' ,
CHANGE COLUMN `VOLUME_QTY` `VOLUME_QTY` DECIMAL(16,6) UNSIGNED NULL DEFAULT NULL ;
