/*No 1 */

CREATE TABLE `map_user_hobby` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_user` INT(11) DEFAULT NULL,
  `id_hobby` INT(11) DEFAULT NULL,
  `status` ENUM('active','deleted') DEFAULT 'active',
  PRIMARY KEY (`id`),
  KEY `USERID` (`id_user`),
  KEY `IDHOBBY` (`id_hobby`)
) ENGINE=INNODB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4;

/*Data for the table `map_user_hobby` */

INSERT  INTO `map_user_hobby`(`id`,`id_user`,`id_hobby`,`status`) VALUES 
(1,1,1,'active'),
(2,3,1,'active'),
(3,8,3,'deleted'),
(4,2,2,'active'),
(5,4,1,'deleted'),
(6,6,2,'active'),
(7,5,3,'active'),
(8,8,1,'active'),
(9,7,2,'active'),
(10,4,2,'active'),
(11,9,3,'deleted'),
(16,10,2,'deleted'),
(17,3,2,'active'),
(18,2,3,'active'),
(19,10,2,'active');

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) DEFAULT NULL,
  `gender` ENUM('F','M') DEFAULT 'F',
  `status` ENUM('active','deleted') DEFAULT 'active',
  PRIMARY KEY (`id`)
) ENGINE=INNODB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;

/*Data for the table `users` */

INSERT  INTO `users`(`id`,`name`,`gender`,`status`) VALUES 
(1,'Frasch','F','active'),
(2,'Garmuth','M','active'),
(3,'Goliath','M','active'),
(4,'Luna ','F','active'),
(5,'Zeus ','M','active'),
(6,'Ares','M','active'),
(7,'Lina','F','active'),
(8,'Lanaya','F','active'),
(9,'Hades','M','active');




/*No 2*/

SELECT a.gender,COUNT(c.name) AS total 
FROM users a LEFT JOIN map_user_hobby b
ON a.id = b.id_user LEFT JOIN hobbies c
ON c.id = b.id_hobby
WHERE c.name = 'Skipping'
GROUP BY a.gender

/*No 3*/

SELECT a.name AS name_user,COUNT(c.name) AS total 
FROM users a LEFT JOIN map_user_hobby b
ON a.id = b.id_user LEFT JOIN hobbies c
ON c.id = b.id_hobby
WHERE b.status ='active'
GROUP BY a.id

/*No 4*/

SELECT name_user , AVG(total_avg) AS total_avg FROM (
SELECT a.name AS name_user,COUNT(c.name) AS total_avg
FROM users a LEFT JOIN map_user_hobby b
ON a.id = b.id_user LEFT JOIN hobbies c
ON c.id = b.id_hobby
WHERE b.status ='active'
GROUP BY a.id ) AS temp
WHERE total_avg > 1
GROUP BY name_user





