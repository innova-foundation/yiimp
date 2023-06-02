-- MariaDB dump 10.19  Distrib 10.6.8-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: yiimp
-- ------------------------------------------------------
-- Server version	10.6.8-MariaDB-1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accounts` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `coinid` int(11) DEFAULT NULL,
  `last_earning` int(10) DEFAULT NULL,
  `is_locked` tinyint(1) DEFAULT 0,
  `no_fees` tinyint(1) DEFAULT NULL,
  `donation` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `logtraffic` tinyint(1) DEFAULT NULL,
  `balance` double DEFAULT 0,
  `username` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `coinsymbol` varchar(16) DEFAULT NULL,
  `swap_time` int(10) unsigned DEFAULT NULL,
  `login` varchar(45) DEFAULT NULL,
  `hostaddr` varchar(39) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `coin` (`coinid`),
  KEY `balance` (`balance`),
  KEY `earning` (`last_earning`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `algos`
--

DROP TABLE IF EXISTS `algos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `algos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(16) DEFAULT NULL,
  `profit` double DEFAULT NULL,
  `rent` double DEFAULT NULL,
  `factor` double DEFAULT NULL,
  `overflow` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `balances`
--

DROP TABLE IF EXISTS `balances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `balances` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(16) DEFAULT NULL,
  `balance` double DEFAULT NULL,
  `onsell` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `balanceuser`
--

DROP TABLE IF EXISTS `balanceuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `balanceuser` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) DEFAULT NULL,
  `time` int(11) DEFAULT NULL,
  `balance` double DEFAULT NULL,
  `pending` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `userid` (`userid`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bench_chips`
--

