--
-- ---------------------------- Task №1
--

CREATE DATABASE  IF NOT EXISTS `kids` /* DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /* DEFAULT ENCRYPTION='N' */; 
USE `kids`;

--
-- Table structure for table `games`
--

CREATE TABLE `games` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int unsigned NOT NULL,
  `name` varchar(64) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_game_id` (`game_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Table structure for table `toys`
--

CREATE TABLE `toys` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `toy_id` int unsigned NOT NULL,
  `name` varchar(64) NOT NULL,
  `status` enum('ok','broken','repair') NOT NULL,
  `status_updated` timestamp NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_toy_id` (`toy_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DELIMITER |
 CREATE TRIGGER `toys_AFTER_UPDATE` AFTER UPDATE ON `toys` FOR EACH ROW 
 BEGIN
     UPDATE toys SET OLD.status_updated = curdate();
 END;


--
-- Table structure for table `toys_games`
--

CREATE TABLE `toys_games` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int unsigned NOT NULL,
  `toy_id` int unsigned NOT NULL,
  `note` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_game_id_idx` (`game_id`),
  KEY `fk_toy_id_idx` (`toy_id`),
  KEY `idx_note` (`note`),
  CONSTRAINT `fk_game_id` FOREIGN KEY (`game_id`) REFERENCES `games` (`game_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_note` FOREIGN KEY (`note`) REFERENCES `toys_repair` (`issue_description`),
  CONSTRAINT `fk_toy_id` FOREIGN KEY (`toy_id`) REFERENCES `toys` (`toy_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


--
-- ---------------------------- Task №2
--

--
-- Table structure for table `toys_repair`
--

CREATE TABLE `toys_repair` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `toy_id` int unsigned NOT NULL,
  `issue_description` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_toy_id_idx` (`toy_id`),
  KEY `idx_issue_descr` (`issue_description`),
  CONSTRAINT `fk2_toy_id` FOREIGN KEY (`toy_id`) REFERENCES `toys` (`toy_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


--
-- ---------------------------- Task №4
--

SELECT t.toy_id, t.name as toy_name, t.status, t.status_updated, tmp.name as game_name, tmp.date, tmp.note from toys as t join (SELECT g.name, g.game_id, g.date, gt.toy_id, gt.note from games as g join toys_games as gt using(game_id)) as tmp using(toy_id) where tmp.date >= DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR) ;


--
-- ---------------------------- Task №5
--

SELECT t.toy_id, t.name from toys as t left join toys_repair as trep using(toy_id) where trep.issue_description = null;