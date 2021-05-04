-- This script is divided in 4 main parts:
-- 1. The Script to recreate the DB
-- 2. All the inserts needed.
-- 3. Triggers
-- 4. Views 

-- 1. SCRIPT FOR DB

-- MySQL Workbench Forward Engineering
drop database if exists partc;

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema partc
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema partc
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `partc` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `partc` ;

-- -----------------------------------------------------
-- Table `partc`.`country`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `partc`.`country` (
  `idCountry` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Country_Name` VARCHAR(45) NULL DEFAULT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `partc`.`city`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `partc`.`city` (
  `idCity` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `City_Name` VARCHAR(45) NULL DEFAULT NULL,
  `Country_idCountry` INT NOT NULL,
  INDEX `fk_City_Country1_idx` (`Country_idCountry` ASC) VISIBLE,
  CONSTRAINT `fk_City_Country1`
    FOREIGN KEY (`Country_idCountry`)
    REFERENCES `partc`.`country` (`idCountry`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `partc`.`address`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `partc`.`address` (
  `idAddress` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Street_Name` VARCHAR(45) NULL DEFAULT NULL,
  `Street_Number` VARCHAR(45) NULL DEFAULT NULL,
  `Floor` VARCHAR(45) NULL DEFAULT NULL,
  `ZIP_CODE` VARCHAR(8) NULL,
  `City_idCity` INT NOT NULL,
  INDEX `fk_Address_City1_idx` (`City_idCity` ASC) VISIBLE,
  CONSTRAINT `fk_Address_City1`
    FOREIGN KEY (`City_idCity`)
    REFERENCES `partc`.`city` (`idCity`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `partc`.`category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `partc`.`category` (
  `idCategory` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Category_Name` VARCHAR(45) NULL DEFAULT NULL,
  `Category_Description` VARCHAR(45) NULL DEFAULT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `partc`.`client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `partc`.`client` (
  `idClient` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Client_Name` VARCHAR(45) NULL DEFAULT NULL,
  `Client_Age` INT NULL DEFAULT NULL,
  `Client_Email` VARCHAR(45) NULL DEFAULT NULL,
  `Client_Phone_Number` VARCHAR(45) NULL DEFAULT NULL,
  `Spending_Score` VARCHAR(45) NULL DEFAULT NULL,
  `Spending_Category` VARCHAR(45) NULL DEFAULT NULL,
  `Address_idAddress` INT NULL DEFAULT NULL,
  INDEX `fk_Client_Address1_idx` (`Address_idAddress` ASC) VISIBLE,
  CONSTRAINT `fk_Client_Address1`
    FOREIGN KEY (`Address_idAddress`)
    REFERENCES `partc`.`address` (`idAddress`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `partc`.`store`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `partc`.`store` (
  `idStore` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Address_idAddress` INT NOT NULL,
  INDEX `fk_Store_Address1_idx` (`Address_idAddress` ASC) VISIBLE,
  CONSTRAINT `fk_Store_Address1`
    FOREIGN KEY (`Address_idAddress`)
    REFERENCES `partc`.`address` (`idAddress`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `partc`.`employee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `partc`.`employee` (
  `idEmployee` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Employee_Name` VARCHAR(45) NULL DEFAULT NULL,
  `Occupation` VARCHAR(45) NULL DEFAULT NULL,
  `Income` INT NULL DEFAULT NULL,
  `Store_idStore` INT NOT NULL,
  INDEX `fk_Employee_Store1_idx` (`Store_idStore` ASC) VISIBLE,
  CONSTRAINT `fk_Employee_Store1`
    FOREIGN KEY (`Store_idStore`)
    REFERENCES `partc`.`store` (`idStore`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `partc`.`payment_method`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `partc`.`payment_method` (
  `idPayment_Method` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Method_Name` VARCHAR(45) NULL DEFAULT NULL,
  `Account_Number` VARCHAR(45) NULL DEFAULT NULL,
  `Expiration_Date` DATETIME NULL DEFAULT NULL,
  `CVV2` VARCHAR(45) NULL DEFAULT NULL,
  `Card_Name` VARCHAR(45) NULL DEFAULT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `partc`.`invoice`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `partc`.`invoice` (
  `idInvoice` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Issue_Date` DATETIME NULL DEFAULT NULL,
  `Payment_Limit_Date` DATETIME NULL DEFAULT NULL,
  `Total_Price` FLOAT NULL DEFAULT 0,
  `Payment_Status` VARCHAR(45) NULL DEFAULT NULL,
  `Delivery_Status` VARCHAR(45) NULL DEFAULT NULL,
  `Client_idClient` INT NOT NULL,
  `Payment_Method_idPayment_Method` INT NOT NULL,
  INDEX `fk_Invoice_Client_idx` (`Client_idClient` ASC) VISIBLE,
  INDEX `fk_Invoice_Payment_Method1_idx` (`Payment_Method_idPayment_Method` ASC) VISIBLE,
  CONSTRAINT `fk_Invoice_Client`
    FOREIGN KEY (`Client_idClient`)
    REFERENCES `partc`.`client` (`idClient`),
  CONSTRAINT `fk_Invoice_Payment_Method1`
    FOREIGN KEY (`Payment_Method_idPayment_Method`)
    REFERENCES `partc`.`payment_method` (`idPayment_Method`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `partc`.`products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `partc`.`products` (
  `idProducts` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Product_Name` VARCHAR(45) NULL DEFAULT NULL,
  `Price` FLOAT NULL DEFAULT NULL,
  `Stock` INT NULL,
  `Category_idCategory` INT NOT NULL,
  INDEX `fk_Products_Category1_idx` (`Category_idCategory` ASC) VISIBLE,
  CONSTRAINT `fk_Products_Category1`
    FOREIGN KEY (`Category_idCategory`)
    REFERENCES `partc`.`category` (`idCategory`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `partc`.`items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `partc`.`items` (
  `Purchase_Quantity` INT NULL DEFAULT NULL,
  `Products_idProducts` INT NOT NULL,
  `Invoice_idInvoice` INT NOT NULL,
  `Ratings` INT NULL DEFAULT NULL,
  PRIMARY KEY (`Products_idProducts`, `Invoice_idInvoice`),
  INDEX `fk_Items_Products1_idx` (`Products_idProducts` ASC) VISIBLE,
  INDEX `fk_Items_Invoice1_idx` (`Invoice_idInvoice` ASC) VISIBLE,
  CONSTRAINT `fk_Items_Invoice1`
    FOREIGN KEY (`Invoice_idInvoice`)
    REFERENCES `partc`.`invoice` (`idInvoice`),
  CONSTRAINT `fk_Items_Products1`
    FOREIGN KEY (`Products_idProducts`)
    REFERENCES `partc`.`products` (`idProducts`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `partc`.`log`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `partc`.`log` (
  `idLog` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Log_Date` DATETIME NULL DEFAULT NULL,
  `usr` VARCHAR(45) NULL DEFAULT NULL,
  `EV` VARCHAR(45) NULL DEFAULT NULL,
  `MSG` VARCHAR(45) NULL DEFAULT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `partc`.`promotions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `partc`.`promotions` (
  `idPromotions` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Promotion_Name` VARCHAR(45) NULL DEFAULT NULL,
  `Promotion_Start_Date` DATETIME NULL DEFAULT NULL,
  `Promotion_End_Date` DATETIME NULL DEFAULT NULL,
  `Promotion_Discount` FLOAT NULL DEFAULT NULL,
  `Products_idProducts` INT NOT NULL,
  INDEX `fk_Promotions_Products1_idx` (`Products_idProducts` ASC) VISIBLE,
  CONSTRAINT `fk_Promotions_Products1`
    FOREIGN KEY (`Products_idProducts`)
    REFERENCES `partc`.`products` (`idProducts`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


-- 2. DATA INSERTS


use partc;
SET GLOBAL sql_mode='';

insert into `country` (`Country_Name`) values
('Portugal'),
('Denmark'),
('Czech Republic'),
('Lithuania');

insert into `city` (`City_Name`,`Country_idCountry`) values
('Lisboa',1),
('Porto',1),
('Braga',1),
('Alcobaça',1),
('Santarém',1),
('Seixal',1),
('Queluz',1),
('Amadora',1),
('Sobral de Monte Agraço',1),
('Copenhagen',2),
('Prague',3),
('Vilnius',4);

insert into `address` (`Street_Name`,`Street_Number`,`Floor`,`ZIP_CODE`,`City_idCity`) values
('Praceta Fransisco Stromp',29,11,2700-000,1),
('Praceta Rosa Mota',6,4,2610-030,9),
('Rua Salgueiro Maia',99,3,2705-532,6),
('Rua Fernando Pessoa',87,4,2605-001,5),
('Avenida Amália Rodrigues',71,3,2710-394,8),
('Largo Amália Rodrigues',91,10,2590-001,8),
('Praceta Marisa Nunes',98,1,2590-202,8),
('Praceta Sophia de Mello Breyner',3,5,2590-512,6),
('Largo Fransisco Stromp',96,5,2590-009,8),
('Praceta Joaquim Agostinho',29,0,2590-058,9),
('Avenida Amália Rodrigues',60,8,4000-380,8),
('Rua Cristiano Ronaldo',49,1,4000-378,9),
('Praceta Sophia de Mello Breyner',74,5,4000-373,4),
('Largo Salgueiro Maia',92,0,4700-329,5),
('Largo Marisa Nunes',10,9,4700-340,5),
('Praceta Rosa Mota',91,3,6699-019,8),
('Avenida Rosa Mota',16,3,5555-555,6),
('Avenida José Saramago',38,10,0909-090,8),
('Avenida Amália Rodrigues',6,7,7777-77, 7),
('Largo Simone de Oliveira',89,3,4700-324,3),
('Praceta Marisa Nunes',81,0,4750-306,7),
('Largo Cristiano Ronaldo',8,7,4750-302,4),
('Praceta Amália Rodrigues',42,7,4750-000 ,8),
('Largo Fransisco Stromp',32,0,4750-000 ,5),
('Avenida Joaquim Agostinho',80,11,4750-296,1),
('Praceta José Saramago',19,5,4750-100,2),
('Praceta Sophia de Mello Breyner',62,6,3000-001,5),
('Horhusvej',7,2,2300,7),
('Michalská',89,4,81103,11),
('Pamėnkalnio',74,1,01114 ,12);


insert into `payment_method` (`Method_Name`, `Account_Number`, `Expiration_Date`, `CVV2`, `Card_Name`) values 
('Visa', 265116454067, '2023-06-25 04:41:04', 314, 'Golden Key'), 
('MasterCard', 527268500997, '2021-12-17 20:14:49', 926, 'Silver'),
('Paypal', 690840516873, '2023-12-01 19:46:57', 429, 'Golden Key'),
('MasterCard', 204068213946, '2021-09-06 16:07:17', 943, 'Golden Key'),
('MasterCard', 682204013946, '2021-09-06 16:07:17', 943, 'Golden Key'),
('Visa', 130556941392, '2022-11-23 22:17:38', 555, 'Premium'),
('Visa', 526850720997, '2021-12-17 20:14:49', 866, 'Student Card'),
('Visa', 850099752726, '2021-12-17 20:14:49', 180, 'Silver'),
('Visa', 268500527997, '2021-12-17 20:14:49', 435, 'Student Card'),
('MasterCard', 726850052997, '2021-12-17 20:14:49', 225, 'Golden Key');

insert into `category` (`Category_Name`, `Category_Description`) values 
('Computers', 'Computers'),
('Components', 'Components'),
('Storage', 'Memory Cards, External Drives'),
('Accessories and Peripherals', 'Accessories and Peripherals'),
('Insurance', 'Insurance for Purchasing Computers');

insert into `products` (`Product_Name`, `Price`, `Stock`, `Category_idCategory`) values 
('GTX 1080 ti', 24.90, 250,2),
('AMD Rizen 7', 19.99,220,2),
('16GB Ram DDR 4', 19.99,80,2),
('Type C Cable', 5.99,20,3),
('Apple Charger', 99.99,20,3), 
('Micro USB', 4.99,100,3), 
('HP 14-inch HD Touchscreen Premium Laptop PC', 514.99,500,1), 
('Acer Aspire 5 A515-55-56VK, 15.6"', 599.99,400,1),
('Toshiba Satellite Radius P55W 2-in-1 15.6" ', 999.99,800,1),
('Wireless Portable Mobile Mouse Optical Mice', 12.99,100,4) ,
('Redragon Wired Gaming Keyboard and Mouse', 49.99,100,4) ,
('Acer SB220Q bi 21.5 Inches Full HD', 89.99,100,4) ,
('Blue Light Blocking Glasses', 8.99,100,4) ,
('Seagate Portable 2TB External Hard Drive', 62.99,100,2) ,
('Seagate BarraCuda 2TB Internal Hard Drive', 59.99,100,2) ,
('Intel Core i7-9700K Desktop Processor', 269.99,100,2) ,
('Acer Aspire TC-885-UA92 Desktop', 599.99,100,1),
('Western Digital 500GB WD Blue 3D NAND', 53.99,100,2),
('Western Digital 1TB WD Blue 3D NAND',99.99,100,2),
('MacBook Insurance Silver', 59.99,1000,1),
('MacBook Insurance Gold', 89.99,1000,1),
('Laptop Insurance Silver', 69.99,1000,1),
('Laptop Insurance Gold', 99.99,1000,1),
('Microsoft Surface Insurance Silver', 49.99,1000,1),
('Microsoft Surface Insurance Gold', 79.99,1000,1);


insert into `promotions` (`Promotion_Name`, `Promotion_Start_Date`, `Promotion_End_Date`, `Promotion_Discount`,`Products_idProducts`) values 
('Mega Bonanza','2021-01-16 10:56:51', '2021-04-15 08:00:01', 71,1),
('White Monday', '2020-12-28 22:12:15', '2021-05-27 07:42:14', 29,2),
('Black Friday', '2020-08-15 22:40:39', '2020-07-30 03:11:39', 35,3),
('Drop Them Prices', '2020-06-09 19:50:13', '2021-02-23 00:43:46', 99,4),
('Anniversary Promotion', '2020-08-23 14:20:42', '2020-11-29 18:03:30', 17,5),
('New Year New Ram', '2021-01-13 02:29:16', '2021-06-29 02:29:28', 46,7),
('Everything Must Go', '2020-11-09 22:33:07', '2021-01-19 12:23:13', 71,8);

insert into  `store` ( `Address_idAddress`) values 
(1), 
(1), 
(2);


INSERT INTO `employee` (`Employee_Name`, `Occupation`, `Income`, `Store_idStore`) VALUES 
('José', 'Salesman', 5000, 1),
('Manuel', 'Builder', 3000, 1),
('Maria', 'Accountant', 6000, 1),
('Haníbal', 'Janitor', 1000, 1),
('Manuela', 'IT', 2000, 1);


insert into `client` (`Client_Name`,`Client_Age`,`Client_Email`,`Client_Phone_Number`,`Spending_Score`,`Address_idAddress`) values
('Jorge Farinha',54,'jfarinha54@gmail.com',914635369,90,1),
('Mariana Rocha',55,'MRocha@yahoo.com',973323901,16,2),
('Luís Nunes',56,'LNunes@hotmail.com',973281780,32,3),
('Marta Palhares',37,'MPalhares@hotmail.com',928224321,30,4),
('Ema Markunas',41,'EMarkunas@hotmail.com',930207265,12,30),
('Bill Nunes',49,'BNunes@gmail.com',933480077,1,6),
('Gustavo Lima',43,'GLima@yahoo.com',987033747,12,7),
('Ema Santos',63,'ESantos@yahoo.com',949704544,26,8),
('Marta Saraiva',38,'MSaraiva@gmail.com',930115386,26,9),
('Miguel Félix',42,'MFélix@yahoo.com',947480567,36,10),
('Elizabeth Rocha',27,'ERocha@yahoo.com',939035441,47,11),
('Luís Pereira',59,'LPereira@yahoo.com',940596348,20,12),
('Ema Nunes',54,'ENunes@hotmail.com',914216124,27,13),
('Bill Sorensen',35,'BSorensen@yahoo.com',912060743,86,28),
('João Silva',26,'JSilva@gmail.com',920104413,56,15),
('Marta Félix',46,'MFélix@yahoo.com',984564780,68,16),
('Maria Nunes',23,'MNunes@hotmail.com',915994957,95,17),
('Mariana Santos',29,'MSantos@hotmail.com',945432414,16,18),
('Luís Pereira',44,'LPereira@gmail.com',940801949,15,19),
('Ricardo Santos',31,'RSantos@yahoo.com',904066417,51,20),
('Inês Silva',38,'ISilva@hotmail.com',942332088,18,21),
('Inês Pereira',36,'IPereira@hotmail.com',944674356,33,22),
('Catarina Palhares',37,'CPalhares@gmail.com',998199277,70,23),
('Louise Privratsky',55,'LPrivratsky@hotmail.com',936139348,63,29),
('Luís Santos',43,'LSantos@hotmail.com',901655948,44,25),
('Inês Nunes',26,'INunes@hotmail.com',908688285,97,26),
('João Saraiva',64,'JSaraiva@yahoo.com',992055897,91,27),
('Mariana Félix',19,'MFélix@yahoo.com',971522878,54,14),
('Diogo Lima',38,'DLima@hotmail.com',953971530,99,24),
('Mariana Santos',40,'MSantos@yahoo.com',930726816,35,5);

insert into  `invoice`(`Issue_Date`, `Payment_Limit_Date`, `Payment_Status`, `Delivery_Status`, `Client_idClient`, `Payment_Method_idPayment_Method`) values 
('2019-11-20 08:47:50', '2019-12-13 06:11:28', "Paid", "Delivered", 1, 1),
('2020-09-24 18:27:39', '2020-09-25 18:40:12', "Paid", "On the way", 9, 4),
('2020-07-24 04:58:26', '2020-08-07 05:40:12',"Not paid", "Not Issued", 6, 2),
('2018-12-04 04:34:31', '2018-12-09 22:15:23',  "Not paid", "Not issued", 9, 3),
('2020-04-20 22:59:20', '2020-07-01 04:10:18', "Paid", "Not Issued", 2, 2),
('2019-10-26 02:04:12', '2020-09-19 16:51:21', "Paid", 'Not Issued', 1, 1),
('2017-12-03 14:17:19', '2017-12-13 12:54:46', "Paid", 'Not Issued', 6, 3),
('2019-05-01 14:51:41', '2019-05-11 02:18:29',  "Not paid", 'Delivered', 28, 4),
('2018-04-23 21:12:02', '2018-05-10 14:03:15',  "Not paid", 'Not Issued', 26, 3),
('2018-01-17 19:22:19', '2018-01-27 00:50:25',  "Not paid", 'Delivered', 5, 3),
('2020-04-11 09:13:29', '2020-04-11 15:52:09', "Paid", 'Delivered', 24, 2),
('2017-10-09 08:41:38', '2017-10-06 14:56:56',  "Paid", 'On the way', 14, 1),
('2017-06-14 13:37:37', '2017-06-24 21:02:33',  "Paid", 'Not Issued', 25, 1),
('2018-11-27 03:43:43', '2018-12-20 05:28:08', "Paid", 'Delivered', 14, 2),
('2018-07-30 08:01:57', '2018-09-28 10:48:17', "Not paid", 'Delivered', 25, 3),
('2019-06-19 01:07:31', '2019-06-17 20:27:13',  "Paid", 'Not Issued', 1, 4),
('2020-08-19 16:27:55', '2020-08-18 21:21:19',  "Paid", 'Not Issued', 25, 2),
('2019-10-10 12:28:34', '2019-12-07 09:12:44',  "Paid", 'On the way', 26, 3),
('2018-04-01 14:57:06', '2018-11-06 06:54:02', "Not paid", 'Delivered', 13, 2),
('2019-09-22 05:30:52', '2020-07-03 22:42:10', "Paid", 'Not Issued', 28, 2),
('2020-12-05 04:59:48', '2020-12-24 14:24:50', "Not paid", 'On the way', 25, 2),
('2017-09-20 13:20:09', '2017-10-26 16:14:25', "Paid", 'Not Issued', 5, 3),
('2020-08-13 07:34:27', '2020-08-21 16:43:43',  "Not paid", 'Delivered', 6, 4),
('2017-06-01 18:30:45', '2017-06-09 22:24:16',  "Not paid", 'On the way', 4, 4),
('2017-08-07 05:55:43', '2017-09-14 11:32:03', "Not paid", 'Delivered', 7, 1),
('2018-01-13 17:40:36', '2018-11-02 05:31:53',  "Not paid", 'On the way', 28, 4),
('2019-04-24 18:48:37', '2019-05-31 07:09:26', "Not paid", 'On the way', 18, 2),
('2019-09-13 18:24:10', '2019-10-29 06:19:36',  "Paid", 'Not Issued', 20, 4),
('2020-11-05 16:18:21', '2020-12-14 04:54:44',  "Paid", 'Not Issued', 9, 4),
('2018-10-22 07:52:13', '2019-02-22 14:57:27', "Paid", 'Delivered', 18, 2);


insert into `items` (`Purchase_Quantity`, `Products_idProducts`, `Invoice_idInvoice`, `Ratings`) values  
(2, 2, 2,NULL),
(3, 5, 4, 3),
(5, 3, 5, 1), 
(6, 3, 3, 2),
(7, 4, 3, NULL),
(1, 9, 7,5),
(1, 10, 7,4),
(1, 11, 8,4),
(1, 12, 9,4),
(1, 24, 10,4),
(1, 25, 11,4),
(1, 22, 12,4),
(1, 6, 13,4),
(1, 8, 14,4),
(1, 9, 14,3),
(1, 18, 16,3),
(1, 19, 17,3),
(1, 12, 7,5),
(1, 20, 19,3),
(1, 5, 20,3),
(1, 2, 21,3),
(1, 25, 22,3),
(1, 24, 23,3),
(1, 18, 25,3),
(1, 9, 24,3),
(1, 5, 28,3),
(1, 10, 27,3),
(1, 8, 26,3),
(1, 6, 29,3),
(1, 9, 30,3),
(1, 20, 6,3),
(1, 21, 1,3),
(1, 9, 15,3),
(1, 19, 18,3),
(1, 7, 9,4),
(1, 1, 7,4),
(1, 9, 19,4),
(1, 8, 25,3);

-- 3. TRIGGERS

DROP trigger IF  EXISTS ITEMS_BI_UPDATE_STOCK;

DELIMITER $$
CREATE TRIGGER ITEMS_BI_UPDATE_STOCK
BEFORE INSERT
ON items
FOR EACH ROW
BEGIN

        UPDATE products as p, items i
		SET p.Stock = IF(p.stock>=new.Purchase_Quantity,p.Stock - NEW.Purchase_Quantity, p.stock)
		WHERE NEW.Products_idProducts = p.idProducts;
    
END $$
DELIMITER ;


-- Test Trigger 1
insert into invoice ( Issue_Date, Payment_Limit_Date, Total_Price, Payment_Status, Delivery_Status, client_idclient, Payment_Method_idPayment_Method) values 
 ('2019-11-20 08:47:50', '2019-12-13 06:11:28', 368.86, "Paid", "Delivered", 14, 1),
  ('2019-11-20 08:47:50', '2019-12-13 06:11:28', 368.86, "Paid", "Delivered", 13, 1);

INSERT INTO items (Purchase_Quantity, Products_idProducts, invoice_idinvoice) values (21, 2,3), (10,6,4);
SELECT * 
FROM products;

DROP trigger IF  EXISTS PRODUCTS_AU_INSERT_LOG;
-- Trigger 2
DELIMITER $$
CREATE TRIGGER PRODUCTS_AU_INSERT_LOG
AFTER UPDATE
ON products
FOR EACH ROW
BEGIN

    INSERT INTO log(Log_Date, usr, EV, MSG) values
    (now(), user(), concat(OLD.Price, ' - ', NEW.Price), concat('update product ', NEW.Product_Name));

END $$
DELIMITER ;

-- Test Trigger 2
UPDATE products p
SET p.Price = 5
WHERE p.idProducts = 1 OR p.idProducts=2;

SELECT *
FROM log;


DROP trigger IF  EXISTS invoice_Total_Price_Update;
-- Trigger 3
DELIMITER $$
CREATE TRIGGER invoice_Total_Price_Update
After Insert
ON items
FOR EACH ROW
BEGIN
	UPDATE invoice as inv, items i, products p
    SET inv.Total_Price= inv.Total_Price + (new.Purchase_Quantity*p.Price)
    WHERE NEW.Products_idProducts = p.idProducts and new.invoice_idinvoice=inv.idinvoice;

END $$
DELIMITER ;

DROP trigger IF  EXISTS invoice_Total_Price_Update;
-- Trigger 3
DELIMITER $$
CREATE TRIGGER invoice_Total_Price_Update
After Insert
ON items
FOR EACH ROW
BEGIN
	UPDATE invoice as inv, items i, products p
    SET inv.Total_Price= inv.Total_Price + (new.Purchase_Quantity*p.Price)
    WHERE NEW.Products_idProducts = p.idProducts and new.invoice_idinvoice=inv.idinvoice;

END $$
DELIMITER ;



DROP TRIGGER IF EXISTS client_Spending_Category_Update;
-- Trigger 4
DELIMITER $$
CREATE TRIGGER client_Spending_Category_Update
BEFORE INSERT
ON partc.client
for each row
BEGIN

set NEW.Spending_Category=IF(NEW.Spending_Score<20,1, IF(NEW.Spending_Score<40,2,IF(NEW.Spending_Score<60,3,IF(NEW.Spending_Score<80,4,5))));

END $$
DELIMITER ;

SELECT* FROM client;



-- 4. VIEWS
DROP VIEW IF EXISTS invoice_head;

create view invoice_head 
as select  i.idInvoice,i.Total_Price,i.Issue_Date, c.Client_Name, a.Street_Name,  ci.City_Name, cou.Country_Name
from invoice i
join client c on i.Client_idClient=c.idClient
join address a on c.Address_idAddress=a.idAddress
join city ci  on a.City_idCity=ci.idCity
join country  cou on ci.Country_idCountry=cou.idCountry
group by i.idInvoice
;

select*
from invoice_head;

-- 2. View 2
DROP VIEW IF EXISTS invoiceDetails;
CREATE VIEW invoiceDetails AS
    SELECT 
        items.Invoice_idInvoice AS 'Invoice',
        products.Product_Name AS 'Description',
        CONCAT(products.Price, '€') as 'Unit Cost',
        items.Purchase_Quantity as 'Quantity',
        CONCAT(ROUND(items.Purchase_Quantity * products.Price, 2), '€') as 'Total Cost of Item'
        
    FROM
        partc.invoice,
        partc.items,
        partc.products
    WHERE
        invoice.idInvoice = items.Invoice_idInvoice
            AND products.idProducts = items.Products_idProducts
    ORDER BY idInvoice ASC
;
SELECT * FROM invoiceDetails;

