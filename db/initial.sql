CREATE TABLE IF NOT EXISTS `activities` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_user` int(10) unsigned DEFAULT NULL,
  `id_task` int(10) unsigned DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created` datetime NOT NULL,
  `started` datetime DEFAULT NULL,
  `stopped` datetime DEFAULT NULL,
  `moment` datetime NOT NULL,
  `duration` int(10) unsigned NOT NULL DEFAULT 0,
  `isrunning` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `isactive` tinyint(3) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `fk_activities_users` (`id_user`),
  KEY `fk_activities_tasks` (`id_task`),
  CONSTRAINT `fk_activities_tasks` FOREIGN KEY (`id_task`) REFERENCES `tasks` (`id`),
  CONSTRAINT `fk_activities_users` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `jots` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_user` int(10) unsigned NOT NULL,
  `id_project` int(10) unsigned DEFAULT NULL,
  `id_task` int(10) unsigned DEFAULT NULL,
  `id_activity` int(10) unsigned DEFAULT NULL,
  `body` text DEFAULT NULL,
  `created` datetime NOT NULL,
  `moment` datetime NOT NULL,
  `isactive` tinyint(3) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `fk_jots_users` (`id_user`),
  KEY `fk_jots_projects` (`id_project`),
  KEY `fk_jots_tasks` (`id_task`),
  KEY `fk_jots_activities` (`id_activity`),
  CONSTRAINT `fk_jots_activities` FOREIGN KEY (`id_activity`) REFERENCES `activities` (`id`),
  CONSTRAINT `fk_jots_projects` FOREIGN KEY (`id_project`) REFERENCES `projects` (`id`),
  CONSTRAINT `fk_jots_tasks` FOREIGN KEY (`id_task`) REFERENCES `tasks` (`id`),
  CONSTRAINT `fk_jots_users` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `projects` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_user` int(10) unsigned DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `created` datetime NOT NULL,
  `moment` datetime NOT NULL,
  `duration` int(10) unsigned NOT NULL DEFAULT 0,
  `isactive` tinyint(3) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `fk_projects_users` (`id_user`),
  CONSTRAINT `fk_projects_users` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `roles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pluralname` varchar(45) NOT NULL,
  `singularname` varchar(45) NOT NULL,
  `isdefault` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `isactive` tinyint(3) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


INSERT INTO `roles` (`id`, `pluralname`, `singularname`, `isdefault`, `isactive`) VALUES
	(1, 'Visitors', 'Visitor', 0, 1),
	(2, 'Users', 'User', 1, 1),
	(3, 'Admins', 'Admin', 0, 1);


