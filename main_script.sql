CREATE SCHEMA IF NOT EXISTS `Polnyi_DB` DEFAULT CHARACTER SET utf8 ;
USE `Polnyi_DB` ;
 
DROP TABLE IF EXISTS `snack_load`;
DROP TABLE IF EXISTS `daily_sales`;
DROP TABLE IF EXISTS `snack_machine_has_snack`;
DROP TABLE IF EXISTS `snack`;
DROP TABLE IF EXISTS `snack_producer`;
DROP TABLE IF EXISTS `loader`;
DROP TABLE IF EXISTS `machine_service`;
DROP TABLE IF EXISTS `snack_machine`;
DROP TABLE IF EXISTS `producer_model`;
DROP TABLE IF EXISTS `machine_producer`;
DROP TABLE IF EXISTS `machine_model`;
DROP TABLE IF EXISTS `full_adress`;
DROP TABLE IF EXISTS `city`;
DROP TABLE IF EXISTS `country`;


CREATE TABLE IF NOT EXISTS `country` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `city` (
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


CREATE TABLE IF NOT EXISTS `full_adress` (
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


CREATE TABLE IF NOT EXISTS `machine_producer` (
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


CREATE TABLE IF NOT EXISTS `machine_model` (
  `model` VARCHAR(50) NOT NULL,
  `max_capacity` INT UNSIGNED NOT NULL,
  `electricity_consumption_wh` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`model`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `producer_model` (
  `machine_producer_id` INT NOT NULL,
  `machine_model` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`machine_producer_id`, `machine_model`),
  INDEX `fk_machine_producer_has_machine_model_machine_model1_idx` (`machine_model` ASC) VISIBLE,
  INDEX `fk_machine_producer_has_machine_model_machine_producer1_idx` (`machine_producer_id` ASC) VISIBLE,
  CONSTRAINT `fk_machine_producer_has_machine_model_machine_producer1`
    FOREIGN KEY (`machine_producer_id`)
    REFERENCES `Polnyi_DB`.`machine_producer` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_machine_producer_has_machine_model_machine_model1`
    FOREIGN KEY (`machine_model`)
    REFERENCES `Polnyi_DB`.`machine_model` (`model`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `snack_machine` (
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
    REFERENCES `Polnyi_DB`.`producer_model` (`machine_producer_id` , `machine_model`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `snack_producer` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NULL,
  `mobile_phone` CHAR(12) NULL,
  `full_adress_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  INDEX `fk_snack_producer_full_adress1_idx` (`full_adress_id` ASC) VISIBLE,
  CONSTRAINT `fk_snack_producer_full_adress1`
    FOREIGN KEY (`full_adress_id`)
    REFERENCES `Polnyi_DB`.`full_adress` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `snack` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `trademark` VARCHAR(45) NOT NULL,
  `snack_type` VARCHAR(45) NOT NULL,
  `price` INT NOT NULL,
  `snack_producer_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_snack_snack_producer1_idx` (`snack_producer_id` ASC) VISIBLE,
  CONSTRAINT `fk_snack_snack_producer1`
    FOREIGN KEY (`snack_producer_id`)
    REFERENCES `Polnyi_DB`.`snack_producer` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `loader` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `surname` VARCHAR(45) NOT NULL,
  `mobile_phone` CHAR(12) NULL,
  `company` VARCHAR(45) NULL,
  `full_adress_id` INT NULL,
  `email` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_loader_full_adress1_idx` (`full_adress_id` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  UNIQUE INDEX `mobile_phone_UNIQUE` (`mobile_phone` ASC) VISIBLE,
  CONSTRAINT `fk_loader_full_adress1`
    FOREIGN KEY (`full_adress_id`)
    REFERENCES `Polnyi_DB`.`full_adress` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `snack_machine_has_snack` (
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


CREATE TABLE IF NOT EXISTS `daily_sales` (
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


CREATE TABLE IF NOT EXISTS `machine_service` (
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


CREATE TABLE IF NOT EXISTS `snack_load` (
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

INSERT INTO `country` (`name`) VALUES ('USA');
INSERT INTO `country` (`name`) VALUES ('Netherlands');
INSERT INTO `country` (`name`) VALUES ('Canda');
INSERT INTO `country` (`name`) VALUES ('France');
INSERT INTO `country` (`name`) VALUES ('Japan');

INSERT INTO `city` (`country_id`, `name`, `region`) VALUES ('1', 'Peoria', 'Illinois');
INSERT INTO `city` (`country_id`, `name`, `region`) VALUES ('1', 'Las Vegas', 'Nevada');
INSERT INTO `city` (`country_id`, `name`, `region`) VALUES ('2', 'Hardenberg', 'Overijssel');
INSERT INTO `city` (`country_id`, `name`, `region`) VALUES ('1', 'Blountville', 'Tennesee');
INSERT INTO `city` (`country_id`, `name`, `region`) VALUES ('2', 'Berkel en Rodenrijs', 'South Holland');
INSERT INTO `city` (`country_id`, `name`, `region`) VALUES ('1', 'San Francisco', 'California');
INSERT INTO `city` (`country_id`, `name`, `region`) VALUES ('1', 'Akron', 'Ohio');
INSERT INTO `city` (`country_id`, `name`, `region`) VALUES ('1', 'Garden City', 'New York');
INSERT INTO `city` (`country_id`, `name`, `region`) VALUES ('1', 'Custer City', 'South Dakota');
INSERT INTO `city` (`country_id`, `name`, `region`) VALUES ('1', 'Southfield', 'Michigan');
INSERT INTO `city` (`country_id`, `name`, `region`) VALUES ('5', 'Tokio', 'Itabashi-ku');
INSERT INTO `city` (`country_id`, `name`, `region`) VALUES ('5', 'Kanagawa', 'Kohoku-ku');
INSERT INTO `city` (`country_id`, `name`, `region`) VALUES ('4', 'Fontaine', 'Rhone-Alpes');
INSERT INTO `city` (`country_id`, `name`, `region`) VALUES ('4', 'Le Lamentin', 'Martinique');
INSERT INTO `city` (`country_id`, `name`, `region`) VALUES ('3', 'Boucherville', 'Quebec');
INSERT INTO `city` (`country_id`, `name`, `region`) VALUES ('3', 'Estevan', 'Saskatchewan');

INSERT INTO `full_adress` (`city_id`, `street`, `number`) VALUES ('1', 'Garfield Road', '2387');
INSERT INTO `full_adress` (`city_id`, `street`, `number`) VALUES ('2', 'Benson Park Drive', '2751');
INSERT INTO `full_adress` (`city_id`, `street`, `number`) VALUES ('3', 'Berkenlaan', '128a');
INSERT INTO `full_adress` (`city_id`, `street`, `number`) VALUES ('4', 'Hershell Hollow Road', '4932');
INSERT INTO `full_adress` (`city_id`, `street`, `number`) VALUES ('5', 'Leeuwerik', '166b');
INSERT INTO `full_adress` (`city_id`, `street`, `number`) VALUES ('6', 'Meadow Lane', '2021');
INSERT INTO `full_adress` (`city_id`, `street`, `number`) VALUES ('7', 'Rivendell Drive', '1083c');
INSERT INTO `full_adress` (`city_id`, `street`, `number`) VALUES ('8', 'Heaven Street', '15');
INSERT INTO `full_adress` (`city_id`, `street`, `number`) VALUES ('9', 'Rockford Road', '2962');
INSERT INTO `full_adress` (`city_id`, `street`, `number`) VALUES ('10', 'Daylene Drive', '3382');
INSERT INTO `full_adress` (`city_id`, `street`, `number`) VALUES ('12', 'Yasudamachi', '211-1186');
INSERT INTO `full_adress` (`city_id`, `street`, `number`) VALUES ('11', 'Chiba-shi', '372-1066');
INSERT INTO `full_adress` (`city_id`, `street`, `number`) VALUES ('15', 'Cornwall Street', '1363');
INSERT INTO `full_adress` (`city_id`, `street`, `number`) VALUES ('13', 'rue Bonneterie', '86');
INSERT INTO `full_adress` (`city_id`, `street`, `number`) VALUES ('14', 'rue Michel Ange', '95');
INSERT INTO `full_adress` (`city_id`, `street`, `number`) VALUES ('16', '7th Ave', '954');
INSERT INTO `full_adress` (`city_id`, `street`, `number`) VALUES ('1', 'Smith Road', '239');
INSERT INTO `full_adress` (`city_id`, `street`, `number`) VALUES ('2', 'Boundary Street', '1132');
INSERT INTO `full_adress` (`city_id`, `street`, `number`) VALUES ('4', 'Watson Street', '228');
INSERT INTO `full_adress` (`city_id`, `street`, `number`) VALUES ('6', 'Pride Avenue', '555');
INSERT INTO `full_adress` (`city_id`, `street`, `number`) VALUES ('7', 'Crosswind Drive', '3819');
INSERT INTO `full_adress` (`city_id`, `street`, `number`) VALUES ('8', 'Rhode Island Avenue', '2098');
INSERT INTO `full_adress` (`city_id`, `street`, `number`) VALUES ('9', 'Stanley Avenue', '4026');
INSERT INTO `full_adress` (`city_id`, `street`, `number`) VALUES ('10', 'Margaret Street', '3380');
INSERT INTO `full_adress` (`city_id`, `street`, `number`) VALUES ('3', 'Noordenseweg', '76');
INSERT INTO `full_adress` (`city_id`, `street`, `number`) VALUES ('5', 'Slotvoogdstraat', '1113');


INSERT INTO `snack_producer` (`name`, `email`, `mobile_phone`, `full_adress_id`) VALUES ('Lacritia', '4lacritiaproduction@gmaill.com', '403-530-1082', '14');
INSERT INTO `snack_producer` (`name`, `email`, `mobile_phone`, `full_adress_id`) VALUES ('VMH Candies', 'vmh_candies@gmail.com', '250-715-7545', '15');
INSERT INTO `snack_producer` (`name`, `email`, `mobile_phone`, `full_adress_id`) VALUES ('Crips Chips', 'crisp_chips@gmail.com', '250-435-5081', '16');

INSERT INTO `snack` (`trademark`, `snack_type`, `price`, `snack_producer_id`) VALUES ('Reese’s Peanut Butter Cups', 'Chocolate Cookie', '500', '1');
INSERT INTO `snack` (`trademark`, `snack_type`, `price`, `snack_producer_id`) VALUES ('Milky Way', 'Chocolate Bar', '750', '2');
INSERT INTO `snack` (`trademark`, `snack_type`, `price`, `snack_producer_id`) VALUES ('Twix', 'Chocolate Bar', '400', '2');
INSERT INTO `snack` (`trademark`, `snack_type`, `price`, `snack_producer_id`) VALUES ('M&M', 'Peanuts', '900', '1');
INSERT INTO `snack` (`trademark`, `snack_type`, `price`, `snack_producer_id`) VALUES ('Bugles', 'Chips', '1500', '3');
INSERT INTO `snack` (`trademark`, `snack_type`, `price`, `snack_producer_id`) VALUES ('Welch’s Fruit Snacks', 'Fruits', '1700', '2');
INSERT INTO `snack` (`trademark`, `snack_type`, `price`, `snack_producer_id`) VALUES ('Funyuns', 'Chips', '1100', '3');
INSERT INTO `snack` (`trademark`, `snack_type`, `price`, `snack_producer_id`) VALUES ('Take 5', 'Chocolate Bar', '800', '1');
INSERT INTO `snack` (`trademark`, `snack_type`, `price`, `snack_producer_id`) VALUES ('Snickers', 'Chocolate Bar', '1000', '1');
INSERT INTO `snack` (`trademark`, `snack_type`, `price`, `snack_producer_id`) VALUES ('Pringles BBQ', 'Chips', '2000', '3');

INSERT INTO `loader` (`name`, `surname`, `mobile_phone`, `company`, `full_adress_id`, `email`) VALUES ('Mykhailo', 'Polnyi', '495-722-1901', 'Patient Loader Inc.', '17', 'mykpol@i.ua');
INSERT INTO `loader` (`name`, `surname`, `company`, `full_adress_id`, `email`) VALUES ('Mykola', 'Stepanuk', 'Reload Inc.', '18', 'myk_step@gmail.com');
INSERT INTO `loader` (`name`, `surname`, `mobile_phone`, `company`, `full_adress_id`, `email`) VALUES ('Andrew', 'Davidson', '551-123-1987', 'Patient Loader Inc.', '19', 'andryi_davidson@gmail.com');
INSERT INTO `loader` (`name`, `surname`, `mobile_phone`, `full_adress_id`, `email`) VALUES ('Peter', 'Menson', '112-345-5678', '20', 'pet_menson@gmail.com');
INSERT INTO `loader` (`name`, `surname`, `mobile_phone`, `company`, `full_adress_id`, `email`) VALUES ('Kayleigh', 'Peterson', '998-876-3543', 'Reload Inc.', '21', 'kali_peter@gmail.com');
INSERT INTO `loader` (`name`, `surname`, `company`, `full_adress_id`, `email`) VALUES ('Daisy', 'Smith', 'Florida Loaders Association', '22', 'dazy_forge@gmail.com');
INSERT INTO `loader` (`name`, `surname`, `mobile_phone`, `company`, `full_adress_id`, `email`) VALUES ('Abraham', 'Morrison', '192-837-4865', 'Patient Loader Inc.', '24', 'abraham_morisson@gmail.com');
INSERT INTO `loader` (`name`, `surname`, `mobile_phone`, `full_adress_id`, `email`) VALUES ('Hussain', 'Jones', '666-748-8952', '23', 'jones_hussain@gmai.com');
INSERT INTO `loader` (`name`, `surname`, `mobile_phone`, `company`, `full_adress_id`, `email`) VALUES ('Shaun', 'Wallace', '559-782-0310', 'Reload Inc.', '25', 'shaun_wallace@gmai.com');
INSERT INTO `loader` (`name`, `surname`, `mobile_phone`, `full_adress_id`, `email`) VALUES ('John', 'Bourne', '995-643-1871', '26', 'john_bourne@gmai.com');

INSERT INTO `machine_model` (`model`, `max_capacity`, `electricity_consumption_wh`) VALUES ('cp-101yu-54-d', '100', '20');
INSERT INTO `machine_model` (`model`, `max_capacity`, `electricity_consumption_wh`) VALUES ('cp-105yu-14-c', '120', '25');
INSERT INTO `machine_model` (`model`, `max_capacity`, `electricity_consumption_wh`) VALUES ('kd-11-abi-8-k', '40', '10');
INSERT INTO `machine_model` (`model`, `max_capacity`, `electricity_consumption_wh`) VALUES ('ou-924-iot', '80', '15');
INSERT INTO `machine_model` (`model`, `max_capacity`, `electricity_consumption_wh`) VALUES ('nu-59-ipz-lp', '90', '15');

INSERT INTO `machine_producer` (`name`, `full_adress_id`, `email`, `mobile_phone`) VALUES ('Snackload Inc.', '11', 'snackloadinc@gmail.com', '067-159-0382');
INSERT INTO `machine_producer` (`name`, `full_adress_id`, `email`, `mobile_phone`) VALUES ('Ruhio Tech', '12', 'ruhio_tech@gmail.com', '061-237-6668');
INSERT INTO `machine_producer` (`name`, `full_adress_id`, `email`, `mobile_phone`) VALUES ('Gelderland Production', '16', 'gelderland_production@gmai.com', '083-645-7512');

INSERT INTO `producer_model` (`machine_producer_id`, `machine_model`) VALUES ('1', 'cp-101yu-54-d');
INSERT INTO `producer_model` (`machine_producer_id`, `machine_model`) VALUES ('2', 'kd-11-abi-8-k');
INSERT INTO `producer_model` (`machine_producer_id`, `machine_model`) VALUES ('1', 'cp-105yu-14-c');
INSERT INTO `producer_model` (`machine_producer_id`, `machine_model`) VALUES ('3', 'nu-59-ipz-lp');
INSERT INTO `producer_model` (`machine_producer_id`, `machine_model`) VALUES ('2', 'nu-59-ipz-lp');
INSERT INTO `producer_model` (`machine_producer_id`, `machine_model`) VALUES ('3', 'ou-924-iot');
INSERT INTO `producer_model` (`machine_producer_id`, `machine_model`) VALUES ('1', 'kd-11-abi-8-k');
INSERT INTO `producer_model` (`machine_producer_id`, `machine_model`) VALUES ('1', 'nu-59-ipz-lp');

INSERT INTO `snack_machine` (`full_adress_id`, `machine_producer_id`, `machine_model`) VALUES ('8', '3', 'nu-59-ipz-lp');
INSERT INTO `snack_machine` (`full_adress_id`, `machine_producer_id`, `machine_model`) VALUES ('4', '3', 'nu-59-ipz-lp');
INSERT INTO `snack_machine` (`full_adress_id`, `machine_producer_id`, `machine_model`) VALUES ('9', '2', 'kd-11-abi-8-k');
INSERT INTO `snack_machine` (`full_adress_id`, `machine_producer_id`, `machine_model`) VALUES ('5', '2', 'nu-59-ipz-lp');
INSERT INTO `snack_machine` (`full_adress_id`, `machine_producer_id`, `machine_model`) VALUES ('6', '1', 'cp-101yu-54-d');
INSERT INTO `snack_machine` (`full_adress_id`, `machine_producer_id`, `machine_model`) VALUES ('10', '1', 'kd-11-abi-8-k');
INSERT INTO `snack_machine` (`full_adress_id`, `machine_producer_id`, `machine_model`) VALUES ('7', '3', 'ou-924-iot');
INSERT INTO `snack_machine` (`full_adress_id`, `machine_producer_id`, `machine_model`) VALUES ('1', '2', 'nu-59-ipz-lp');
INSERT INTO `snack_machine` (`full_adress_id`, `machine_producer_id`, `machine_model`) VALUES ('3', '2', 'kd-11-abi-8-k');
INSERT INTO `snack_machine` (`full_adress_id`, `machine_producer_id`, `machine_model`) VALUES ('2', '1', 'cp-105yu-14-c');

INSERT INTO `machine_service` (`snack_machine_id`, `last_load`, `last_cash_gathering`, `gathered_cash`, `last_coint_load`, `loaded_coins`) VALUES ('1', '2021-09-18', '2021-09-25', '30000', '2021-09-25', '10000');
INSERT INTO `machine_service` (`snack_machine_id`, `last_load`, `last_cash_gathering`, `gathered_cash`, `last_coint_load`, `loaded_coins`) VALUES ('2', '2021-09-10', '2021-09-15', '10000', '2021-08-15', '8000');
INSERT INTO `machine_service` (`snack_machine_id`, `last_load`, `last_cash_gathering`, `gathered_cash`, `last_coint_load`, `loaded_coins`) VALUES ('3', '2021-09-20', '2021-09-20', '20000', '2021-09-21', '7000');
INSERT INTO `machine_service` (`snack_machine_id`, `last_load`, `last_cash_gathering`, `gathered_cash`, `last_coint_load`, `loaded_coins`) VALUES ('4', '2021-09-15', '2021-09-20', '15000', '2021-09-20', '5000');
INSERT INTO `machine_service` (`snack_machine_id`, `last_load`, `last_cash_gathering`, `gathered_cash`, `last_coint_load`, `loaded_coins`) VALUES ('8', '2021-07-15', '2021-08-10', '23500', '2021-06-10', '5000');
INSERT INTO `machine_service` (`snack_machine_id`, `last_load`, `last_cash_gathering`, `gathered_cash`, `last_coint_load`, `loaded_coins`) VALUES ('6', '2021-09-17', '2021-09-25', '15070', '2021-09-20', '5000');
INSERT INTO `machine_service` (`snack_machine_id`, `last_load`, `last_cash_gathering`, `gathered_cash`, `last_coint_load`, `loaded_coins`) VALUES ('7', '2021-09-10', '2021-09-15', '5000', '2021-09-20', '1000');
INSERT INTO `machine_service` (`snack_machine_id`, `last_load`, `last_cash_gathering`, `gathered_cash`, `last_coint_load`, `loaded_coins`) VALUES ('10', '2021-09-23', '2021-09-25', '60000', '2021-09-26', '15000');
INSERT INTO `machine_service` (`snack_machine_id`, `last_load`, `last_cash_gathering`, `gathered_cash`, `last_coint_load`, `loaded_coins`) VALUES ('5', '2021-09-29', '2021-09-20', '40000', '2021-09-29', '10000');
INSERT INTO `machine_service` (`snack_machine_id`, `last_load`, `last_coint_load`, `loaded_coins`) VALUES ('9','2021-09-29', '2021-09-28', '5000');

INSERT INTO `snack_machine_has_snack` (`snack_machine_id`, `snack_id`, `snack_amount`) VALUES ('1', '2', '5');
INSERT INTO `snack_machine_has_snack` (`snack_machine_id`, `snack_id`, `snack_amount`) VALUES ('1', '1', '10');
INSERT INTO `snack_machine_has_snack` (`snack_machine_id`, `snack_id`, `snack_amount`) VALUES ('1', '8', '18');
INSERT INTO `snack_machine_has_snack` (`snack_machine_id`, `snack_id`, `snack_amount`) VALUES ('4', '9', '6');
INSERT INTO `snack_machine_has_snack` (`snack_machine_id`, `snack_id`, `snack_amount`) VALUES ('5', '2', '2');
INSERT INTO `snack_machine_has_snack` (`snack_machine_id`, `snack_id`, `snack_amount`) VALUES ('5', '3', '8');
INSERT INTO `snack_machine_has_snack` (`snack_machine_id`, `snack_id`, `snack_amount`) VALUES ('6', '4', '13');
INSERT INTO `snack_machine_has_snack` (`snack_machine_id`, `snack_id`, `snack_amount`) VALUES ('7', '1', '17');
INSERT INTO `snack_machine_has_snack` (`snack_machine_id`, `snack_id`, `snack_amount`) VALUES ('10', '6', '11');
INSERT INTO `snack_machine_has_snack` (`snack_machine_id`, `snack_id`, `snack_amount`) VALUES ('10', '7', '6');
INSERT INTO `snack_machine_has_snack` (`snack_machine_id`, `snack_id`, `snack_amount`) VALUES ('2', '7', '14');
INSERT INTO `snack_machine_has_snack` (`snack_machine_id`, `snack_id`, `snack_amount`) VALUES ('3', '2', '7');
INSERT INTO `snack_machine_has_snack` (`snack_machine_id`, `snack_id`, `snack_amount`) VALUES ('3', '8', '9');
INSERT INTO `snack_machine_has_snack` (`snack_machine_id`, `snack_id`, `snack_amount`) VALUES ('8', '10', '13');
INSERT INTO `snack_machine_has_snack` (`snack_machine_id`, `snack_id`, `snack_amount`) VALUES ('8', '3', '19');
INSERT INTO `snack_machine_has_snack` (`snack_machine_id`, `snack_id`, `snack_amount`) VALUES ('8', '4', '6');
INSERT INTO `snack_machine_has_snack` (`snack_machine_id`, `snack_id`, `snack_amount`) VALUES ('9', '9', '20');
INSERT INTO `snack_machine_has_snack` (`snack_machine_id`, `snack_id`, `snack_amount`) VALUES ('9', '8', '8');

INSERT INTO `daily_sales` (`snack_id`, `snack_machine_id`, `quantity`) VALUES ('6', '10', '3');
INSERT INTO `daily_sales` (`snack_id`, `snack_machine_id`, `quantity`) VALUES ('4', '6', '2');
INSERT INTO `daily_sales` (`snack_id`, `snack_machine_id`, `quantity`) VALUES ('3', '5', '0');
INSERT INTO `daily_sales` (`snack_id`, `snack_machine_id`, `quantity`) VALUES ('1', '7', '1');
INSERT INTO `daily_sales` (`snack_id`, `snack_machine_id`) VALUES ('2', '5');
INSERT INTO `daily_sales` (`snack_id`, `snack_machine_id`, `quantity`) VALUES ('9', '4', '6');
INSERT INTO `daily_sales` (`snack_id`, `snack_machine_id`, `quantity`) VALUES ('8', '3', '7');
INSERT INTO `daily_sales` (`snack_id`, `snack_machine_id`, `quantity`) VALUES ('8', '9', '3');
INSERT INTO `daily_sales` (`snack_id`, `snack_machine_id`, `quantity`) VALUES ('4', '8', '5');
INSERT INTO `daily_sales` (`snack_id`, `snack_machine_id`, `quantity`) VALUES ('7', '10', '11');
INSERT INTO `daily_sales` (`snack_id`, `snack_machine_id`, `quantity`) VALUES ('9', '9', '4');
INSERT INTO `daily_sales` (`snack_id`, `snack_machine_id`, `quantity`) VALUES ('10', '8', '8');

INSERT INTO `snack_load` (`snack_machine_id`, `snack_id`, `loader_id`, `quantity`) VALUES ('3', '8', '8', '5');
INSERT INTO `snack_load` (`snack_machine_id`, `snack_id`, `loader_id`, `quantity`) VALUES ('10', '7', '2', '10');
INSERT INTO `snack_load` (`snack_machine_id`, `snack_id`, `loader_id`, `quantity`) VALUES ('4', '9', '10', '10');
INSERT INTO `snack_load` (`snack_machine_id`, `snack_id`, `loader_id`, `quantity`) VALUES ('10', '6', '2', '15');
INSERT INTO `snack_load` (`snack_machine_id`, `snack_id`, `loader_id`, `quantity`) VALUES ('5', '2', '4', '5');
INSERT INTO `snack_load` (`snack_machine_id`, `snack_id`, `loader_id`, `quantity`) VALUES ('9', '9', '9', '8');
INSERT INTO `snack_load` (`snack_machine_id`, `snack_id`, `loader_id`, `quantity`) VALUES ('5', '3', '4', '10');
INSERT INTO `snack_load` (`snack_machine_id`, `snack_id`, `loader_id`, `quantity`) VALUES ('9', '8', '9', '20');
INSERT INTO `snack_load` (`snack_machine_id`, `snack_id`, `loader_id`, `quantity`) VALUES ('6', '4', '7', '16');
INSERT INTO `snack_load` (`snack_machine_id`, `snack_id`, `loader_id`, `quantity`) VALUES ('8', '10', '1', '13');
INSERT INTO `snack_load` (`snack_machine_id`, `snack_id`, `loader_id`, `quantity`) VALUES ('7', '1', '5', '18');
INSERT INTO `snack_load` (`snack_machine_id`, `snack_id`, `loader_id`, `quantity`) VALUES ('8', '4', '1', '16');
INSERT INTO `snack_load` (`snack_machine_id`, `snack_id`, `loader_id`, `quantity`) VALUES ('8', '3', '1', '17');
INSERT INTO `snack_load` (`snack_machine_id`, `snack_id`, `loader_id`, `quantity`) VALUES ('1', '1', '6', '10');
INSERT INTO `snack_load` (`snack_machine_id`, `snack_id`, `loader_id`, `quantity`) VALUES ('2', '7', '3', '15');
