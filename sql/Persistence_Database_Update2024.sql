-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 23, 2024 at 10:33 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

-- --------------------------------------------------------

--
-- Table structure for table `characters`
--

CREATE TABLE `characters` (
  `CharacterID` int(11) NOT NULL,
  `RealName` varchar(30) NOT NULL,
  `OriginalSave` int(11) DEFAULT 0,
  `ckey` varchar(30) NOT NULL,
  `slot` int(11) NOT NULL,
  `status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `charactersaves`
--

CREATE TABLE `charactersaves` (
  `CharacterSaveID` int(11) NOT NULL,
  `InstanceID` int(11) NOT NULL,
  `CharacterID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `instances`
--

CREATE TABLE `instances` (
  `InstanceID` int(11) NOT NULL,
  `head` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `list_element`
--

CREATE TABLE `list_element` (
  `id` int(11) NOT NULL,
  `list_id` int(11) NOT NULL,
  `key` longtext NOT NULL,
  `key_type` varchar(256) NOT NULL,
  `value` longtext NOT NULL,
  `value_type` varchar(256) NOT NULL,
  `InstanceID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `save_logging`
--

CREATE TABLE `save_logging` (
  `id` int(10) UNSIGNED NOT NULL,
  `time_start` datetime DEFAULT current_timestamp() COMMENT 'The time the save started at.',
  `time_end` datetime DEFAULT NULL COMMENT 'The time the save completed at.',
  `save_initiator` varchar(128) DEFAULT NULL COMMENT 'The ckey or description of who started the save!',
  `save_type` enum('WORLD','STORAGE') NOT NULL COMMENT 'Whether the save was a world save, or was just for saving a set of specific atoms.',
  `save_result` longtext DEFAULT NULL COMMENT 'What the result of the save was.',
  `nb_saved_levels` int(10) UNSIGNED DEFAULT NULL,
  `nb_saved_atoms` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Keeps a record of all the save writes done to this save database. So it''s easier to see where something could have went wrong.';

-- --------------------------------------------------------

--
-- Table structure for table `thing`
--

CREATE TABLE `thing` (
  `p_id` int(11) NOT NULL,
  `type` varchar(256) NOT NULL,
  `x` int(11) DEFAULT NULL,
  `y` int(11) DEFAULT NULL,
  `z` int(11) DEFAULT NULL,
  `ref` varchar(12) DEFAULT NULL,
  `InstanceID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `thing_var`
--

CREATE TABLE `thing_var` (
  `id` int(11) NOT NULL,
  `thing_id` int(11) NOT NULL,
  `key` varchar(256) NOT NULL,
  `type` varchar(256) NOT NULL,
  `value` longtext NOT NULL,
  `InstanceID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `worldsaves`
--

CREATE TABLE `worldsaves` (
  `WorldsaveID` int(11) NOT NULL,
  `InstanceID` int(11) NOT NULL,
  `creationtime` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `characters`
--
ALTER TABLE `characters`
  ADD PRIMARY KEY (`CharacterID`);

--
-- Indexes for table `charactersaves`
--
ALTER TABLE `charactersaves`
  ADD PRIMARY KEY (`CharacterSaveID`);

--
-- Indexes for table `instances`
--
ALTER TABLE `instances`
  ADD PRIMARY KEY (`InstanceID`);

--
-- Indexes for table `list_element`
--
ALTER TABLE `list_element`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `save_logging`
--
ALTER TABLE `save_logging`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `thing`
--
ALTER TABLE `thing`
  ADD PRIMARY KEY (`p_id`,`InstanceID`);

--
-- Indexes for table `thing_var`
--
ALTER TABLE `thing_var`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `worldsaves`
--
ALTER TABLE `worldsaves`
  ADD PRIMARY KEY (`WorldsaveID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `characters`
--
ALTER TABLE `characters`
  MODIFY `CharacterID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `charactersaves`
--
ALTER TABLE `charactersaves`
  MODIFY `CharacterSaveID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `instances`
--
ALTER TABLE `instances`
  MODIFY `InstanceID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `list_element`
--
ALTER TABLE `list_element`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `save_logging`
--
ALTER TABLE `save_logging`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `thing_var`
--
ALTER TABLE `thing_var`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `worldsaves`
--
ALTER TABLE `worldsaves`
  MODIFY `WorldsaveID` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
