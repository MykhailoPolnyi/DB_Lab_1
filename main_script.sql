-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Polnyi_DB
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Polnyi_DB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Polnyi_DB` DEFAULT CHARACTER SET utf8 ;
USE `Polnyi_DB` ;

-- -----------------------------------------------------
-- Table `Polnyi_DB`.`loader`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Polnyi_DB`.`loader` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `surname` VARCHAR(45) NOT NULL,
  `mobile_phone` CHAR(10) NULL,
  `company` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Polnyi_DB`.`adress`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Polnyi_DB`.`adress` (
  `id` INT NOT NULL,
  `country` VARCHAR(15) NULL,
  `city` VARCHAR(20) NULL,
  `street` VARCHAR(20) NULL,
  `house_number` VARCHAR(5) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Polnyi_DB`.`snack_machine`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Polnyi_DB`.`snack_machine` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `adress_id` INT NULL,
  `last_load` DATE NULL,
  `loader_id` INT NULL,
  `last_cash_gathering` DATE NULL,
  `gathered_cash` INT UNSIGNED ZEROFILL NULL,
  `coins_load_date` DATE NULL,
  `loaded_coins_sum` INT UNSIGNED ZEROFILL NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_snack_machine_loader_idx` (`loader_id` ASC) VISIBLE,
  CONSTRAINT `fk_snack_machine_loader`
    FOREIGN KEY (`loader_id`)
    REFERENCES `Polnyi_DB`.`loader` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
  CONSTRAINT `fk_snack_machine_adress1`
    FOREIGN KEY (`adress_id`)
    REFERENCES `Polnyi_DB`.`adress` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Polnyi_DB`.`snack`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Polnyi_DB`.`snack` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `trademark` VARCHAR(45) NOT NULL,
  `snack_type` VARCHAR(45) NOT NULL,
  `price` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Polnyi_DB`.`snack_machine_has_snack`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Polnyi_DB`.`snack_machine_has_snack` (
  `snack_machine_id` INT NOT NULL,
  `snack_id` INT NOT NULL,
  `snack_amount` INT ZEROFILL UNSIGNED NULL,
  `saled_snacks` INT ZEROFILL UNSIGNED NULL,
  `loaded_snacks` INT ZEROFILL NULL,
  PRIMARY KEY (`snack_machine_id`, `snack_id`),
  INDEX `fk_snack_machine_has_snack_snack1_idx` (`snack_id` ASC) VISIBLE,
  INDEX `fk_snack_machine_has_snack_snack_machine1_idx` (`snack_machine_id` ASC) VISIBLE,
  CONSTRAINT `fk_snack_machine_has_snack_snack_machine1`
    FOREIGN KEY (`snack_machine_id`)
    REFERENCES `Polnyi_DB`.`snack_machine` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_snack_machine_has_snack_snack1`
    FOREIGN KEY (`snack_id`)
    REFERENCES `Polnyi_DB`.`snack` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
