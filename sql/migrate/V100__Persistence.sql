-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.0.16 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             9.5.0.5196
-- --------------------------------------------------------

/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

CREATE TABLE IF NOT EXISTS `list_element` (
  `id` int NOT NULL AUTO_INCREMENT,
  `list_id` int NOT NULL,
  `key` longtext NOT NULL,
  `key_type` varchar(256) NOT NULL,
  `value` longtext NOT NULL,
  `value_type` varchar(256) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `thing` (
  `p_id` varchar(12) NOT NULL,
  `type` varchar(256) NOT NULL,
  `x` int DEFAULT NULL,
  `y` int DEFAULT NULL,
  `z` int DEFAULT NULL,
  `ref` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`p_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `thing_var` (
  `id` int NOT NULL AUTO_INCREMENT,
  `thing_id` varchar(12) NOT NULL,
  `key` varchar(256) NOT NULL,
  `type` varchar(256) NOT NULL,
  `value` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `z_level` (
  `id` int NOT NULL AUTO_INCREMENT,
  `z` int NOT NULL,
  `dynamic` bool NOT NULL DEFAULT '0',
  `default_turf` varchar(256) DEFAULT NULL,
  `metadata` varchar(64) DEFAULT NULL,
  `areas` longtext NOT NULL,
  `level_data_subtype` VARCHAR(256) NOT NULL DEFAULT 'space',
  `level_data_id` VARCHAR(256) NOT NULL COMMENT 'level_data id for this level.',
  `level_data_pid` VARCHAR(12) NOT NULL COMMENT 'The persistent ID of the level_data datum that was saved for this level.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `level_data_id_UNIQUE` (`level_data_id`),
  UNIQUE INDEX `level_data_pid_UNIQUE` (`level_data_pid`),
  INDEX `KEY_level_data_id` (`level_data_id`),
  INDEX `KEY_z` (`z`),
  INDEX `KEY_level_data_pid` (`level_data_pid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `areas` (
	`id` int NOT NULL AUTO_INCREMENT,
	`type` longtext NOT NULL,
	`name` longtext NOT NULL,
	`turfs` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

CREATE TABLE IF NOT EXISTS `limbo` (
  `key` longtext NOT NULL,
  `type` varchar(64) NOT NULL,
  `p_ids` longtext NOT NULL,
  `metadata` varchar(64) DEFAULT NULL,
  `limbo_assoc` varchar(12) NOT NULL,
  `metadata2` varchar(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

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

CREATE TABLE IF NOT EXISTS `limbo_thing` (
  `p_id` varchar(12) NOT NULL,
  `type` varchar(256) NOT NULL,
  `x` int DEFAULT NULL,
  `y` int DEFAULT NULL,
  `z` int DEFAULT NULL,
  `limbo_assoc` varchar(12) NOT NULL,
  PRIMARY KEY (`p_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `limbo_thing_var` (
  `id` int NOT NULL AUTO_INCREMENT,
  `thing_id` varchar(12) NOT NULL,
  `key` varchar(256) NOT NULL,
  `type` varchar(256) NOT NULL,
  `value` longtext NOT NULL,
  `limbo_assoc` varchar(12) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
