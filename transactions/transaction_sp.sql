CREATE OR REPLACE PROCEDURE `dulcet-abacus-397714.transactions.transactions_sp`()
BEGIN 
CREATE OR REPLACE TABLE `dulcet-abacus-397714.transactions.workshop` AS SELECT * FROM `dulcet-abacus-397714.transactions.test`; 
END;