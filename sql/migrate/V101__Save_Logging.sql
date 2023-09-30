-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.11.2-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.5.0.6677
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Dumping structure for procedure outreach13.ClearWorldSave
DELIMITER //
CREATE PROCEDURE `ClearWorldSave`()
    MODIFIES SQL DATA
    SQL SECURITY INVOKER
    COMMENT 'Delete all the data from the previous world save before we make a new one.'
BEGIN
	DELETE FROM list_element;
	DELETE FROM thing;
	DELETE FROM thing_var;
	DELETE FROM z_level;
	## TODO: Add code for handling selectively removing entries when save system update comes in
END//
DELIMITER ;

-- Dumping structure for function outreach13.GetLastWorldSaveTime
DELIMITER //
CREATE FUNCTION `GetLastWorldSaveTime`() RETURNS datetime
    READS SQL DATA
    SQL SECURITY INVOKER
    COMMENT 'Returns the DATETIME of when the last world save logged was.'
BEGIN
	RETURN (SELECT save_logging.time_end FROM save_logging WHERE save_logging.save_type = 'WORLD' LIMIT 1);
END//
DELIMITER ;

-- Dumping structure for function outreach13.LogSaveEnd
DELIMITER //
CREATE FUNCTION `LogSaveEnd`(`MyId` INT,
	`MyNbSavedLevels` INT,
	`MyNbSavedAtoms` INT,
	`MyResult` LONGTEXT
) RETURNS int(11)
    MODIFIES SQL DATA
    SQL SECURITY INVOKER
    COMMENT 'Marks the save end time in the logging table. Returns the save log entry index.'
BEGIN
	UPDATE save_logging 
	SET    time_end = CURRENT_TIMESTAMP(), save_result = MyResult, nb_saved_levels = MyNbSavedLevels, nb_saved_atoms = MyNbSavedAtoms
	WHERE `id` = MyId;
	RETURN MyId;
END//
DELIMITER ;

-- Dumping structure for function outreach13.LogSaveStorageStart
DELIMITER //
CREATE FUNCTION `LogSaveStorageStart`(`Initiator` VARCHAR(64)
) RETURNS int(11)
    MODIFIES SQL DATA
    SQL SECURITY INVOKER
    COMMENT 'Adds an entry to the save log for this save storage/limbo save. Returns the index in the save log this save session log is at.'
BEGIN
	INSERT INTO save_logging (save_logging.save_initiator, save_logging.save_type) VALUES (Initiator, 'STORAGE');
	RETURN (SELECT LAST_INSERT_ID() FROM save_logging LIMIT 1);
END//
DELIMITER ;

-- Dumping structure for function outreach13.LogSaveWorldStart
DELIMITER //
CREATE FUNCTION `LogSaveWorldStart`(`Initiator` VARCHAR(64)
) RETURNS int(11)
    MODIFIES SQL DATA
    SQL SECURITY INVOKER
    COMMENT 'Adds an entry to the save log for this world save session. Returns the index in the save log this save session log is at.'
BEGIN
	INSERT INTO save_logging (save_logging.save_initiator, save_logging.save_type) VALUES (Initiator, 'WORLD');
	RETURN (SELECT LAST_INSERT_ID() FROM save_logging LIMIT 1);
END//
DELIMITER ;

-- Dumping structure for table outreach13.save_logging
CREATE TABLE IF NOT EXISTS `save_logging` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `time_start` datetime DEFAULT current_timestamp() COMMENT 'The time the save started at.',
  `time_end` datetime DEFAULT NULL COMMENT 'The time the save completed at.',
  `save_initiator` varchar(128) DEFAULT NULL COMMENT 'The ckey or description of who started the save!',
  `save_type` enum('WORLD','STORAGE') NOT NULL COMMENT 'Whether the save was a world save, or was just for saving a set of specific atoms.',
  `save_result` longtext DEFAULT NULL COMMENT 'What the result of the save was.',
  `nb_saved_levels` int(10) unsigned DEFAULT NULL,
  `nb_saved_atoms` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Keeps a record of all the save writes done to this save database. So it''s easier to see where something could have went wrong.';

-- Data exporting was unselected.

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