CREATE TABLE IF NOT EXISTS `role_tokens` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_role` int(10) unsigned NOT NULL,
  `token` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `IXU_security` (`id_role`,`token`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


INSERT INTO `role_tokens` (`id`, `id_role`, `token`) VALUES
	(1, 2, 'UserLoggedIn'),
	(2, 3, 'AdminLoggedIn'),
	(3, 3, 'UserLoggedIn');


CREATE TABLE IF NOT EXISTS `subscribers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `accesskey` varchar(45) NOT NULL,
  `secret` varchar(45) NOT NULL,
  `alloworigin` text DEFAULT NULL,
  `credits` int(10) NOT NULL DEFAULT 0,
  `isactive` tinyint(1) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `accesskey` (`accesskey`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


INSERT INTO `subscribers` (`id`, `name`, `accesskey`, `secret`, `alloworigin`, `credits`, `isactive`) VALUES
	(1, 'Demo', '00001-almagro', 'F9A08BA54DA9672B91B399487C07BF411F65C8D6F1C54', 'https://demo.local', 1000000, 1);


CREATE TABLE IF NOT EXISTS `subscribers_packages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_subscriber` int(10) unsigned NOT NULL,
  `packagetoken` varchar(45) NOT NULL,
  `packagecredits` int(11) NOT NULL DEFAULT 0,
  `status` enum('NEW','PENDING','PURCHASED','REDEEMED','CANCELLED') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `packagetoken_UNIQUE` (`packagetoken`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `tasks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_user` int(11) unsigned DEFAULT NULL,
  `id_project` int(11) unsigned DEFAULT NULL,
  `title` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `created` datetime NOT NULL,
  `moment` datetime NOT NULL,
  `duration` int(10) unsigned NOT NULL DEFAULT 0,
  `isrunning` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `isactive` tinyint(3) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `fk_tasks_users` (`id_user`),
  KEY `fk_tasks_projects` (`id_project`),
  CONSTRAINT `fk_tasks_projects` FOREIGN KEY (`id_project`) REFERENCES `projects` (`id`),
  CONSTRAINT `fk_tasks_users` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `tidbits` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_user` int(11) NOT NULL,
  `id_activity` int(11) NOT NULL,
  `started` datetime NOT NULL,
  `stopped` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_subscriber` int(11) NOT NULL,
  `login` varchar(45) NOT NULL,
  `passwd` varchar(128) NOT NULL,
  `oauthid` varchar(225) DEFAULT NULL,
  `oauthsource` varchar(3) DEFAULT NULL,
  `firstname` varchar(128) DEFAULT NULL,
  `lastname` varchar(128) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  `address` varchar(128) DEFAULT NULL,
  `city` varchar(128) DEFAULT NULL,
  `province` varchar(128) DEFAULT NULL,
  `postalcode` varchar(28) DEFAULT NULL,
  `country` varchar(128) DEFAULT NULL,
  `securityquestion` varchar(255) DEFAULT NULL,
  `securityanswer` varchar(255) DEFAULT NULL,
  `link` varchar(255) DEFAULT NULL,
  `locale` varchar(128) DEFAULT NULL,
  `isactive` tinyint(1) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `IXU_login` (`login`),
  UNIQUE KEY `IXU_email` (`email`),
  UNIQUE KEY `IXU_oauth` (`oauthid`,`oauthsource`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


INSERT INTO `users` (`id`, `id_subscriber`, `login`, `passwd`, `oauthid`, `oauthsource`, `firstname`, `lastname`, `email`, `phone`, `address`, `city`, `province`, `postalcode`, `country`, `securityquestion`, `securityanswer`, `link`, `locale`, `isactive`) VALUES
	(1, 1, 'visitor', '20DC0D52EF9568A3CBBB992DC2372914FA938C22', NULL, NULL, 'Random', 'Demo', 'demo@demo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
	
	
CREATE TABLE IF NOT EXISTS `users_x_roles` (
  `id_user` int(10) unsigned NOT NULL,
  `id_role` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id_user`,`id_role`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


INSERT INTO `users_x_roles` (`id_user`, `id_role`) VALUES (1, 3);


CREATE TABLE IF NOT EXISTS `user_logs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_session` int(10) unsigned NOT NULL,
  `useraction` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `moment` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `user_sessions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_user` int(10) unsigned NOT NULL,
  `token` varchar(45) NOT NULL,
  `created` datetime NOT NULL,
  `moment` datetime NOT NULL,
  `passes` int(10) unsigned NOT NULL DEFAULT 0,
  `credits` int(10) unsigned NOT NULL DEFAULT 0,
  `isactive` tinyint(3) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DELIMITER //
CREATE PROCEDURE `delete_activity`(IN `arg_userid` INT UNSIGNED, IN `arg_activityid` INT UNSIGNED, IN `arg_now` DATETIME)
BEGIN

	IF EXISTS(
		SELECT id 
      FROM activities
      WHERE id_user = arg_userid
		  AND id = arg_activityid
        AND isactive = 1
    ) THEN
            
	     CALL stop_activity(arg_userid, arg_activityid, arg_now);
        
        UPDATE activities
        SET isactive = 0
        WHERE id_user = arg_userid
			 AND id = arg_activityid; 
            
    END IF;
    
    CALL update_durations(arg_userid, arg_now);
    
    CALL get_activity(arg_userid, arg_activityid);

END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE `get_activity`(IN `arg_userid` INT UNSIGNED, IN `arg_activityid` INT UNSIGNED)
BEGIN

    SELECT  a.`id` AS activity_id,
            a.`id_user` AS activity_userid,
		    	a.`id_task` AS activity_taskid,
            a.`description` AS activity_description,
            a.`created` AS activity_created,
            a.`started` AS activity_started,
            a.`stopped` AS activity_stopped,
            a.`duration` AS activity_duration,
            a.`moment` AS activity_moment,
            a.`isrunning` AS activity_isrunning,
            a.`isactive` AS activity_isactive,
            t.`id` AS task_id,
            t.`id_user` AS task_userid,
				t.`id_project` AS task_projectid,
            t.`title` AS task_title,
            t.`description` AS task_description,
				t.`created` AS task_created,
				t.`moment` AS task_moment,
				t.`duration` AS task_duration,
            t.`isactive` AS task_isactive,
            p.`id` AS project_id,
				p.`id_user` AS project_userid,
            p.`name` AS project_name,
				p.`description` AS project_description,
				p.`created` AS project_created,
				p.`moment` AS project_moment,
				p.`duration` AS project_duration,
            p.`isactive` AS project_isactive
    FROM `activities` AS a
      LEFT OUTER JOIN `tasks` AS t
        ON t.`id` = a.`id_task`
      LEFT OUTER JOIN `projects` p
        ON p.`id` = t.`id_project`
    WHERE a.`id_user` = arg_userid
          AND a.`id` = arg_activityid;

  END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE `get_activity_report`(IN `arg_userid` INT UNSIGNED, IN `arg_filter_from` DATETIME, IN `arg_filter_to` DATETIME, IN `arg_searchstring` VARCHAR(255) CHARSET utf8)
BEGIN

	SELECT 
	   	b.id_activity, 
	   	a.description AS activity_description,
       	SUM(TO_SECONDS(IFNULL(b.stopped, NOW())) - TO_SECONDS(b.started)) AS duration, 
       	DATE(b.started) AS date_started,
       	a.id_task, 
       	t.title AS task_title,
       	t.id_project,
       	p.`name` AS project_name
	FROM tidbits b
		INNER JOIN activities a
			ON a.id = b.id_activity
		LEFT OUTER JOIN tasks t
			ON t.id = a.id_task
		LEFT OUTER JOIN projects p
		    ON p.id = t.id_project
	WHERE b.id_user = arg_userid
		AND b.started >= arg_filter_from
		AND b.stopped <= arg_filter_to
		AND a.isactive = 1
        AND (t.isactive = 1 OR t.id IS NULL)
        AND (p.isactive = 1 OR p.id IS NULL)
	GROUP BY a.id, DATE(b.started)
	ORDER BY b.started, DATE(b.started);
    
END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE `get_summary_report`(IN `arg_userid` INT UNSIGNED, IN `arg_filter_from` DATETIME, IN `arg_filter_to` DATETIME, IN `arg_searchstring` VARCHAR(255) CHARSET utf8)
BEGIN

	SELECT 
	   	b.id_activity, 
	   	a.description AS activity_description,
       	SUM(TO_SECONDS(IFNULL(b.stopped, NOW())) - TO_SECONDS(b.started)) AS duration, 
       	a.id_task, 
       	IFNULL(t.title, '') AS task_title,
       	t.id_project,
       	IFNULL(p.`name`, '') AS project_name
	FROM tidbits b
		INNER JOIN activities a
			ON a.id = b.id_activity
		LEFT OUTER JOIN tasks t
			ON t.id = a.id_task
		LEFT OUTER JOIN projects p
		    ON p.id = t.id_project
	WHERE b.id_user = arg_userid
		AND b.started >= arg_filter_from
		AND b.stopped <= arg_filter_to
		AND a.isactive = 1
        AND (t.isactive = 1 OR t.id IS NULL)
        AND (p.isactive = 1 OR p.id IS NULL)
	GROUP BY a.id
	ORDER BY IFNULL(p.`name`, ''), IFNULL(t.title, ''), a.description;

END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE `get_task`(IN `arg_userid` INT, IN `arg_taskid` INT)
BEGIN

SELECT t.`id`,
		 t.`id_user`,
		 t.`id_project`,
       t.`title`,
		 t.`description`,
       t.`created`,
		 t.`moment`,
       t.`duration`,
       t.`isrunning`,
		 t.`isactive`,
		 p.`id` AS project_id,
		 p.`name` AS project_name,
		 p.`description` AS project_description,
		 p.`created` AS project_created,
		 p.`moment` AS project_moment,
		 p.`duration` AS project_duration
	FROM `tasks` AS t
		LEFT OUTER JOIN `projects` AS p
			ON p.`id` = t.`id_project`
   WHERE t.`id` = arg_taskid
     AND t.`id_user` = arg_userid
     AND t.`isactive` = 1;

END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE `get_time_report`(IN `arg_userid` INT UNSIGNED, IN `arg_filter_from` DATETIME, IN `arg_filter_to` DATETIME, IN `arg_searchstring` VARCHAR(255) CHARSET utf8)
BEGIN

    SELECT 
	   b.id,
	   b.started, 
       b.stopped, 
       TO_SECONDS(IFNULL(b.stopped, NOW())) - TO_SECONDS(b.started) AS duration, 
       DATE(b.started) AS date_started,
	   b.id_activity, 
       a.description AS activity_description,
       a.id_task, 
       t.title AS task_title,
       t.id_project,
       p.`name` AS project_name
	FROM tidbits b
		INNER JOIN activities a
			ON a.id = b.id_activity
		LEFT OUTER JOIN tasks t
			ON t.id = a.id_task
		LEFT OUTER JOIN projects p
	   	    ON p.id = t.id_project
	WHERE b.id_user = arg_userid
		AND b.started >= arg_filter_from
		AND b.stopped <= arg_filter_to
		AND a.isactive = 1
        AND (t.isactive = 1 OR t.id IS NULL)
        AND (p.isactive = 1 OR p.id IS NULL)
	ORDER BY b.started, DATE(b.started);
    
END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE `quickstart_activity`(IN `arg_userid` INT UNSIGNED, IN `arg_taskid` INT UNSIGNED, IN `arg_description` VARCHAR(255) CHARSET utf8, IN `arg_now` DATETIME)
BEGIN

    DECLARE var_activityid INT;
    SET var_activityid = 0;
	
    INSERT INTO activities (id_user, description, created, moment)
    VALUES (arg_userid, arg_description, arg_now, arg_now);
    
    SET var_activityid = LAST_INSERT_ID();

	 IF EXISTS(
		SELECT id 
		FROM tasks 
		WHERE id = arg_taskid 
			AND id_user = arg_userid 
			AND isactive = 1
	 ) THEN
    
		  UPDATE activities 
        SET id_task = arg_taskid
        WHERE id = var_activityid;

	 END IF;
    
    CALL start_activity(arg_userid, var_activityid, arg_now);

END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE `quickstart_task`(IN `arg_userid` INT UNSIGNED, IN `arg_projectid` INT UNSIGNED, IN `arg_tasktitle` VARCHAR(100) CHARSET utf8, IN `arg_activitydescription` VARCHAR(255) CHARSET utf8, IN `arg_now` DATETIME)
BEGIN

   DECLARE var_taskid INT;

   SET var_taskid = 0;

	INSERT INTO tasks(id_user, title, description, created, moment) 
	VALUES (arg_userid, arg_tasktitle, '', arg_now, arg_now);

	SET var_taskid = LAST_INSERT_ID();

	IF EXISTS(
		SELECT id 
		FROM projects 
		WHERE id = arg_projectid 
		  AND id_user = arg_userid 
		  AND isactive = 1
	) THEN
    
		  UPDATE tasks 
        SET id_project = arg_projectid
        WHERE id = var_taskid;

	END IF;

	IF(var_taskid > 0) 
	THEN
		CALL quickstart_activity (arg_userid, var_taskid, arg_activitydescription, arg_now);
	END IF;

END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE `redeem_package`(IN `arg_subscriberid` INT, IN `arg_packagetoken` VARCHAR(45))
BEGIN

   DECLARE var_packageid INT;
   DECLARE var_packagecredits INT;

   SET var_packageid = 0;
   SET var_packagecredits = 0;

	IF EXISTS(
			SELECT `id` 
			FROM `subscribers` 
			WHERE `id` = arg_subscriberid
	)
	THEN

      IF EXISTS(
		  SELECT `id` 
		  FROM `subscribers_packages` 
        WHERE `id_subscriber` = arg_subscriberid 
		 	AND `packagetoken` = arg_packagetoken
         AND `status` = 'PURCHASED'
	   )
	   THEN
    
		  SELECT `id`, `packagecredits`
        INTO var_packageid, var_packagecredits
		  FROM `subscribers_packages` 
        WHERE `id_subscriber` = arg_subscriberid 
         AND `packagetoken` = arg_packagetoken
         AND `status` = 'PURCHASED';

      END IF;
    
      IF (var_packageid > 0 AND var_packagecredits > 0)
      THEN
    
        UPDATE `subscribers` 
		  SET `credits` = `credits` + var_packagecredits
		  WHERE `id` = arg_subscriberid;

        UPDATE `subscribers_packages` 
		  SET `status` = 'REDEEMED'
		  WHERE `id` = var_packageid;
		  
		  UPDATE `subscribers` 
		  SET `isactive` = 1
		  WHERE `id` = arg_subscriberid
		  	AND `credits` > 0;
    
      END IF;
    
    END IF;
    
    SELECT * FROM `subscribers` WHERE `id` = arg_subscriberid;
    
END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE `start_activity`(IN `arg_userid` INT UNSIGNED, IN `arg_activityid` INT UNSIGNED, IN `arg_now` DATETIME)
BEGIN

  DECLARE var_taskid INT;
  SET var_taskid = 0;
    
    -- starting activity if exists
  IF EXISTS(
			   SELECT id 
            FROM activities 
            WHERE id = arg_activityid
		      	AND id_user = arg_userid
		      	AND isactive = 1
		      	AND isrunning = 0
			  )   
            
  THEN
  
  	  CALL update_durations_quick(arg_userid, arg_now);

	  -- closing all activities, only one activity can be run at same time
	  UPDATE tidbits 
	  SET stopped = arg_now 
	  WHERE id_user = arg_userid
		 AND stopped IS NULL;

	  UPDATE activities
	  SET isrunning = 0,
		   stopped = arg_now, 
		   moment = arg_now
	  WHERE id_user = arg_userid
		 AND isrunning = 1
		 AND isactive = 1;
	  
	  -- stop tasks that have no activities running
	  UPDATE tasks 
	  SET isrunning = 0,
		   moment = arg_now
	  WHERE isactive = 1
	   AND isrunning = 1 
	  	AND id_user = arg_userid
		AND (SELECT COUNT(*) 
			 FROM activities 
			 WHERE activities.id_task = tasks.id 
			   AND activities.id_user = arg_userid
			   AND activities.isrunning = 1) = 0;
	  
	  -- getting task id
	  SELECT IFNULL(id_task, 0)
	  INTO var_taskid
	  FROM activities 
	  WHERE id = arg_activityid
		 AND id_user = arg_userid;
		 
	  IF (var_taskid > 0)
	  THEN
	  
	  		IF EXISTS(
							SELECT id 
							FROM tasks 
							WHERE id = var_taskid
							  AND id_user = arg_userid
							  AND isactive = 1
						)
			THEN
						
			  UPDATE tasks 
			  SET isrunning = 1,
				   moment = arg_now
			  WHERE id = var_taskid
				 AND isrunning = 0;
				 
			  UPDATE activities
		     SET started = arg_now
		     WHERE id = arg_activityid
		       AND started IS NULL;
	  
		 	  UPDATE activities
			  SET stopped = NULL, 
			     moment = arg_now, 
				  isrunning = 1
		 	  WHERE id = arg_activityid;
			
			  INSERT INTO tidbits (id_user, id_activity, started)
			  VALUES (arg_userid, arg_activityid, arg_now);
		  
	        CALL get_activity(arg_userid, arg_activityid);
						 
		   ELSE
		   
		     -- cannot start activity with inactive task
           CALL get_activity(arg_userid, arg_activityid);
						 
			END IF;
	  
	  ELSE
	   
		 UPDATE activities
		 SET started = arg_now
		 WHERE id = arg_activityid
		   AND started IS NULL;
	  
	 	 UPDATE activities
		 SET stopped = NULL, 
		     moment = arg_now, 
			  isrunning = 1
		 WHERE id = arg_activityid;
		
		 INSERT INTO tidbits (id_user, id_activity, started)
		 VALUES (arg_userid, arg_activityid, arg_now);
	  
       CALL get_activity(arg_userid, arg_activityid);
	  
	  END IF;
  
  END IF;

END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE `stop_activity`(IN `arg_userid` INT UNSIGNED, IN `arg_activityid` INT UNSIGNED, IN `arg_now` DATETIME)
BEGIN

	DECLARE var_taskid INT;
   DECLARE var_num_running_activities INT;

	SET var_taskid = 0;
   SET var_num_running_activities = 0;

   -- stopping activity if exists
   IF EXISTS(
			   SELECT id 
            FROM activities 
            WHERE id = arg_activityid
		      	AND id_user = arg_userid
		      	AND isactive = 1
		      	AND isrunning = 1
			   )   
            
   THEN

	    UPDATE activities
       SET isrunning = 0,
           stopped = arg_now, 
           moment = arg_now
       WHERE id = arg_activityid
	      AND id_user = arg_userid
         AND isrunning = 1;

       UPDATE tidbits 
       SET stopped = arg_now 
       WHERE id_user = arg_userid
         AND id_activity = arg_activityid
	      AND stopped IS NULL;

		 SELECT IFNULL(id_task, 0)
	    INTO var_taskid
	    FROM activities 
	    WHERE id = arg_activityid
		   AND id_user = arg_userid;

	    IF EXISTS(
		     SELECT id 
			  FROM tasks 
			  WHERE id = var_taskid 
			  	 AND id_user = arg_userid
			  	 AND isactive = 1
	    ) THEN
	
          SELECT COUNT(*) 
          INTO var_num_running_activities 
          FROM activities 
          WHERE id_task = var_taskid 
            AND id_user = arg_userid
            AND isrunning = 1;

		    UPDATE tasks 
		    SET moment = arg_now
		    WHERE id = var_taskid 
			   AND id_user = arg_userid;
			  
          IF var_num_running_activities = 0 THEN
        
            UPDATE tasks 
		      SET isrunning = 0
		      WHERE id = var_taskid 
			     AND id_user = arg_userid;
        
          END IF;

	   END IF;
    
      CALL update_durations(arg_userid, arg_now);
    
      CALL get_activity(arg_userid, arg_activityid);
      
   END IF;

END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE `stop_dormant_activities`(IN `arg_age` INT UNSIGNED, IN `arg_now` DATETIME)
BEGIN

  DECLARE done INT DEFAULT FALSE;
  DECLARE var_activityid INT;
  DECLARE var_userid INT;
  DECLARE cur1 CURSOR FOR SELECT id, id_user FROM activities WHERE TIMESTAMPDIFF(SECOND, moment, arg_now) > arg_age AND isrunning = 1;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur1;

  read_loop: LOOP
    FETCH cur1 INTO var_activityid, var_userid;
    
    IF done THEN
      LEAVE read_loop;
    END IF;
    
    CALL stop_activity(var_userid, var_activityid, arg_now);
    
  END LOOP;

  CLOSE cur1;

END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE `stop_dormant_sessions`(IN `arg_age` INT, IN `arg_now` DATETIME)
BEGIN
	UPDATE user_sessions SET isactive = 0 
	WHERE TIMESTAMPDIFF(SECOND, moment, arg_now) > arg_age;
END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE `stop_subscriptions`()
BEGIN

	UPDATE subscribers 
	SET isactive = 0
	WHERE credits < 0;

END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE `stop_task`(IN `arg_userid` INT UNSIGNED, IN `arg_taskid` INT UNSIGNED, IN `arg_now` DATETIME)
BEGIN

    DECLARE var_num_running_activities INT;
      
	IF EXISTS(
		  SELECT id 
        FROM tasks 
        WHERE id = arg_taskid 
			AND id_user = arg_userid
         AND isrunning = 1
         AND isactive = 1
	) THEN
    
		UPDATE tidbits 
		SET stopped = arg_now 
		WHERE id_user = arg_userid
			AND stopped IS NULL
			AND id_activity IN (SELECT id 
									  FROM activities 
									  WHERE id_user = arg_userid 
									    AND id_task = arg_taskid
									    AND isactive = 1
									    AND isrunning = 1);

		UPDATE activities
		SET isrunning = 0,
			 stopped = arg_now, 
			 moment = arg_now
		WHERE id_user = arg_userid
		  AND id_task = arg_taskid
		  AND isrunning = 1
        AND isactive = 1;
    
      SELECT COUNT(*) 
      INTO var_num_running_activities 
      FROM activities 
      WHERE id_task = arg_taskid 
        AND id_user = arg_userid
        AND isrunning = 1
        AND isactive = 1;

		IF var_num_running_activities = 0 THEN
        
        UPDATE tasks 
		  SET isrunning = 0, 
			   moment = arg_now
		  WHERE id = arg_taskid 
			 AND id_user = arg_userid
			 AND isactive = 1;
        
      END IF;

	END IF;
    
   CALL update_durations(arg_userid, arg_now);
    
   CALL get_task(arg_userid, arg_taskid);

END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE `toggle_activity`(arg_userid INT UNSIGNED, arg_activityid INT UNSIGNED, arg_now DATETIME)
BEGIN

	DECLARE var_activity_isrunning INT;

	SET var_activity_isrunning = 0;

	IF EXISTS(
		SELECT id 
        FROM activities
        WHERE id_user = arg_userid
			AND id = arg_activityid
            AND isactive = 1
    ) THEN
    
		SELECT isrunning
        INTO var_activity_isrunning
		FROM activities
		WHERE id_user = arg_userid
			AND id = arg_activityid
            AND isactive = 1;
		
        IF var_activity_isrunning = 0 THEN
			
            CALL start_activity(arg_userid, arg_activityid, arg_now);
        
        ELSE
        
			CALL stop_activity(arg_userid, arg_activityid, arg_now);
        
        END IF;
    
    END IF;

END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE `update_durations`(IN `arg_userid` INT UNSIGNED, IN `arg_now` DATETIME)
BEGIN

	UPDATE `activities`
	SET duration = IFNULL(fn_activity_duration(id, arg_now), 0)
	WHERE id_user = arg_userid
		AND isactive = 1;

	UPDATE `tasks`
	SET duration = IFNULL(fn_task_duration(id, arg_now), 0)
	WHERE id_user = arg_userid
		AND isactive = 1;
    
   UPDATE `projects`
   SET duration = IFNULL(fn_project_duration(id, arg_now), 0)
   WHERE id_user = arg_userid
	   AND isactive = 1;
		
	UPDATE `activities`
	SET `moment` = arg_now
	WHERE `id_user` = arg_userid
		AND `isactive` = 1
		AND `isrunning` = 1;

	UPDATE `tasks`
	SET `moment` = arg_now
	WHERE `id_user` = arg_userid
		AND `isactive` = 1
		AND `isrunning` = 1;

END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE `update_durations_quick`(IN `arg_userid` INT UNSIGNED, IN `arg_now` DATETIME)
BEGIN

	UPDATE `activities`
	SET `duration` = IFNULL(fn_activity_duration(id, arg_now), 0),
		 `moment` = arg_now
	WHERE `id_user` = arg_userid
		AND `isactive` = 1
		AND `isrunning` = 1;

	UPDATE `tasks`
	SET `duration` = IFNULL(fn_task_duration_quick(id), 0)
	WHERE `id_user` = arg_userid
		AND `isactive` = 1;
    
   UPDATE `projects`
   SET `duration` = IFNULL(fn_project_duration_quick(id), 0)
   WHERE `id_user` = arg_userid
      AND `isactive` = 1;

	UPDATE `tasks`
	SET `moment` = arg_now
	WHERE `id_user` = arg_userid
		AND `isactive` = 1
		AND `isrunning` = 1;

END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE `usp_log`(IN `arg_sessiontoken` VARCHAR(45), IN `arg_useraction` VARCHAR(100), IN `arg_description` TEXT, IN `arg_now` DATETIME)
BEGIN

DECLARE var_session_id INT;

SET var_session_id = 0;

IF EXISTS(
          SELECT id_user
          FROM user_sessions
          WHERE token = arg_sessiontoken
          	AND isactive = 1
          ) THEN

  SELECT id
  INTO var_session_id
  FROM user_sessions
  WHERE token = arg_sessiontoken;

  INSERT INTO user_logs (id_session, useraction, description, moment)
  VALUES (var_session_id, arg_useraction, arg_description, arg_now);

END IF;

END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE `usp_login`(IN `arg_login` varchar(45), IN `arg_passwd` varchar(128), IN `arg_accesskey` varchar(45), IN `arg_now` DATETIME)
BEGIN

DECLARE var_user_id INT;
DECLARE var_sessiontoken VARCHAR(128);

SET var_user_id = 0;
SET var_sessiontoken = SHA1(RAND());

IF EXISTS(
		  SELECT u.id
		  FROM users u
		    INNER JOIN subscribers s
		      ON s.id = u.id_subscriber
		  WHERE u.login = arg_login
            AND u.passwd = arg_passwd
		      AND u.isactive = 1
            AND s.accesskey = arg_accesskey
		      AND s.isactive = 1
          ) 
          
          THEN

  SELECT u.id
  INTO var_user_id
  FROM users u
    INNER JOIN subscribers s
      ON s.id = u.id_subscriber
  WHERE u.login = arg_login
    AND u.passwd = arg_passwd
    AND u.isactive = 1
    AND s.accesskey = arg_accesskey
    AND s.isactive = 1;

  INSERT INTO user_sessions (id_user, token, created, moment)
  VALUES (var_user_id, var_sessiontoken, arg_now, arg_now);

END IF;

CALL usp_pass (var_sessiontoken, arg_now);

END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE `usp_logout`(IN `arg_sessiontoken` varchar(128), IN `arg_now` DATETIME)
BEGIN

DECLARE var_user_id INT;
SET var_user_id = 0;

IF EXISTS (
            SELECT id_user
            FROM `user_sessions`
            WHERE `token` = arg_sessiontoken
				AND `isactive` = 1
          )

THEN

  SELECT `id_user`
  INTO var_user_id
  FROM `user_sessions`
  WHERE `token` = arg_sessiontoken
	AND `isactive` = 1;

  UPDATE `user_sessions`
  SET `isactive` = 0, `moment` = arg_now 
  WHERE `token` = arg_sessiontoken
	AND `isactive` = 1;

END IF;

SELECT u.`id`, u.`login`, u.`firstname`, u.`lastname`, u.`email`, x.`token` as sessiontoken, x.`created`, x.`moment`
FROM `users` u
  JOIN `user_sessions` x
WHERE u.`id` = var_user_id
  AND x.`token` = arg_sessiontoken
ORDER BY x.`moment` DESC
LIMIT 1;

END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE `usp_oauth_login`(arg_oauth_id varchar(255), arg_oauth_source varchar(3))
BEGIN

DECLARE var_user_id INT;
DECLARE var_sessiontoken VARCHAR(128);

SET var_user_id = 0;
SET var_sessiontoken = SHA1(RAND());

IF EXISTS(
            SELECT id
            FROM users
            WHERE oauthid = arg_oauth_id
            AND oauthsource = arg_oauth_source
            AND isactive = 1
          ) THEN

  SELECT id
  INTO var_user_id
  FROM users
  WHERE oauthid = arg_oauth_id
  AND oauthsource = arg_oauth_source
  AND isactive = 1;

  INSERT INTO user_sessions (id_user, token, moment)
  VALUES (var_user_id, var_sessiontoken, NOW());

END IF;

CALL usp_pass (var_sessiontoken);

END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE `usp_oauth_register`(arg_oauth_id varchar(255), arg_oauth_source varchar(3), arg_login varchar(45), arg_firstname varchar(128), arg_lastname varchar(128))
BEGIN

DECLARE var_user_id INT;
DECLARE var_sessiontoken VARCHAR(128);
DECLARE var_i INT UNSIGNED;
DECLARE done INT DEFAULT FALSE;

DECLARE rcur CURSOR FOR SELECT id FROM roles WHERE isdefault = 1;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

SET var_user_id = 0;
SET var_sessiontoken = SHA1(RAND());

IF NOT EXISTS(
            SELECT id
            FROM users
            WHERE oauthid = arg_oauth_id
            AND oauthsource = arg_oauth_source
            AND isactive = 1
          ) 
THEN

	INSERT INTO users (oauthid, oauthsource, login, passwd, firstname, lastname)
	VALUES (arg_oauth_id, arg_oauth_source, arg_login, '', arg_firstname, arg_lastname);

	SET var_user_id = LAST_INSERT_ID();

	DELETE FROM users_x_roles WHERE id_user = var_user_id;

	OPEN rcur;
    
	read_loop: LOOP

		FETCH rcur INTO var_i;

		IF done THEN
			LEAVE read_loop;
		END IF;

		INSERT INTO users_x_roles (id_user, id_role) VALUES (var_user_id, var_i);

	END LOOP;

	CLOSE rcur;
    
ELSE 

  SELECT id
  INTO var_user_id
  FROM users
  WHERE oauthid = arg_oauth_id
  AND oauthsource = arg_oauth_source
  AND isactive = 1;

END IF;

IF var_user_id > 0 THEN 

  INSERT INTO user_sessions (id_user, token, moment)
  VALUES (var_user_id, var_sessiontoken, NOW());

END IF;

CALL usp_pass (var_sessiontoken);

END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE `usp_pass`(IN `arg_sessiontoken` varchar(128), IN `arg_now` DATETIME)
BEGIN

DECLARE var_user_id INT;
DECLARE var_subscriberid INT;

SET var_user_id = 0;
SET var_subscriberid = 0;

IF EXISTS (
            SELECT id_user
            FROM user_sessions
            WHERE token = arg_sessiontoken
              AND isactive = 1
          )
THEN

	UPDATE user_sessions 
	SET moment = arg_now, 
		 passes = passes + 1
	WHERE token = arg_sessiontoken
		AND isactive = 1;

	SELECT id_user
	INTO var_user_id
	FROM user_sessions
	WHERE token = arg_sessiontoken
	AND isactive = 1;

	IF (var_user_id > 0) THEN

		CALL update_durations_quick(var_user_id, arg_now);

	END IF;

	SELECT id_subscriber
	INTO var_subscriberid
	FROM users
	WHERE id = var_user_id;
	
	IF EXISTS (
            SELECT id 
				FROM subscribers 
				WHERE id = var_subscriberid
					AND isactive = 1
          )
	THEN
	
		UPDATE subscribers 
		SET credits = credits - 1
		WHERE id = var_subscriberid;
		
		UPDATE user_sessions 
		SET credits = credits + 1
		WHERE token = arg_sessiontoken
			AND isactive = 1;
	
	END IF;

END IF;


SELECT u.`id`, u.`login`, u.`firstname`, u.`lastname`, u.`email`, x.`token` as sessiontoken, x.`created`, x.`moment`
FROM users u
  JOIN user_sessions x
    ON x.`id_user` = u.`id`
WHERE u.`id` = var_user_id
  AND u.`isactive` = 1
  AND x.`isactive` = 1
  AND x.`token` = arg_sessiontoken;

   
SELECT s.`id`, s.`name`, s.`accesskey`, s.`secret`, s.`alloworigin`, s.`credits` 
FROM subscribers s
WHERE s.`id` = var_subscriberid
	AND s.`isactive` = 1;

END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE `usp_ping`(IN `arg_sessiontoken` VARCHAR(128), IN `arg_now` DATETIME)
    NO SQL
BEGIN

  DECLARE var_user_id INT;

  SET var_user_id = 0;

  IF EXISTS (
            SELECT id_user
            FROM user_sessions
            WHERE token = arg_sessiontoken
              AND isactive = 1
          )
  THEN

	  SELECT id_user
	  INTO var_user_id
	  FROM user_sessions
	  WHERE token = arg_sessiontoken
		 AND isactive = 1;

  END IF;

  SELECT u.`id`, u.`login`, u.`firstname`, u.`lastname`, u.`email`, x.`token` as sessiontoken, x.`created`, x.`moment`, s.`id` AS subscriber_id, s.`name` AS subscriber_name, s.`alloworigin`, s.`credits`
  FROM `users` u
  JOIN `user_sessions` x
    ON x.`id_user` = u.`id`
  JOIN `subscribers` s
  	 ON s.`id` = u.`id_subscriber`
  WHERE u.`id` = var_user_id
    AND u.`isactive` = 1
    AND x.`isactive` = 1
    AND s.`isactive` = 1
    AND x.`token` = arg_sessiontoken;
    
  
  SELECT  a.`id` AS activity_id,
          a.`id_user` AS activity_userid,
			 a.`id_task` AS activity_taskid,
          a.`description` AS activity_description,
          a.`started` AS activity_started,
          a.`stopped` AS activity_stopped,
          a.`duration` AS activity_duration,
          a.`moment` AS activity_moment,
          a.`isrunning` AS activity_isrunning,
          a.`isactive` AS activity_isactive,
          t.`id` AS task_id,
          t.`id_user` AS task_userid,
			 t.`id_project` AS task_projectid,
          t.`title` AS task_title,
          t.`description` AS task_description,
			 t.`created` AS task_created,
			 t.`moment` AS task_moment,
			 t.`duration` AS task_duration,
          t.`isactive` AS task_isactive,
          p.`id` AS project_id,
			 p.`id_user` AS project_userid,
          p.`name` AS project_name,
			 p.`description` AS project_description,
			 p.`created` AS project_created,
			 p.`moment` AS project_moment,
			 p.`duration` AS project_duration,
          p.`isactive` AS project_isactive
    FROM `activities` AS a
      LEFT OUTER JOIN `tasks` AS t
        ON t.`id` = a.`id_task`
      LEFT OUTER JOIN `projects` p
        ON p.`id` = t.`id_project`
    WHERE a.`id_user` = var_user_id
          AND a.`isactive` = 1
          AND a.`isrunning` = 1;

END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE `usp_register`(arg_login varchar(45), arg_passwd varchar(128), arg_email varchar(255), arg_firstname varchar(128), arg_lastname varchar(128))
BEGIN

DECLARE var_user_id INT;
DECLARE var_sessiontoken VARCHAR(128);
DECLARE var_i INT UNSIGNED;
DECLARE done INT DEFAULT FALSE;

DECLARE rcur CURSOR FOR SELECT id FROM roles WHERE isdefault = 1;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

SET var_user_id = 0;
SET var_sessiontoken = SHA1(RAND());

IF NOT EXISTS(
            SELECT id
            FROM users
            WHERE login = arg_login
            AND passwd = arg_passwd
            AND isactive = 1
          ) 
THEN

  IF NOT EXISTS(
            SELECT id
            FROM users
            WHERE login = arg_login
            AND isactive = 1
          ) 
   THEN

		INSERT INTO users (login, passwd, email, firstname, lastname)
		VALUES (arg_login, arg_passwd, arg_email, arg_firstname, arg_lastname);

		SET var_user_id = LAST_INSERT_ID();
		
		DELETE FROM users_x_roles WHERE id_user = var_user_id;

		OPEN rcur;
  
		read_loop: LOOP
		
			FETCH rcur INTO var_i;
    
			IF done THEN
				LEAVE read_loop;
			END IF;

			INSERT INTO users_x_roles (id_user, id_role) VALUES (var_user_id, var_i);

		END LOOP;

		CLOSE rcur;

   END IF;

ELSE 

  SELECT id
  INTO var_user_id
  FROM users
  WHERE login = arg_login
  AND passwd = arg_passwd
  AND isactive = 1;

END IF;

IF var_user_id > 0 THEN 

  INSERT INTO usersessions (id_user, token, moment)
  VALUES (var_user_id, var_sessiontoken, NOW());

END IF;

SELECT u.id, u.login, u.firstname, u.lastname, u.email, x.token as sessiontoken, x.moment, x.lastactionmoment
FROM users u
  JOIN usersessions x
WHERE u.id = var_user_id
  AND x.token = var_sessiontoken
ORDER BY x.moment DESC
LIMIT 1;

SELECT id, pluralname, singularname
FROM roles r
JOIN users_x_roles ur
ON ur.id_role = r.id
WHERE ur.id_user = var_user_id;

END//
DELIMITER ;


DELIMITER //
CREATE FUNCTION `fn_activity_duration`(arg_activityid INT, arg_now DATETIME) RETURNS int(11)
BEGIN

DECLARE var_duration INT;

SELECT SUM( TO_SECONDS( IFNULL(stopped, arg_now) ) - TO_SECONDS(started) )
INTO var_duration
FROM tidbits
WHERE id_activity = arg_activityid;

RETURN var_duration;

END//
DELIMITER ;


DELIMITER //
CREATE FUNCTION `fn_project_duration`(arg_projectid INT, arg_now DATETIME) RETURNS int(11)
BEGIN

DECLARE var_duration INT;

SELECT SUM( IFNULL(fn_task_duration(t.id, arg_now), 0) )
INTO var_duration
FROM tasks AS t
INNER JOIN projects p
	ON t.id_project = p.id
WHERE t.isactive = 1
	AND p.id = arg_projectid;

RETURN var_duration;

END//
DELIMITER ;


DELIMITER //
CREATE FUNCTION `fn_project_duration_quick`(arg_projectid INT) RETURNS int(11)
BEGIN

DECLARE var_duration INT;

SELECT SUM(duration) 
INTO var_duration 
FROM tasks 
WHERE id_project = arg_projectid
	AND isactive = 1;

RETURN var_duration;
END//
DELIMITER ;


DELIMITER //
CREATE FUNCTION `fn_task_duration`(arg_taskid INT, arg_now DATETIME) RETURNS int(11)
BEGIN
DECLARE var_duration INT;

SELECT SUM( IFNULL(fn_activity_duration(id, arg_now), 0) )
INTO var_duration
FROM activities
WHERE isactive = 1
	AND id_task = arg_taskid;

RETURN var_duration;
END//
DELIMITER ;


DELIMITER //
CREATE FUNCTION `fn_task_duration_quick`(arg_taskid INT) RETURNS int(11)
BEGIN

DECLARE var_duration INT;

SELECT SUM(duration) 
INTO var_duration
FROM activities 
WHERE id_task = arg_taskid
	AND isactive = 1;

RETURN var_duration;
END//
DELIMITER ;
