-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema ToKnight
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ToKnight
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ToKnight` DEFAULT CHARACTER SET latin1 ;
USE `ToKnight` ;

-- -----------------------------------------------------
-- Table `ToKnight`.`Users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ToKnight`.`Users` ;

CREATE TABLE IF NOT EXISTS `ToKnight`.`Users` (
  `UserID` INT(11) NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(100) NOT NULL,
  `Email` VARCHAR(100) NOT NULL,
  `CreatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`UserID`),
  UNIQUE INDEX `UserID_UNIQUE` (`UserID` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ToKnight`.`Channels`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ToKnight`.`Channels` ;

CREATE TABLE IF NOT EXISTS `ToKnight`.`Channels` (
  `ChannelID` INT(11) NOT NULL AUTO_INCREMENT,
  `CreateByUserID` INT(11) NOT NULL,
  `CreatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Active_Dead` TINYINT(1) NOT NULL,
  PRIMARY KEY (`ChannelID`),
  UNIQUE INDEX `ChannelID_UNIQUE` (`ChannelID` ASC),
  INDEX `UserID_idx` (`CreateByUserID` ASC),
  CONSTRAINT `UserID`
    FOREIGN KEY (`CreateByUserID`)
    REFERENCES `ToKnight`.`Users` (`UserID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ToKnight`.`Queries`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ToKnight`.`Queries` ;

CREATE TABLE IF NOT EXISTS `ToKnight`.`Queries` (
  `QueryID` INT(11) NOT NULL AUTO_INCREMENT,
  `QueryString` VARCHAR(200) NOT NULL,
  `CreatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`QueryID`),
  UNIQUE INDEX `QueryID_UNIQUE` (`QueryID` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ToKnight`.`Events`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ToKnight`.`Events` ;

CREATE TABLE IF NOT EXISTS `ToKnight`.`Events` (
  `EventID` INT(11) NOT NULL AUTO_INCREMENT,
  `EventTitle` VARCHAR(100) NOT NULL,
  `EventDateTime` DATETIME NOT NULL,
  `EventURL` VARCHAR(200) NULL,
  `QueryID` INT NOT NULL,
  `CreatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`EventID`),
  INDEX `QueryID_idx` (`QueryID` ASC),
  UNIQUE INDEX `EventID_UNIQUE` (`EventID` ASC),
  CONSTRAINT `QueryID`
    FOREIGN KEY (`QueryID`)
    REFERENCES `ToKnight`.`Queries` (`QueryID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ToKnight`.`Votes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ToKnight`.`Votes` ;

CREATE TABLE IF NOT EXISTS `ToKnight`.`Votes` (
  `VoteID` INT(11) NOT NULL AUTO_INCREMENT,
  `VoteDefinition` VARCHAR(50) NOT NULL,
  `VoteValue` INT(11) NOT NULL,
  PRIMARY KEY (`VoteID`),
  UNIQUE INDEX `VoteID_UNIQUE` (`VoteID` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ToKnight`.`EventVotes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ToKnight`.`EventVotes` ;

CREATE TABLE IF NOT EXISTS `ToKnight`.`EventVotes` (
  `VoteID` INT(11) NOT NULL AUTO_INCREMENT,
  `EventID` INT(11) NOT NULL,
  `UserID` INT(11) NOT NULL,
  `Vote` INT(11) NOT NULL,
  `CreatedAt` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`VoteID`),
  INDEX `EventID_idx` (`EventID` ASC),
  INDEX `UserID_idx` (`UserID` ASC),
  INDEX `VoteID_idx` (`Vote` ASC),
  UNIQUE INDEX `VoteID_UNIQUE` (`VoteID` ASC),
  CONSTRAINT `EventID`
    FOREIGN KEY (`EventID`)
    REFERENCES `ToKnight`.`Events` (`EventID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `UserID`
    FOREIGN KEY (`UserID`)
    REFERENCES `ToKnight`.`Users` (`UserID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `VoteID`
    FOREIGN KEY (`Vote`)
    REFERENCES `ToKnight`.`Votes` (`VoteID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ToKnight`.`QueriesToEvents`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ToKnight`.`QueriesToEvents` ;

CREATE TABLE IF NOT EXISTS `ToKnight`.`QueriesToEvents` (
  `QueryToEventID` INT(11) NOT NULL AUTO_INCREMENT,
  `QueryID` INT(11) NOT NULL,
  `EventID` INT(11) NOT NULL,
  PRIMARY KEY (`QueryToEventID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ToKnight`.`UserMemberChannels`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ToKnight`.`UserMemberChannels` ;

CREATE TABLE IF NOT EXISTS `ToKnight`.`UserMemberChannels` (
  `UserChannelID` INT(11) NOT NULL AUTO_INCREMENT,
  `UserID` INT(11) NOT NULL,
  `ChannelID` INT(11) NOT NULL,
  `PermissionLevel` INT NOT NULL DEFAULT 2,
  `CreatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`UserChannelID`),
  INDEX `UserID_idx` (`UserID` ASC),
  INDEX `ChannelID_idx` (`ChannelID` ASC),
  UNIQUE INDEX `UserChannelID_UNIQUE` (`UserChannelID` ASC),
  CONSTRAINT `UserID`
    FOREIGN KEY (`UserID`)
    REFERENCES `ToKnight`.`Users` (`UserID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ChannelID`
    FOREIGN KEY (`ChannelID`)
    REFERENCES `ToKnight`.`Channels` (`ChannelID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
