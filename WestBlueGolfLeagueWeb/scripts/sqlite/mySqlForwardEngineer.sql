-- MySQL Script generated by MySQL Workbench
-- 01/04/15 23:32:27
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema westbluegolf
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `westbluegolf` ;

-- -----------------------------------------------------
-- Schema westbluegolf
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `westbluegolf` DEFAULT CHARACTER SET utf8 ;
USE `westbluegolf` ;

-- -----------------------------------------------------
-- Table `westbluegolf`.`__migrationhistory`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`__migrationhistory` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`__migrationhistory` (
  `MigrationId` VARCHAR(150) NOT NULL,
  `ContextKey` VARCHAR(300) NOT NULL,
  `Model` LONGBLOB NOT NULL,
  `ProductVersion` VARCHAR(32) NOT NULL,
  PRIMARY KEY (`MigrationId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `westbluegolf`.`course`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`course` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`course` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(120) NOT NULL,
  `par` INT(11) NOT NULL,
  `street` VARCHAR(80) NULL DEFAULT NULL,
  `state` VARCHAR(45) NULL DEFAULT NULL,
  `zip` VARCHAR(12) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `courseName1` (`name` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 28
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `westbluegolf`.`year`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`year` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`year` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `value` INT(11) NOT NULL,
  `isComplete` TINYINT(1) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `yearValue` (`value` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 17
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `westbluegolf`.`datamigration`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`datamigration` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`datamigration` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `dataMigrationDate` DATETIME NOT NULL,
  `notes` VARCHAR(200) NULL DEFAULT NULL,
  `yearId` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_dataMigration_year1_idx` (`yearId` ASC),
  CONSTRAINT `fk_dataMigration_year1`
    FOREIGN KEY (`yearId`)
    REFERENCES `westbluegolf`.`year` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 17
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `westbluegolf`.`leaderboard`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`leaderboard` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`leaderboard` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `isPlayerBoard` TINYINT(1) NOT NULL,
  `priority` INT(11) NOT NULL,
  `key` VARCHAR(50) NOT NULL,
  `formatType` INT(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  INDEX `lookup` (`key` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 30
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `westbluegolf`.`player`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`player` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`player` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(120) NOT NULL,
  `currentHandicap` INT(11) NOT NULL,
  `favorite` TINYINT(1) NOT NULL,
  `validPlayer` TINYINT(1) NOT NULL,
  `modifiedDate` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `playerName1` (`name` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 329
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `westbluegolf`.`team`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`team` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`team` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `teamName` VARCHAR(120) NOT NULL,
  `validTeam` TINYINT(1) NOT NULL,
  `modifiedDate` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `teamNameIndex1` (`teamName` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 26
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `westbluegolf`.`leaderboarddata`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`leaderboarddata` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`leaderboarddata` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `rank` INT(11) NOT NULL,
  `value` DOUBLE NOT NULL,
  `leaderBoardId` INT(11) NOT NULL,
  `yearId` INT(11) NOT NULL,
  `isPlayer` TINYINT(1) NOT NULL,
  `teamId` INT(11) NULL DEFAULT NULL,
  `playerId` INT(11) NULL DEFAULT NULL,
  `detail` VARCHAR(100) NULL DEFAULT NULL,
  `formattedValue` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_leader_board_data_leader_board1_idx` (`leaderBoardId` ASC),
  INDEX `fk_leader_board_data_year1_idx` (`yearId` ASC),
  INDEX `fk_leaderBoardData_team1_idx` (`teamId` ASC),
  INDEX `fk_leaderBoardData_player1_idx` (`playerId` ASC),
  CONSTRAINT `fk_leaderBoardData_player1`
    FOREIGN KEY (`playerId`)
    REFERENCES `westbluegolf`.`player` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_leaderBoardData_team1`
    FOREIGN KEY (`teamId`)
    REFERENCES `westbluegolf`.`team` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_leader_board_data_leader_board1`
    FOREIGN KEY (`leaderBoardId`)
    REFERENCES `westbluegolf`.`leaderboard` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_leader_board_data_year1`
    FOREIGN KEY (`yearId`)
    REFERENCES `westbluegolf`.`year` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 18666
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `westbluegolf`.`starttime`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`starttime` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`starttime` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `time` VARCHAR(45) NOT NULL,
  `startTime` DATETIME NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `westbluegolf`.`pairing`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`pairing` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`pairing` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `pairingText` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `westbluegolf`.`week`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`week` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`week` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `courseId` INT(11) NOT NULL,
  `yearId` INT(11) NOT NULL,
  `isBadData` TINYINT(1) NOT NULL,
  `seasonIndex` INT(11) NOT NULL,
  `isPlayoff` TINYINT(1) NOT NULL,
  `pairingId` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_week_course1_idx` (`courseId` ASC),
  INDEX `fk_week_year1_idx` (`yearId` ASC),
  INDEX `fk_week_pairing1_idx` (`pairingId` ASC),
  CONSTRAINT `fk_week_course1`
    FOREIGN KEY (`courseId`)
    REFERENCES `westbluegolf`.`course` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_week_pairing1`
    FOREIGN KEY (`pairingId`)
    REFERENCES `westbluegolf`.`pairing` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_week_year1`
    FOREIGN KEY (`yearId`)
    REFERENCES `westbluegolf`.`year` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 299
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `westbluegolf`.`teammatchup`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`teammatchup` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`teammatchup` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `playoffType` VARCHAR(75) NULL DEFAULT NULL,
  `weekId` INT(11) NOT NULL,
  `matchComplete` TINYINT(1) NOT NULL,
  `startTimeId` INT(11) NULL DEFAULT NULL,
  `matchId` INT(11) NULL DEFAULT NULL,
  `matchupType` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_team_matchup_week1_idx` (`weekId` ASC),
  INDEX `fk_team_matchup_start_times1_idx` (`startTimeId` ASC),
  CONSTRAINT `fk_team_matchup_start_times1`
    FOREIGN KEY (`startTimeId`)
    REFERENCES `westbluegolf`.`starttime` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_team_matchup_week1`
    FOREIGN KEY (`weekId`)
    REFERENCES `westbluegolf`.`week` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 1130
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `westbluegolf`.`match`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`match` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`match` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `teamMatchupId` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_matchup_team_matchup1_idx` (`teamMatchupId` ASC),
  CONSTRAINT `fk_matchup_team_matchup1`
    FOREIGN KEY (`teamMatchupId`)
    REFERENCES `westbluegolf`.`teammatchup` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 4343
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `westbluegolf`.`matchtoplayer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`matchtoplayer` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`matchtoplayer` (
  `playerId` INT(11) NOT NULL,
  `matchId` INT(11) NOT NULL,
  INDEX `fk_matchupToPlayer_player1_idx` (`playerId` ASC),
  INDEX `fk_matchupToPlayer_matchup1_idx` (`matchId` ASC),
  CONSTRAINT `fk_matchupToPlayer_matchup1`
    FOREIGN KEY (`matchId`)
    REFERENCES `westbluegolf`.`match` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_matchupToPlayer_player1`
    FOREIGN KEY (`playerId`)
    REFERENCES `westbluegolf`.`player` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `westbluegolf`.`playeryeardata`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`playeryeardata` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`playeryeardata` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `isRookie` TINYINT(1) NOT NULL,
  `startingHandicap` INT(11) NOT NULL,
  `finishingHandicap` INT(11) NOT NULL,
  `playerId` INT(11) NOT NULL,
  `yearId` INT(11) NOT NULL,
  `teamId` INT(11) NOT NULL,
  `week0Score` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_player_year_data_player1_idx` (`playerId` ASC),
  INDEX `fk_player_year_data_year1_idx` (`yearId` ASC),
  INDEX `fk_playerYearData_team1_idx` (`teamId` ASC),
  CONSTRAINT `fk_playerYearData_team1`
    FOREIGN KEY (`teamId`)
    REFERENCES `westbluegolf`.`team` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_player_year_data_player1`
    FOREIGN KEY (`playerId`)
    REFERENCES `westbluegolf`.`player` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_player_year_data_year1`
    FOREIGN KEY (`yearId`)
    REFERENCES `westbluegolf`.`year` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 1154
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `westbluegolf`.`result`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`result` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`result` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `priorHandicap` INT(11) NOT NULL,
  `score` INT(11) NOT NULL,
  `points` INT(11) NOT NULL,
  `teamId` INT(11) NOT NULL,
  `playerId` INT(11) NOT NULL,
  `matchId` INT(11) NOT NULL,
  `yearId` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_result_team1_idx` (`teamId` ASC),
  INDEX `fk_result_player1_idx` (`playerId` ASC),
  INDEX `fk_result_matchup1_idx` (`matchId` ASC),
  INDEX `fk_result_year1_idx` (`yearId` ASC),
  CONSTRAINT `fk_result_matchup1`
    FOREIGN KEY (`matchId`)
    REFERENCES `westbluegolf`.`match` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_result_player1`
    FOREIGN KEY (`playerId`)
    REFERENCES `westbluegolf`.`player` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_result_team1`
    FOREIGN KEY (`teamId`)
    REFERENCES `westbluegolf`.`team` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_result_year1`
    FOREIGN KEY (`yearId`)
    REFERENCES `westbluegolf`.`year` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 8685
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `westbluegolf`.`roles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`roles` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`roles` (
  `id` VARCHAR(128) NOT NULL,
  `name` VARCHAR(128) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `RoleNameIndex` USING HASH (`name` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `westbluegolf`.`teammatchuptoteam`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`teammatchuptoteam` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`teammatchuptoteam` (
  `teamMatchupId` INT(11) NOT NULL,
  `teamId` INT(11) NOT NULL,
  INDEX `fk_teamMatchupToTeam_teamMatchup1_idx` (`teamMatchupId` ASC),
  INDEX `fk_teamMatchupToTeam_team1_idx` (`teamId` ASC),
  CONSTRAINT `fk_teamMatchupToTeam_team1`
    FOREIGN KEY (`teamId`)
    REFERENCES `westbluegolf`.`team` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_teamMatchupToTeam_teamMatchup1`
    FOREIGN KEY (`teamMatchupId`)
    REFERENCES `westbluegolf`.`teammatchup` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `westbluegolf`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`user` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`user` (
  `id` INT(11) NOT NULL,
  `username` VARCHAR(100) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL,
  `passwordHash` VARCHAR(200) NOT NULL,
  `salt` VARCHAR(45) NOT NULL,
  `dateAdded` DATETIME NOT NULL,
  `email` VARCHAR(120) NULL DEFAULT NULL,
  `role` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `westbluegolf`.`users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`users` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`users` (
  `id` VARCHAR(128) NOT NULL,
  `email` VARCHAR(256) NULL DEFAULT NULL,
  `emailConfirmed` TINYINT(1) NOT NULL,
  `passwordHash` LONGTEXT NULL DEFAULT NULL,
  `securityStamp` LONGTEXT NULL DEFAULT NULL,
  `phoneNumber` LONGTEXT NULL DEFAULT NULL,
  `phoneNumberConfirmed` TINYINT(1) NOT NULL,
  `twoFactorEnabled` TINYINT(1) NOT NULL,
  `lockoutEndDateUtc` DATETIME NULL DEFAULT NULL,
  `lockoutEnabled` TINYINT(1) NOT NULL,
  `accessFailedCount` INT(11) NOT NULL,
  `userName` VARCHAR(128) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UserNameIndex` USING HASH (`userName` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `westbluegolf`.`userclaims`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`userclaims` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`userclaims` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `userId` VARCHAR(128) NOT NULL,
  `claimType` LONGTEXT NULL DEFAULT NULL,
  `claimValue` LONGTEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `IX_UserId` USING HASH (`userId` ASC),
  CONSTRAINT `FK_userClaims_users_userId`
    FOREIGN KEY (`userId`)
    REFERENCES `westbluegolf`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `westbluegolf`.`userlogins`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`userlogins` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`userlogins` (
  `loginProvider` VARCHAR(128) NOT NULL,
  `providerKey` VARCHAR(128) NOT NULL,
  `userId` VARCHAR(128) NOT NULL,
  PRIMARY KEY (`loginProvider`, `providerKey`, `userId`),
  INDEX `IX_UserId` USING HASH (`userId` ASC),
  CONSTRAINT `FK_userLogins_users_userId`
    FOREIGN KEY (`userId`)
    REFERENCES `westbluegolf`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `westbluegolf`.`userroles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `westbluegolf`.`userroles` ;

CREATE TABLE IF NOT EXISTS `westbluegolf`.`userroles` (
  `userId` VARCHAR(128) NOT NULL,
  `roleId` VARCHAR(128) NOT NULL,
  PRIMARY KEY (`userId`, `roleId`),
  INDEX `IX_UserId` USING HASH (`userId` ASC),
  INDEX `IX_RoleId` USING HASH (`roleId` ASC),
  CONSTRAINT `FK_userRoles_roles_roleId`
    FOREIGN KEY (`roleId`)
    REFERENCES `westbluegolf`.`roles` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_userRoles_users_userId`
    FOREIGN KEY (`userId`)
    REFERENCES `westbluegolf`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
