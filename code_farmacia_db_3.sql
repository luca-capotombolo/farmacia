-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Farmacia_versione1
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Farmacia_versione1
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Farmacia_versione1` DEFAULT CHARACTER SET utf8 ;
USE `Farmacia_versione1` ;

-- -----------------------------------------------------
-- Table `Farmacia_versione1`.`ditta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmacia_versione1`.`ditta` (
  `Nome` VARCHAR(45) NOT NULL,
  `IndirizzoDiFatturazione` VARCHAR(100) NOT NULL,
  `RecapitoPreferito` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Nome`),
  UNIQUE INDEX `IndirizzoDiFatturazione_UNIQUE` (`IndirizzoDiFatturazione` ASC) ,
  UNIQUE INDEX `RecapitoPreferito_UNIQUE` (`RecapitoPreferito` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Farmacia_versione1`.`prodotto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmacia_versione1`.`prodotto` (
  `Nome` VARCHAR(45) NOT NULL,
  `Ditta` VARCHAR(45) NOT NULL,
  `TipoProdotto` TINYINT NOT NULL,
  PRIMARY KEY (`Nome`, `Ditta`),
  INDEX `fk_prodotto_ditta_Ditta_idx` (`Ditta` ASC) ,
  CONSTRAINT `fk_prodotto_ditta_Ditta`
    FOREIGN KEY (`Ditta`)
    REFERENCES `Farmacia_versione1`.`ditta` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Farmacia_versione1`.`usoprodotto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmacia_versione1`.`usoprodotto` (
  `Prodotto` VARCHAR(45) NOT NULL,
  `Ditta` VARCHAR(45) NOT NULL,
  `Uso` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`Prodotto`, `Ditta`, `Uso`),
  CONSTRAINT `fk_usoprodotto_prodotto_Prodotto`
    FOREIGN KEY (`Prodotto` , `Ditta`)
    REFERENCES `Farmacia_versione1`.`prodotto` (`Nome` , `Ditta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Farmacia_versione1`.`altriRecapiti`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmacia_versione1`.`altriRecapiti` (
  `Recapito` VARCHAR(45) NOT NULL,
  `Ditta` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Recapito`),
  INDEX `fk_altriRecapiti_ditta1_idx` (`Ditta` ASC) ,
  CONSTRAINT `fk_altriRecapiti_ditta1`
    FOREIGN KEY (`Ditta`)
    REFERENCES `Farmacia_versione1`.`ditta` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Farmacia_versione1`.`altriIndirizzi`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmacia_versione1`.`altriIndirizzi` (
  `Indirizzo` VARCHAR(100) NOT NULL,
  `Ditta` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Indirizzo`),
  INDEX `fk_altriIndirizzi_ditta_Ditta_idx` (`Ditta` ASC) ,
  CONSTRAINT `fk_altriIndirizzi_ditta_Ditta`
    FOREIGN KEY (`Ditta`)
    REFERENCES `Farmacia_versione1`.`ditta` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Farmacia_versione1`.`categoria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmacia_versione1`.`categoria` (
  `Nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Nome`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Farmacia_versione1`.`medicinale`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmacia_versione1`.`medicinale` (
  `Prodotto` VARCHAR(45) NOT NULL,
  `Ditta` VARCHAR(45) NOT NULL,
  `CategoriaFarmacoterapeutica` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Prodotto`, `Ditta`),
  INDEX `fk_medicinale_categoria1_idx` (`CategoriaFarmacoterapeutica` ASC) ,
  CONSTRAINT `fk_medicinale_prodotto`
    FOREIGN KEY (`Prodotto` , `Ditta`)
    REFERENCES `Farmacia_versione1`.`prodotto` (`Nome` , `Ditta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_medicinale_categoria1`
    FOREIGN KEY (`CategoriaFarmacoterapeutica`)
    REFERENCES `Farmacia_versione1`.`categoria` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Farmacia_versione1`.`interazioneCategoria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmacia_versione1`.`interazioneCategoria` (
  `PrimaCategoria` VARCHAR(45) NOT NULL,
  `SecondaCategoria` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`PrimaCategoria`, `SecondaCategoria`),
  INDEX `fk_interazioneCategoria_2_idx` (`SecondaCategoria` ASC),
  CONSTRAINT `fk_interazioneCategoria_categoria_1`
    FOREIGN KEY (`PrimaCategoria`)
    REFERENCES `Farmacia_versione1`.`categoria` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_interazioneCategoria_2`
    FOREIGN KEY (`SecondaCategoria`)
    REFERENCES `Farmacia_versione1`.`categoria` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Farmacia_versione1`.`cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmacia_versione1`.`cliente` (
  `CF` VARCHAR(100) NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  `Cognome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`CF`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Farmacia_versione1`.`riduzioneImposta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmacia_versione1`.`riduzioneImposta` (
  `Medicinale` VARCHAR(45) NOT NULL,
  `Ditta` VARCHAR(45) NOT NULL,
  `Cliente` VARCHAR(45) NOT NULL,
  `Anno` VARCHAR(45) NOT NULL,
  `Quantita` DOUBLE NOT NULL,
  PRIMARY KEY (`Medicinale`, `Ditta`, `Cliente`, `Anno`),
  INDEX `fk_riduzioneImposta_cliente_Cliente_idx` (`Cliente` ASC) ,
  CONSTRAINT `fk_riduzioneImposta_medicinale_Medicinale`
    FOREIGN KEY (`Medicinale` , `Ditta`)
    REFERENCES `Farmacia_versione1`.`medicinale` (`Prodotto` , `Ditta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_riduzioneImposta_cliente_Cliente`
    FOREIGN KEY (`Cliente`)
    REFERENCES `Farmacia_versione1`.`cliente` (`CF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Farmacia_versione1`.`ordine`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmacia_versione1`.`ordine` (
  `Codice` VARCHAR(45) NOT NULL,
  `Ditta` VARCHAR(45) NOT NULL,
  `Data` DATE NOT NULL,
  PRIMARY KEY (`Codice`),
  INDEX `fk_ordine_ditta_Ditta_idx` (`Ditta` ASC) ,
  CONSTRAINT `fk_ordine_ditta_Ditta`
    FOREIGN KEY (`Ditta`)
    REFERENCES `Farmacia_versione1`.`ditta` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Farmacia_versione1`.`ordineMedicinale`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmacia_versione1`.`ordineMedicinale` (
  `Ordine` VARCHAR(45) NOT NULL,
  `Medicinale` VARCHAR(45) NOT NULL,
  `Ditta` VARCHAR(45) NOT NULL,
  `Quantita` INT NULL,
  PRIMARY KEY (`Ordine`, `Medicinale`, `Ditta`),
  INDEX `fk_ordineMedicinale_medicinale_idx` (`Medicinale` ASC, `Ditta` ASC) ,
  CONSTRAINT `fk_ordineMedicinale_medicinale`
    FOREIGN KEY (`Medicinale` , `Ditta`)
    REFERENCES `Farmacia_versione1`.`medicinale` (`Prodotto` , `Ditta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ordineMedicinale_ordine`
    FOREIGN KEY (`Ordine`)
    REFERENCES `Farmacia_versione1`.`ordine` (`Codice`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Farmacia_versione1`.`scatoleMedicinale`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmacia_versione1`.`scatoleMedicinale` (
  `Medicinale` VARCHAR(45) NOT NULL,
  `Ditta` VARCHAR(45) NOT NULL,
  `DataDiScadenza` DATE NOT NULL,
  `Quantita` INT NOT NULL,
  PRIMARY KEY (`Medicinale`, `Ditta`, `DataDiScadenza`),
  CONSTRAINT `fk_scatoleMedicinale_medicinale`
    FOREIGN KEY (`Medicinale` , `Ditta`)
    REFERENCES `Farmacia_versione1`.`medicinale` (`Prodotto` , `Ditta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Farmacia_versione1`.`scaffale`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmacia_versione1`.`scaffale` (
  `Codice` VARCHAR(45) NOT NULL,
  `CategoriaFarmacoterapeutica` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Codice`, `CategoriaFarmacoterapeutica`),
  INDEX `fk_scaffale_categoriaF_categoF_idx` (`CategoriaFarmacoterapeutica` ASC) ,
  CONSTRAINT `fk_scaffale_categoriaF_categoF`
    FOREIGN KEY (`CategoriaFarmacoterapeutica`)
    REFERENCES `Farmacia_versione1`.`categoria` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Farmacia_versione1`.`cassetto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmacia_versione1`.`cassetto` (
  `Codice` VARCHAR(45) NOT NULL,
  `Scaffale` VARCHAR(45) NOT NULL,
  `CategoriaFarmacoterapeutica` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Codice`, `Scaffale`, `CategoriaFarmacoterapeutica`),
  INDEX `fk_cassetto_scaffale_idx` (`Scaffale` ASC, `CategoriaFarmacoterapeutica` ASC),
  CONSTRAINT `fk_cassetto_scaffale`
    FOREIGN KEY (`Scaffale` , `CategoriaFarmacoterapeutica`)
    REFERENCES `Farmacia_versione1`.`scaffale` (`Codice` , `CategoriaFarmacoterapeutica`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Farmacia_versione1`.`cassettoScatole`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmacia_versione1`.`cassettoScatole` (
  `Medicinale` VARCHAR(45) NOT NULL,
  `Ditta` VARCHAR(45) NOT NULL,
  `DataDiScadenza` DATE NOT NULL,
  `Cassetto` VARCHAR(45) NOT NULL,
  `Scaffale` VARCHAR(45) NOT NULL,
  `CategoriaFarmacoterapeutica` VARCHAR(45) NOT NULL,
  `Quantita` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Medicinale`, `Ditta`, `DataDiScadenza`, `Cassetto`, `Scaffale`, `CategoriaFarmacoterapeutica`),
  INDEX `fk_cassettoScatole_cassetto_idx` (`Cassetto` ASC, `Scaffale` ASC, `CategoriaFarmacoterapeutica` ASC) ,
  CONSTRAINT `fk_cassettoScatole_scatoleMedicinale`
    FOREIGN KEY (`Medicinale` , `Ditta` , `DataDiScadenza`)
    REFERENCES `Farmacia_versione1`.`scatoleMedicinale` (`Medicinale` , `Ditta` , `DataDiScadenza`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cassettoScatole_cassetto`
    FOREIGN KEY (`Cassetto` , `Scaffale` , `CategoriaFarmacoterapeutica`)
    REFERENCES `Farmacia_versione1`.`cassetto` (`Codice` , `Scaffale` , `CategoriaFarmacoterapeutica`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Farmacia_versione1`.`medicinaleRicetta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmacia_versione1`.`medicinaleRicetta` (
  `Medicinale` VARCHAR(45) NOT NULL,
  `Ditta` VARCHAR(45) NOT NULL,
  `Mutuabile` TINYINT NOT NULL,
  PRIMARY KEY (`Medicinale`, `Ditta`),
  CONSTRAINT `fk_medicinaleRicetta_medicinale`
    FOREIGN KEY (`Medicinale` , `Ditta`)
    REFERENCES `Farmacia_versione1`.`medicinale` (`Prodotto` , `Ditta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Farmacia_versione1`.`venditaConRicetta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmacia_versione1`.`venditaConRicetta` (
  `Medicinale` VARCHAR(45) NOT NULL,
  `Ditta` VARCHAR(45) NOT NULL,
  `Medico` VARCHAR(45) NOT NULL,
  `Data` DATE NOT NULL,
  `Quantita` INT NULL,
  PRIMARY KEY (`Medicinale`, `Ditta`, `Medico`, `Data`),
  CONSTRAINT `fk_venditaMedicinale_medicinale`
    FOREIGN KEY (`Medicinale` , `Ditta`)
    REFERENCES `Farmacia_versione1`.`medicinaleRicetta` (`Medicinale` , `Ditta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Farmacia_versione1`.`utenti`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmacia_versione1`.`utenti` (
  `Username` VARCHAR(45) NOT NULL,
  `Password` VARCHAR(45) NOT NULL,
  `Ruolo` ENUM('medico', 'amministratore') NOT NULL,
  PRIMARY KEY (`Username`))
ENGINE = InnoDB;

USE `Farmacia_versione1` ;

-- -----------------------------------------------------
-- procedure login
-- -----------------------------------------------------

DELIMITER $$
USE `Farmacia_versione1`$$
CREATE PROCEDURE `login` (in var_username varchar(45), in var_password varchar(45), out var_ruolo INT)
BEGIN	
	declare var_ruolo_utente ENUM('medico','amministratore');
    
    -- Verifico quale è il ruolo dell'utente che richiede di effettuare l'accesso 
    select `Ruolo` 
    from `utenti`
    where `Username` = var_username and `Password`= var_password
    into var_ruolo_utente;
    
    -- A seconda del risultato della ricerca setto il valore della variabile di output
    -- In modo tale che a livello applicativo si sappia il ruolo dell'utente o l'eventuale errore
    if var_ruolo_utente = 'medico' then
		set var_ruolo = 1;
	elseif var_ruolo_utente = 'amministratore' then
		set var_ruolo = 2;
	else	
		set var_ruolo = 3;
	end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure info_ditte
-- -----------------------------------------------------

DELIMITER $$
USE `Farmacia_versione1`$$
CREATE PROCEDURE `info_ditte` ()
BEGIN
	select *
    from ditta;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure info_clienti
-- -----------------------------------------------------

DELIMITER $$
USE `Farmacia_versione1`$$
CREATE PROCEDURE `info_clienti` ()
BEGIN
	select * from cliente;
END$$

DELIMITER ;


SET SQL_MODE='';
GRANT USAGE ON *.* TO login;
DROP USER login;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'login' IDENTIFIED BY 'login';
GRANT EXECUTE ON procedure `Farmacia_versione1`.`login` TO 'login';


SET SQL_MODE='';
GRANT USAGE ON *.* TO medico;
DROP USER medico;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'medico' IDENTIFIED BY 'medico';


SET SQL_MODE='';
GRANT USAGE ON *.* TO amministratore;
DROP USER amministratore;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'amministratore' IDENTIFIED BY 'amministratore';

GRANT EXECUTE ON procedure `Farmacia_versione1`.`info_clienti` TO 'amministratore';
GRANT EXECUTE ON procedure `Farmacia_versione1`.`info_ditte` TO 'amministratore';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
