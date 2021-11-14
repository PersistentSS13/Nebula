-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.0.16 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             9.5.0.5196
-- --------------------------------------------------------

/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping structure for table persistent.list_element
DROP TABLE IF EXISTS `list_element`;
CREATE TABLE IF NOT EXISTS `list_element` (
  `id` int NOT NULL AUTO_INCREMENT,
  `list_id` int NOT NULL,
  `key` longtext NOT NULL,
  `key_type` varchar(256) NOT NULL,
  `value` longtext NOT NULL,
  `value_type` varchar(256) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.
-- Dumping structure for table persistent.thing
DROP TABLE IF EXISTS `thing`;
CREATE TABLE IF NOT EXISTS `thing` (
  `p_id` varchar(12) NOT NULL,
  `type` varchar(256) NOT NULL,
  `x` int DEFAULT NULL,
  `y` int DEFAULT NULL,
  `z` int DEFAULT NULL,
  `ref` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`p_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.
-- Dumping structure for table persistent.thing_var
DROP TABLE IF EXISTS `thing_var`;
CREATE TABLE IF NOT EXISTS `thing_var` (
  `id` int NOT NULL AUTO_INCREMENT,
  `thing_id` varchar(12) NOT NULL,
  `key` varchar(256) NOT NULL,
  `type` varchar(256) NOT NULL,
  `value` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.
-- Dumping structure for table persistent.z_level
DROP TABLE IF EXISTS `z_level`;
CREATE TABLE IF NOT EXISTS `z_level` (
  `id` int NOT NULL AUTO_INCREMENT,
  `z` int NOT NULL,
  `dynamic` bool NOT NULL DEFAULT '0',
  `default_turf` varchar(256) DEFAULT NULL,
  `metadata` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `limbo`;
CREATE TABLE IF NOT EXISTS `limbo` (
  `key` longtext NOT NULL,
  `type` varchar(64) NOT NULL,
  `p_ids` longtext NOT NULL,
  `metadata` varchar(64) DEFAULT NULL,
  `limbo_assoc` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

DROP TABLE IF EXISTS `limbo_list_element`;
CREATE TABLE IF NOT EXISTS `limbo_list_element` (
  `id` int NOT NULL AUTO_INCREMENT,
  `list_id` int NOT NULL,
  `key` longtext NOT NULL,
  `key_type` varchar(256) NOT NULL,
  `value` longtext NOT NULL,
  `value_type` varchar(256) NOT NULL,
  `limbo_assoc` varchar(12) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.
-- Dumping structure for table persistent.thing
DROP TABLE IF EXISTS `limbo_thing`;
CREATE TABLE IF NOT EXISTS `limbo_thing` (
  `p_id` varchar(12) NOT NULL,
  `type` varchar(256) NOT NULL,
  `x` int DEFAULT NULL,
  `y` int DEFAULT NULL,
  `z` int DEFAULT NULL,
  `limbo_assoc` varchar(12) NOT NULL,
  PRIMARY KEY (`p_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.
-- Dumping structure for table persistent.thing_var
DROP TABLE IF EXISTS `limbo_thing_var`;
CREATE TABLE IF NOT EXISTS `limbo_thing_var` (
  `id` int NOT NULL AUTO_INCREMENT,
  `thing_id` varchar(12) NOT NULL,
  `key` varchar(256) NOT NULL,
  `type` varchar(256) NOT NULL,
  `value` longtext NOT NULL,
  `limbo_assoc` varchar(12) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
