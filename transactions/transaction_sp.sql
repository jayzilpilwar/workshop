BEGIN
create or replace table `dulcet-abacus-397714.transactions.workshop` as
(select * from dulcet-abacus-397714.transactions.test as c);
END