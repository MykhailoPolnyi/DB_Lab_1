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
-- Table `Polnyi_DB`.`country`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Polnyi_DB`.`country` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Polnyi_DB`.`city`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Polnyi_DB`.`city` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `country_id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `region` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_city_country1_idx` (`country_id` ASC) VISIBLE,
  CONSTRAINT `fk_city_country1`
    FOREIGN KEY (`country_id`)
    REFERENCES `Polnyi_DB`.`country` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Polnyi_DB`.`full_adress`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Polnyi_DB`.`full_adress` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `city_id` INT NOT NULL,
  `street` VARCHAR(45) NULL,
  `number` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_full_adress_city1_idx` (`city_id` ASC) VISIBLE,
  CONSTRAINT `fk_full_adress_city1`
    FOREIGN KEY (`city_id`)
    REFERENCES `Polnyi_DB`.`city` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Polnyi_DB`.`machine_producer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Polnyi_DB`.`machine_producer` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `full_adress_id` INT NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `mobile_phone` CHAR(12) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_machine_producer_full_adress1_idx` (`full_adress_id` ASC) VISIBLE,
  CONSTRAINT `fk_machine_producer_full_adress1`
    FOREIGN KEY (`full_adress_id`)
    REFERENCES `Polnyi_DB`.`full_adress` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Polnyi_DB`.`machine_model`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Polnyi_DB`.`machine_model` (
  `model` VARCHAR(50) NOT NULL,
  `max_capacity` INT UNSIGNED NOT NULL,
  `electricity_consumption_wh` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`model`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Polnyi_DB`.`producer_model`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Polnyi_DB`.`producer_model` (
  `machine_producer_id` INT NOT NULL,
  `machine_model_model` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`machine_producer_id`, `machine_model_model`),
  INDEX `fk_machine_producer_has_machine_model_machine_model1_idx` (`machine_model_model` ASC) VISIBLE,
  INDEX `fk_machine_producer_has_machine_model_machine_producer1_idx` (`machine_producer_id` ASC) VISIBLE,
  CONSTRAINT `fk_machine_producer_has_machine_model_machine_producer1`
    FOREIGN KEY (`machine_producer_id`)
    REFERENCES `Polnyi_DB`.`machine_producer` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_machine_producer_has_machine_model_machine_model1`
    FOREIGN KEY (`machine_model_model`)
    REFERENCES `Polnyi_DB`.`machine_model` (`model`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Polnyi_DB`.`snack_machine`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Polnyi_DB`.`snack_machine` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `full_adress_id` INT NOT NULL,
  `machine_producer_id` INT NOT NULL,
  `machine_model` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_snack_machine_full_adress1_idx` (`full_adress_id` ASC) VISIBLE,
  INDEX `fk_snack_machine_producer_model1_idx` (`machine_producer_id` ASC, `machine_model` ASC) VISIBLE,
  CONSTRAINT `fk_snack_machine_full_adress1`
    FOREIGN KEY (`full_adress_id`)
    REFERENCES `Polnyi_DB`.`full_adress` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_snack_machine_producer_model1`
    FOREIGN KEY (`machine_producer_id` , `machine_model`)
    REFERENCES `Polnyi_DB`.`producer_model` (`machine_producer_id` , `machine_model_model`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Polnyi_DB`.`loader`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Polnyi_DB`.`loader` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `surname` VARCHAR(45) NOT NULL,
  `mobile_phone` CHAR(12) NULL,
  `company` VARCHAR(45) NULL,
  `full_adress_id` INT NULL,
  `email` VARCHAR(45) NULL,
  PRIMARY KEY (`id`)),
  INDEX `fk_loader_full_adress1_idx` (`full_adress_id` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  UNIQUE INDEX `mobile_phone_UNIQUE` (`mobile_phone` ASC) VISIBLE,
  CONSTRAINT `fk_loader_full_adress1`
    FOREIGN KEY (`full_adress_id`)
    REFERENCES `Polnyi_DB`.`full_adress` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Polnyi_DB`.`snake_producer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Polnyi_DB`.`snake_producer` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NULL,
  `mobile_phone` CHAR(12) NULL,
  `full_adress_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  INDEX `fk_snake_producer_full_adress1_idx` (`full_adress_id` ASC) VISIBLE,
  CONSTRAINT `fk_snake_producer_full_adress1`
    FOREIGN KEY (`full_adress_id`)
    REFERENCES `Polnyi_DB`.`full_adress` (`id`)
    ON DELETE RESTRICT
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
  `snake_producer_id` INT NOT NULL,
  PRIMARY KEY (`id`)),
  INDEX `fk_snack_snake_producer1_idx` (`snake_producer_id` ASC) VISIBLE,
  CONSTRAINT `fk_snack_snake_producer1`
    FOREIGN KEY (`snake_producer_id`)
    REFERENCES `Polnyi_DB`.`snake_producer` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Polnyi_DB`.`snack_machine_has_snack`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Polnyi_DB`.`snack_machine_has_snack` (
  `snack_machine_id` INT NOT NULL,
  `snack_id` INT NOT NULL,
  `snack_amount` INT ZEROFILL UNSIGNED NULL,
  PRIMARY KEY (`snack_machine_id`, `snack_id`),
  INDEX `fk_snack_machine_has_snack_snack1_idx` (`snack_id` ASC) VISIBLE,
  INDEX `fk_snack_machine_has_snack_snack_machine1_idx` (`snack_machine_id` ASC) VISIBLE,
  CONSTRAINT `fk_snack_machine_has_snack_snack_machine1`
    FOREIGN KEY (`snack_machine_id`)
    REFERENCES `Polnyi_DB`.`snack_machine` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_snack_machine_has_snack_snack1`
    FOREIGN KEY (`snack_id`)
    REFERENCES `Polnyi_DB`.`snack` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Polnyi_DB`.`machine_service`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Polnyi_DB`.`machine_service` (
  `snack_machine_id` INT NOT NULL,
  `last_load` DATE NULL,
  `last_cash_gathering` DATE NULL,
  `gathered_cash` INT NULL,
  `last_coint_load` DATE NULL,
  `loaded_coins` INT NULL,
  PRIMARY KEY (`snack_machine_id`),
  CONSTRAINT `fk_machine_service_snack_machine1`
    FOREIGN KEY (`snack_machine_id`)
    REFERENCES `Polnyi_DB`.`snack_machine` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Polnyi_DB`.`daily_sales`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Polnyi_DB`.`daily_sales` (
  `snack_id` INT NOT NULL,
  `snack_machine_id` INT NOT NULL,
  `quantity` INT UNSIGNED ZEROFILL NULL,
  PRIMARY KEY (`snack_id`, `snack_machine_id`),
  INDEX `fk_snack_has_snack_machine_snack_machine1_idx` (`snack_machine_id` ASC) VISIBLE,
  CONSTRAINT `fk_snack_has_snack_machine_snack1`
    FOREIGN KEY (`snack_id`)
    REFERENCES `Polnyi_DB`.`snack` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_snack_has_snack_machine_snack_machine1`
    FOREIGN KEY (`snack_machine_id`)
    REFERENCES `Polnyi_DB`.`snack_machine` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Polnyi_DB`.`snack_load`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Polnyi_DB`.`snack_load` (
  `snack_machine_id` INT NOT NULL,
  `snack_id` INT NOT NULL,
  `loader_id` INT NOT NULL,
  `quantity` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`snack_machine_id`, `snack_id`, `loader_id`),
  INDEX `fk_snack_load_snack1_idx` (`snack_id` ASC) VISIBLE,
  INDEX `fk_snack_load_machine_service1_idx` (`snack_machine_id` ASC) VISIBLE,
  CONSTRAINT `fk_snack_load_loader1`
    FOREIGN KEY (`loader_id`)
    REFERENCES `Polnyi_DB`.`loader` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_snack_load_snack1`
    FOREIGN KEY (`snack_id`)
    REFERENCES `Polnyi_DB`.`snack` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_snack_load_machine_service1`
    FOREIGN KEY (`snack_machine_id`)
    REFERENCES `Polnyi_DB`.`machine_service` (`snack_machine_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