DROP TABLE IF EXISTS `bench_chips`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bench_chips` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `devicetype` varchar(8) DEFAULT NULL,
  `vendorid` varchar(12) DEFAULT NULL,
  `chip` varchar(32) DEFAULT NULL,
  `year` int(4) unsigned DEFAULT NULL,
  `maxtdp` double DEFAULT NULL,
  `blake_rate` double DEFAULT NULL,
  `blake_power` double DEFAULT NULL,
  `x11_rate` double DEFAULT NULL,
  `x11_power` double DEFAULT NULL,
  `sha_rate` double DEFAULT NULL,
  `sha_power` double DEFAULT NULL,
  `scrypt_rate` double DEFAULT NULL,
  `scrypt_power` double DEFAULT NULL,
  `dag_rate` double DEFAULT NULL,
  `dag_power` double DEFAULT NULL,
  `lyra_rate` double DEFAULT NULL,
  `lyra_power` double DEFAULT NULL,
  `neo_rate` double DEFAULT NULL,
  `neo_power` double DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `features` varchar(255) DEFAULT NULL,
  `perfdata` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ndx_chip_type` (`devicetype`),
  KEY `ndx_chip_name` (`chip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bench_suffixes`
--

DROP TABLE IF EXISTS `bench_suffixes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bench_suffixes` (
  `vendorid` varchar(12) NOT NULL,
  `chip` varchar(32) DEFAULT NULL,
  `suffix` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`vendorid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `benchmarks`
--

DROP TABLE IF EXISTS `benchmarks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `benchmarks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `algo` varchar(16) NOT NULL,
  `type` varchar(8) NOT NULL,
  `khps` double DEFAULT NULL,
  `device` varchar(80) DEFAULT NULL,
  `vendorid` varchar(12) DEFAULT NULL,
  `chip` varchar(32) DEFAULT NULL,
  `idchip` int(11) DEFAULT NULL,
  `arch` varchar(8) DEFAULT NULL,
  `power` int(5) unsigned DEFAULT NULL,
  `plimit` int(5) unsigned DEFAULT NULL,
  `freq` int(8) unsigned DEFAULT NULL,
  `realfreq` int(8) unsigned DEFAULT NULL,
  `memf` int(8) unsigned DEFAULT NULL,
  `realmemf` int(8) unsigned DEFAULT NULL,
  `client` varchar(48) DEFAULT NULL,
  `os` varchar(8) DEFAULT NULL,
  `driver` varchar(32) DEFAULT NULL,
  `intensity` double DEFAULT NULL,
  `throughput` int(11) unsigned DEFAULT NULL,
  `userid` int(11) DEFAULT NULL,
  `time` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `bench_userid` (`userid`),
  KEY `ndx_type` (`type`),
  KEY `ndx_algo` (`algo`),
  KEY `ndx_time` (`time`),
  KEY `ndx_chip` (`idchip`),
  CONSTRAINT `fk_bench_chip` FOREIGN KEY (`idchip`) REFERENCES `bench_chips` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `blocks`
--

DROP TABLE IF EXISTS `blocks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `blocks` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `coin_id` int(11) DEFAULT NULL,
  `height` int(11) unsigned DEFAULT NULL,
  `confirmations` int(11) DEFAULT NULL,
  `time` int(11) DEFAULT NULL,
  `userid` int(11) DEFAULT NULL,
  `workerid` int(11) DEFAULT NULL,
  `difficulty_user` double DEFAULT NULL,
  `price` double DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `difficulty` double DEFAULT NULL,
  `category` varchar(16) DEFAULT NULL,
  `algo` varchar(16) DEFAULT 'scrypt',
  `blockhash` varchar(128) DEFAULT NULL,
  `txhash` varchar(128) DEFAULT NULL,
  `segwit` tinyint(1) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `time` (`time`),
  KEY `algo1` (`algo`),
  KEY `coin` (`coin_id`),
  KEY `category` (`category`),
  KEY `user1` (`userid`),
  KEY `height1` (`height`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='Discovered blocks persisted from Litecoin Service';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bookmarks`
--

DROP TABLE IF EXISTS `bookmarks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bookmarks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idcoin` int(11) NOT NULL,
  `label` varchar(32) DEFAULT NULL,
  `address` varchar(128) NOT NULL,
  `lastused` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bookmarks_coin` (`idcoin`),
  CONSTRAINT `fk_bookmarks_coin` FOREIGN KEY (`idcoin`) REFERENCES `coins` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `coins`
--

DROP TABLE IF EXISTS `coins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `coins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  `symbol` varchar(16) DEFAULT NULL,
  `symbol2` varchar(16) DEFAULT NULL,
  `algo` varchar(16) DEFAULT NULL,
  `version` varchar(32) DEFAULT NULL,
  `image` varchar(1024) DEFAULT NULL,
  `market` varchar(64) DEFAULT NULL,
  `marketid` int(11) DEFAULT NULL,
  `master_wallet` varchar(1024) DEFAULT NULL,
  `charity_address` varchar(1024) DEFAULT NULL,
  `charity_amount` double DEFAULT NULL,
  `charity_percent` double DEFAULT NULL,
  `deposit_address` varchar(1024) DEFAULT NULL,
  `deposit_minimum` double DEFAULT 1,
  `sellonbid` tinyint(1) DEFAULT NULL,
  `dontsell` tinyint(1) DEFAULT 1,
  `block_explorer` varchar(1024) DEFAULT NULL,
  `index_avg` double DEFAULT NULL,
  `connections` int(11) DEFAULT NULL,
  `errors` varchar(1024) DEFAULT NULL,
  `balance` double DEFAULT NULL,
  `immature` double DEFAULT NULL,
  `cleared` double DEFAULT NULL,
  `available` double DEFAULT NULL,
  `stake` double DEFAULT NULL,
  `mint` double DEFAULT NULL,
  `txfee` double DEFAULT NULL,
  `payout_min` double DEFAULT NULL,
  `payout_max` double DEFAULT NULL,
  `block_time` int(11) DEFAULT NULL,
  `difficulty` double DEFAULT 1,
  `difficulty_pos` double DEFAULT NULL,
  `block_height` int(11) DEFAULT NULL,
  `target_height` int(11) DEFAULT NULL,
  `powend_height` int(11) DEFAULT NULL,
  `network_hash` double DEFAULT NULL,
  `price` double DEFAULT NULL,
  `price2` double DEFAULT NULL,
  `reward` double DEFAULT 1,
  `reward_mul` double DEFAULT 1,
  `mature_blocks` int(11) DEFAULT NULL,
  `enable` tinyint(1) DEFAULT 0,
  `auto_ready` tinyint(1) DEFAULT 0,
  `visible` tinyint(1) DEFAULT NULL,
  `no_explorer` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `max_miners` int(11) DEFAULT NULL,
  `max_shares` int(11) DEFAULT NULL,
  `created` int(11) DEFAULT NULL,
  `action` int(11) DEFAULT NULL,
  `conf_folder` varchar(128) DEFAULT NULL,
  `program` varchar(128) DEFAULT NULL,
  `rpcuser` varchar(128) DEFAULT NULL,
  `rpcpasswd` varchar(128) DEFAULT NULL,
  `serveruser` varchar(45) DEFAULT NULL,
  `rpchost` varchar(128) DEFAULT NULL,
  `rpcport` int(11) DEFAULT NULL,
  `rpccurl` tinyint(1) NOT NULL DEFAULT 0,
  `rpcssl` tinyint(1) NOT NULL DEFAULT 0,
  `rpccert` varchar(255) DEFAULT NULL,
  `rpcencoding` varchar(16) DEFAULT NULL,
  `account` varchar(64) NOT NULL DEFAULT '',
  `hasgetinfo` tinyint(1) unsigned NOT NULL DEFAULT 1,
  `hassubmitblock` tinyint(1) unsigned NOT NULL DEFAULT 1,
  `hasmasternodes` tinyint(1) NOT NULL DEFAULT 0,
  `usememorypool` tinyint(1) DEFAULT NULL,
  `usesegwit` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `txmessage` tinyint(1) DEFAULT NULL,
  `auxpow` tinyint(1) DEFAULT NULL,
  `multialgos` tinyint(1) NOT NULL DEFAULT 0,
  `lastblock` varchar(128) DEFAULT NULL,
  `network_ttf` int(11) DEFAULT NULL,
  `actual_ttf` int(11) DEFAULT NULL,
  `pool_ttf` int(11) DEFAULT NULL,
  `last_network_found` int(11) DEFAULT NULL,
  `installed` tinyint(1) DEFAULT NULL,
  `watch` tinyint(1) NOT NULL DEFAULT 0,
  `link_site` varchar(1024) DEFAULT NULL,
  `link_exchange` varchar(1024) DEFAULT NULL,
  `link_bitcointalk` varchar(1024) DEFAULT NULL,
  `link_github` varchar(1024) DEFAULT NULL,
  `link_explorer` varchar(1024) DEFAULT NULL,
  `specifications` blob DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `auto_ready` (`auto_ready`),
  KEY `enable` (`enable`),
  KEY `algo` (`algo`),
  KEY `symbol` (`symbol`),
  KEY `index_avg` (`index_avg`),
  KEY `created` (`created`)
) ENGINE=InnoDB AUTO_INCREMENT=1425 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `connections`
--

DROP TABLE IF EXISTS `connections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `connections` (
  `id` int(11) NOT NULL,
  `user` varchar(64) DEFAULT NULL,
  `host` varchar(64) DEFAULT NULL,
  `db` varchar(64) DEFAULT NULL,
  `created` int(11) DEFAULT NULL,
  `idle` int(11) DEFAULT NULL,
  `last` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `earnings`
--

DROP TABLE IF EXISTS `earnings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `earnings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) DEFAULT NULL,
  `coinid` int(11) DEFAULT NULL,
  `blockid` int(11) DEFAULT NULL,
  `create_time` int(11) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `price` double DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `mature_time` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ndx_user_block` (`userid`,`blockid`),
  KEY `user` (`userid`),
  KEY `coin` (`coinid`),
  KEY `block` (`blockid`),
  KEY `create1` (`create_time`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `exchange`
--

DROP TABLE IF EXISTS `exchange`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exchange` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coinid` int(11) DEFAULT NULL,
  `send_time` int(11) DEFAULT NULL,
  `receive_time` int(11) DEFAULT NULL,
  `price` double DEFAULT NULL,
  `price_estimate` double DEFAULT NULL,
  `quantity` double DEFAULT NULL,
  `fee` double DEFAULT NULL,
  `status` varchar(16) DEFAULT NULL,
  `market` varchar(16) DEFAULT NULL,
  `tx` varchar(65) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `coinid` (`coinid`),
  KEY `status` (`status`),
  KEY `market` (`market`),
  KEY `send_time` (`send_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hashrate`
--

DROP TABLE IF EXISTS `hashrate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hashrate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` int(11) DEFAULT NULL,
  `hashrate` bigint(11) DEFAULT NULL,
  `hashrate_bad` bigint(11) DEFAULT NULL,
  `price` double DEFAULT NULL,
  `rent` double DEFAULT NULL,
  `earnings` double DEFAULT NULL,
  `difficulty` double DEFAULT NULL,
  `algo` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t1` (`time`),
  KEY `a1` (`algo`)
) ENGINE=InnoDB AUTO_INCREMENT=12607 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hashrenter`
--

DROP TABLE IF EXISTS `hashrenter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hashrenter` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `renterid` int(11) DEFAULT NULL,
  `jobid` int(11) DEFAULT NULL,
  `time` int(11) DEFAULT NULL,
  `hashrate` double DEFAULT NULL,
  `hashrate_bad` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hashstats`
--

DROP TABLE IF EXISTS `hashstats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hashstats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` int(11) DEFAULT NULL,
  `hashrate` bigint(11) DEFAULT NULL,
  `earnings` double DEFAULT NULL,
  `algo` varchar(16) DEFAULT 'scrypt',
  PRIMARY KEY (`id`),
  KEY `algo1` (`algo`),
  KEY `time1` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hashuser`
--

DROP TABLE IF EXISTS `hashuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hashuser` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) DEFAULT NULL,
  `time` int(11) DEFAULT NULL,
  `hashrate` bigint(11) DEFAULT NULL,
  `hashrate_bad` bigint(11) DEFAULT NULL,
  `algo` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `u1` (`userid`),
  KEY `t1` (`time`),
  KEY `a1` (`algo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `renterid` int(11) DEFAULT NULL,
  `ready` tinyint(1) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `time` int(11) DEFAULT NULL,
  `price` double DEFAULT NULL,
  `speed` double DEFAULT NULL,
  `difficulty` double DEFAULT NULL,
  `algo` varchar(16) DEFAULT NULL,
  `host` varchar(1024) DEFAULT NULL,
  `port` int(11) DEFAULT NULL,
  `username` varchar(1024) DEFAULT NULL,
  `password` varchar(1024) DEFAULT NULL,
  `percent` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `renterid` (`renterid`),
  KEY `ready` (`ready`),
  KEY `active` (`active`),
  KEY `algo` (`algo`),
  KEY `price` (`price`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jobsubmits`
--

DROP TABLE IF EXISTS `jobsubmits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jobsubmits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `jobid` int(11) DEFAULT NULL,
  `time` int(11) DEFAULT NULL,
  `valid` tinyint(1) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `difficulty` double DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `algo` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `market_history`
--

DROP TABLE IF EXISTS `market_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `market_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` int(11) NOT NULL,
  `idcoin` int(11) NOT NULL,
  `price` double DEFAULT NULL,
  `price2` double DEFAULT NULL,
  `balance` double DEFAULT NULL,
  `idmarket` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idcoin` (`idcoin`),
  KEY `idmarket` (`idmarket`),
  KEY `time` (`time`),
  CONSTRAINT `fk_mh_coin` FOREIGN KEY (`idcoin`) REFERENCES `coins` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_mh_market` FOREIGN KEY (`idmarket`) REFERENCES `markets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `markets`
--

DROP TABLE IF EXISTS `markets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `markets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coinid` int(11) DEFAULT NULL,
  `disabled` tinyint(1) NOT NULL DEFAULT 0,
  `marketid` int(11) DEFAULT NULL,
  `priority` tinyint(1) NOT NULL DEFAULT 0,
  `lastsent` int(11) DEFAULT NULL,
  `lasttraded` int(11) DEFAULT 0,
  `balancetime` int(11) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT NULL,
  `txfee` double DEFAULT NULL,
  `balance` double DEFAULT NULL,
  `ontrade` double NOT NULL DEFAULT 0,
  `price` double DEFAULT NULL,
  `price2` double DEFAULT NULL,
  `pricetime` int(11) DEFAULT NULL,
  `deposit_address` varchar(1024) DEFAULT NULL,
  `message` varchar(2048) DEFAULT NULL,
  `name` varchar(16) DEFAULT NULL,
  `base_coin` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `coinid` (`coinid`),
  KEY `name` (`name`),
  KEY `lastsent` (`lastsent`),
  KEY `lasttraded` (`lasttraded`)
) ENGINE=InnoDB AUTO_INCREMENT=2590 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mining`
--

DROP TABLE IF EXISTS `mining`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mining` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usdbtc` double DEFAULT NULL,
  `last_monitor_exchange` int(11) DEFAULT NULL,
  `last_update_price` int(11) DEFAULT NULL,
  `last_payout` int(11) DEFAULT NULL,
  `stratumids` varchar(1024) DEFAULT NULL,
  `best_algo` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nicehash`
--

DROP TABLE IF EXISTS `nicehash`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nicehash` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `active` tinyint(1) DEFAULT NULL,
  `orderid` int(11) DEFAULT NULL,
  `last_decrease` int(11) DEFAULT NULL,
  `algo` varchar(32) DEFAULT NULL,
  `btc` double DEFAULT NULL,
  `price` double DEFAULT NULL,
  `speed` double DEFAULT NULL,
  `workers` int(11) DEFAULT NULL,
  `accepted` double DEFAULT NULL,
  `rejected` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idcoin` int(11) NOT NULL,
  `enabled` int(1) NOT NULL DEFAULT 0,
  `description` varchar(128) DEFAULT NULL,
  `conditiontype` varchar(32) DEFAULT NULL,
  `conditionvalue` double DEFAULT NULL,
  `notifytype` varchar(32) DEFAULT NULL,
  `notifycmd` varchar(512) DEFAULT NULL,
  `lastchecked` int(10) unsigned DEFAULT NULL,
  `lasttriggered` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notif_coin` (`idcoin`),
  KEY `notif_checked` (`lastchecked`),
  CONSTRAINT `fk_notif_coin` FOREIGN KEY (`idcoin`) REFERENCES `coins` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coinid` int(11) DEFAULT NULL,
  `created` int(11) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `price` double DEFAULT NULL,
  `ask` double DEFAULT NULL,
  `bid` double DEFAULT NULL,
  `market` varchar(16) DEFAULT NULL,
  `uuid` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `coinid` (`coinid`),
  KEY `created` (`created`),
  KEY `market` (`market`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `payouts`
--

DROP TABLE IF EXISTS `payouts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payouts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL,
  `idcoin` int(11) DEFAULT NULL,
  `time` int(11) NOT NULL,
  `completed` tinyint(1) NOT NULL DEFAULT 0,
  `amount` double DEFAULT NULL,
  `fee` double DEFAULT NULL,
  `tx` varchar(128) DEFAULT NULL,
  `memoid` varchar(128) DEFAULT NULL,
  `errmsg` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `account_id` (`account_id`,`completed`),
  KEY `payouts_coin` (`idcoin`),
  CONSTRAINT `fk_payouts_account` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_payouts_coin` FOREIGN KEY (`idcoin`) REFERENCES `coins` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rawcoins`
--

DROP TABLE IF EXISTS `rawcoins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rawcoins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  `symbol` varchar(32) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=656 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `renters`
--

DROP TABLE IF EXISTS `renters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `renters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created` int(11) DEFAULT NULL,
  `updated` int(11) DEFAULT NULL,
  `address` varchar(1024) DEFAULT NULL,
  `email` varchar(1024) DEFAULT NULL,
  `password` varchar(64) DEFAULT NULL,
  `apikey` varbinary(1024) DEFAULT NULL,
  `received` double DEFAULT NULL,
  `balance` double DEFAULT NULL,
  `unconfirmed` double DEFAULT NULL,
  `spent` double DEFAULT NULL,
  `custom_start` double DEFAULT NULL,
  `custom_balance` double DEFAULT NULL,
  `custom_accept` double DEFAULT NULL,
  `custom_reject` double DEFAULT NULL,
  `custom_address` varchar(1024) DEFAULT NULL,
  `custom_server` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rentertxs`
--

DROP TABLE IF EXISTS `rentertxs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rentertxs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `renterid` int(11) DEFAULT NULL,
  `time` int(11) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `type` varchar(32) DEFAULT NULL,
  `address` varchar(1024) DEFAULT NULL,
  `tx` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `renterid` (`renterid`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `servers`
--

DROP TABLE IF EXISTS `servers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `servers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) DEFAULT NULL,
  `maxcoins` int(11) DEFAULT NULL,
  `uptime` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name1` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `services`
--

DROP TABLE IF EXISTS `services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `services` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  `algo` varchar(64) DEFAULT NULL,
  `price` double DEFAULT NULL,
  `speed` bigint(20) DEFAULT NULL,
  `custom_balance` double DEFAULT NULL,
  `custom_accept` double DEFAULT NULL,
  `custom_reject` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `settings` (
  `param` varchar(128) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  `type` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`param`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shares`
--

DROP TABLE IF EXISTS `shares`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shares` (
  `id` bigint(30) NOT NULL AUTO_INCREMENT,
  `userid` int(11) DEFAULT NULL,
  `workerid` int(11) DEFAULT NULL,
  `coinid` int(11) DEFAULT NULL,
  `jobid` int(11) DEFAULT NULL,
  `pid` int(11) DEFAULT NULL,
  `time` int(11) DEFAULT NULL,
  `error` int(11) DEFAULT NULL,
  `valid` tinyint(1) DEFAULT NULL,
  `extranonce1` tinyint(1) DEFAULT NULL,
  `difficulty` double NOT NULL DEFAULT 0,
  `share_diff` double NOT NULL DEFAULT 0,
  `algo` varchar(16) DEFAULT 'x11',
  PRIMARY KEY (`id`),
  KEY `time` (`time`),
  KEY `algo1` (`algo`),
  KEY `valid1` (`valid`),
  KEY `user1` (`userid`),
  KEY `worker1` (`workerid`),
  KEY `coin1` (`coinid`),
  KEY `jobid` (`jobid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stats`
--

DROP TABLE IF EXISTS `stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` int(11) DEFAULT NULL,
  `profit` double DEFAULT NULL,
  `wallet` double DEFAULT NULL,
  `wallets` double DEFAULT NULL,
  `immature` double DEFAULT NULL,
  `margin` double DEFAULT NULL,
  `waiting` double DEFAULT NULL,
  `balances` double DEFAULT NULL,
  `onsell` double DEFAULT NULL,
  `renters` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=383 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stratums`
--

DROP TABLE IF EXISTS `stratums`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stratums` (
  `pid` int(11) NOT NULL,
  `time` int(11) DEFAULT NULL,
  `started` int(11) unsigned DEFAULT NULL,
  `algo` varchar(64) DEFAULT NULL,
  `workers` int(10) unsigned NOT NULL DEFAULT 0,
  `port` int(6) unsigned DEFAULT NULL,
  `symbol` varchar(16) DEFAULT NULL,
  `url` varchar(128) DEFAULT NULL,
  `fds` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`pid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `withdraws`
--

DROP TABLE IF EXISTS `withdraws`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `withdraws` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `market` varchar(1024) DEFAULT NULL,
  `address` varchar(1024) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `time` int(11) DEFAULT NULL,
  `uuid` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `workers`
--

DROP TABLE IF EXISTS `workers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `workers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) DEFAULT NULL,
  `time` int(11) DEFAULT NULL,
  `pid` int(11) DEFAULT NULL,
  `subscribe` tinyint(1) DEFAULT NULL,
  `difficulty` double DEFAULT NULL,
  `ip` varchar(32) DEFAULT NULL,
  `dns` varchar(1024) DEFAULT NULL,
  `name` varchar(64) DEFAULT NULL,
  `nonce1` varchar(64) DEFAULT NULL,
  `version` varchar(64) DEFAULT NULL,
  `password` varchar(64) DEFAULT NULL,
  `worker` varchar(64) DEFAULT NULL,
  `algo` varchar(16) DEFAULT 'scrypt',
  PRIMARY KEY (`id`),
  KEY `algo1` (`algo`),
  KEY `name1` (`name`),
  KEY `userid` (`userid`),
  KEY `pid` (`pid`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-08-17 23:09:35
