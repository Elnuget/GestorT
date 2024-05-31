-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 28-05-2024 a las 20:44:47
-- Versión del servidor: 8.0.37
-- Versión de PHP: 8.1.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `gonzaloe_GestorT`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_notifications` (IN `emails` TEXT, IN `message` TEXT)   BEGIN
    DECLARE current_email VARCHAR(255);
    DECLARE delimiter_position INT;
    DECLARE remain_emails TEXT;

    SET remain_emails = emails;

    -- Iterar sobre cada correo electrónico separado por comas
    WHILE LOCATE(',', remain_emails) > 0 DO
        SET delimiter_position = LOCATE(',', remain_emails);
        SET current_email = LEFT(remain_emails, delimiter_position - 1);
        SET remain_emails = SUBSTRING(remain_emails, delimiter_position + 1);

        -- Quitar espacios del correo electrónico antes de insertar
        SET current_email = TRIM(current_email);

        INSERT INTO notifications (email, notification, status)
        VALUES (current_email, message, 'Activa');
    END WHILE;

    -- Último correo electrónico después de la última coma
    IF remain_emails <> '' THEN
        -- Quitar espacios del último correo electrónico antes de insertar
        SET remain_emails = TRIM(remain_emails);

        INSERT INTO notifications (email, notification, status)
        VALUES (remain_emails, message, 'Activa');
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `groups`
--

CREATE TABLE `groups` (
  `id` int NOT NULL,
  `group_name` varchar(255) NOT NULL,
  `group_members` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `groups`
--

INSERT INTO `groups` (`id`, `group_name`, `group_members`, `created_at`, `updated_at`, `created_by`) VALUES
(4, 'GestorT', 'ricardo@gmail.com, cangulo009@outlook.es', '2024-05-05 20:38:23', '2024-05-22 01:54:02', ''),
(5, 'hola xd', '', '2024-05-05 21:34:17', '2024-05-17 02:10:24', ''),
(6, 'GestorTaaa', 'ricardo@gmail.com', '2024-05-07 21:23:10', '2024-05-08 02:23:10', ''),
(7, 'Pruebaaaaaa', 'ricardo@gmail.com', '2024-05-16 20:45:42', '2024-05-17 02:20:05', 'cangulo009@outlook.es'),
(8, 'segundadada', 'cangulo009@outlook.es', '2024-05-16 21:25:28', '2024-05-27 17:35:02', 'cangulo009@outlook.es'),
(9, 'PreubaS', 'ricardo@gmail.com', '2024-05-25 22:02:23', '2024-05-28 20:16:10', 'ricardo@gmail.com'),
(11, 'Prueba', 'prueba7@gmail.com, ricardo@gmail.com', '2024-05-28 15:16:50', '2024-05-28 20:16:50', 'prueba7@gmail.com');

--
-- Disparadores `groups`
--
DELIMITER $$
CREATE TRIGGER `after_group_insert` AFTER INSERT ON `groups` FOR EACH ROW BEGIN
    CALL insert_notifications(NEW.group_members, CONCAT('Nuevo grupo creado: ', NEW.group_name, ' en fecha: ', NEW.created_at));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `group_chats`
--

CREATE TABLE `group_chats` (
  `id` int NOT NULL,
  `group_id` int NOT NULL,
  `user_email` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `group_chats`
--

INSERT INTO `group_chats` (`id`, `group_id`, `user_email`, `message`, `created_at`) VALUES
(1, 4, 'ricardo@gmail.com', 'hola', '2024-05-21 21:07:32'),
(5, 4, 'ricardo@gmail.com', 'sjahdajksd', '2024-05-21 21:08:56'),
(6, 4, 'ricardo@gmail.com', 'Face', '2024-05-21 21:15:54'),
(7, 4, 'ricardo@gmail.com', 'Face', '2024-05-21 21:15:54'),
(8, 4, 'ricardo@gmail.com', 'prueba', '2024-05-21 21:18:20'),
(9, 4, 'ricardo@gmail.com', 'hola', '2024-05-21 21:18:28'),
(10, 4, 'ricardo@gmail.com', 'xD', '2024-05-21 21:18:37'),
(11, 4, 'cangulo009@outlook.es', 'jelow', '2024-05-21 21:21:13'),
(12, 4, 'cangulo009@outlook.es', 'si tellego el mensje ?', '2024-05-21 21:21:26'),
(13, 4, 'ricardo@gmail.com', 'wenas', '2024-05-21 21:21:30'),
(14, 4, 'cangulo009@outlook.es', '123', '2024-05-21 21:21:42'),
(15, 4, 'ricardo@gmail.com', 'as', '2024-05-21 21:21:46'),
(16, 4, 'ricardo@gmail.com', 'wenas', '2024-05-23 20:48:08'),
(17, 4, 'ricardo@gmail.com', 'xD', '2024-05-23 20:48:14'),
(18, 4, 'ricardo@gmail.com', 'hola', '2024-05-23 21:04:12'),
(19, 4, 'ricardo@gmail.com', 'pruba', '2024-05-23 21:04:20'),
(20, 4, 'ricardo@gmail.com', 'f', '2024-05-23 21:07:15'),
(21, 4, 'ricardo@gmail.com', 'wenas', '2024-05-23 21:07:28'),
(22, 4, 'ricardo@gmail.com', '1111111', '2024-05-23 21:07:39'),
(23, 4, 'cangulo009@outlook.es', 'hola', '2024-05-23 21:10:11'),
(24, 4, 'ricardo@gmail.com', 'hola amigo', '2024-05-23 21:10:21'),
(25, 4, 'cangulo009@outlook.es', ':)', '2024-05-23 21:10:27'),
(26, 4, 'ricardo@gmail.com', 'xD', '2024-05-23 21:12:06'),
(27, 4, 'ricardo@gmail.com', 'xD', '2024-05-23 21:12:07'),
(28, 4, 'ricardo@gmail.com', 'a', '2024-05-23 21:12:32'),
(29, 4, 'ricardo@gmail.com', 'a', '2024-05-23 21:12:33'),
(30, 4, 'ricardo@gmail.com', 'b', '2024-05-23 21:13:05'),
(32, 9, 'prueba7@gmail.com', 'x<ds', '2024-05-27 12:36:46'),
(33, 9, 'prueba7@gmail.com', 'dsfsd', '2024-05-27 12:36:51'),
(34, 9, 'ricardo@gmail.com', 'que mas ve', '2024-05-27 12:37:59'),
(35, 9, 'prueba7@gmail.com', 'aqui nomas', '2024-05-27 12:38:20'),
(36, 9, 'ricardo@gmail.com', 'xD', '2024-05-28 00:28:43'),
(37, 11, 'prueba7@gmail.com', 'gdf', '2024-05-28 19:45:35'),
(38, 11, 'prueba7@gmail.com', 'sdfs', '2024-05-28 19:45:38');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `group_tasks`
--

CREATE TABLE `group_tasks` (
  `id` int NOT NULL,
  `group_id` int DEFAULT NULL,
  `user_email` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` text,
  `assigned_user_email` varchar(255) DEFAULT NULL,
  `date_task` datetime DEFAULT NULL,
  `status` enum('Pendiente','Realizado','Pospuesto') NOT NULL DEFAULT 'Pendiente',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `group_tasks`
--

INSERT INTO `group_tasks` (`id`, `group_id`, `user_email`, `title`, `description`, `assigned_user_email`, `date_task`, `status`, `created_at`, `updated_at`) VALUES
(2, 4, 'cangulo009@outlook.es', 'a', 'rroz', 'cangulo009@outlook.es', '2024-05-11 21:21:48', 'Pendiente', '2024-05-11 21:21:51', '2024-05-26 02:56:22'),
(3, 6, 'ricardo@gmail.com', 'dfsdf', 'sdfsdfs', 'ricardo@gmail.com', '2024-05-21 20:44:18', 'Realizado', '2024-05-21 20:44:18', '2024-05-22 01:44:23'),
(6, 9, 'ricardo@gmail.com', 'dss', 'sds', 'ricardo@gmail.com', '2024-05-25 22:03:18', 'Pendiente', '2024-05-25 22:03:17', '2024-05-26 03:03:17'),
(7, 9, 'ricardo@gmail.com', 'sds', 'sds', 'prueba7@gmail.com', '2024-05-25 22:03:25', 'Pendiente', '2024-05-25 22:03:24', '2024-05-26 03:03:24'),
(8, 9, 'prueba7@gmail.com', 'df', 'dsdf', 'ricardo@gmail.com', '2024-05-27 12:36:40', 'Pendiente', '2024-05-27 12:36:39', '2024-05-27 17:36:39'),
(10, 11, 'prueba7@gmail.com', 'sddsd', 'sdsd', 'prueba7@gmail.com', '2024-05-28 19:15:41', 'Pendiente', '2024-05-28 19:15:40', '2024-05-29 01:01:26'),
(12, 11, 'prueba7@gmail.com', 'xD', 'xD', 'prueba7@gmail.com', '2024-05-28 19:38:33', 'Pendiente', '2024-05-28 19:38:32', '2024-05-29 01:01:38'),
(13, 11, 'prueba7@gmail.com', 'esafsd', 'asdasd', 'prueba7@gmail.com', '2024-05-28 19:43:19', 'Pendiente', '2024-05-28 19:43:18', '2024-05-29 00:43:18'),
(14, 11, 'prueba7@gmail.com', 'sgsdf', 'sdfsdf', 'prueba7@gmail.com', '2024-05-28 19:56:32', 'Pendiente', '2024-05-28 19:56:31', '2024-05-29 00:56:31'),
(15, 11, 'prueba7@gmail.com', 'fgfg', 'fgfgf', 'ricardo@gmail.com', '2024-05-28 19:56:41', 'Pendiente', '2024-05-28 19:56:40', '2024-05-29 00:56:40'),
(16, 6, 'ricardo@gmail.com', 'sdsdsd', 'sdsdss', 'ricardo@gmail.com', '2024-05-28 20:28:22', 'Pendiente', '2024-05-28 20:28:21', '2024-05-29 01:28:21');

--
-- Disparadores `group_tasks`
--
DELIMITER $$
CREATE TRIGGER `after_task_insert` AFTER INSERT ON `group_tasks` FOR EACH ROW BEGIN
    DECLARE group_emails TEXT;
    DECLARE assigned_email VARCHAR(255);

    -- Obtener los correos electrónicos de los miembros del grupo correspondiente a la tarea insertada
    SELECT group_members INTO group_emails FROM `groups` WHERE id = NEW.group_id;

    -- Obtener el correo electrónico del usuario asignado para la tarea
    SET assigned_email = NEW.assigned_user_email;

    -- Llamar al procedimiento almacenado para enviar las notificaciones
    CALL insert_notifications(group_emails, CONCAT('Nueva tarea asignada: "', NEW.title, '" - ', NEW.description, 
                                                   ' Fecha de creación: ', NEW.created_at, 
                                                   ', Responsable: ', assigned_email));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notifications`
--

CREATE TABLE `notifications` (
  `id` int NOT NULL,
  `email` varchar(250) NOT NULL,
  `notification` text NOT NULL,
  `status` enum('Activa','Inactiva') NOT NULL DEFAULT 'Activa'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `notifications`
--

INSERT INTO `notifications` (`id`, `email`, `notification`, `status`) VALUES
(3, 'cangulo009@outlook.es', 'Nuevo grupo creado: GestorT en fecha: 2024-05-05 20:38:23', 'Inactiva'),
(4, ' ricardo@gmail.com', 'Nuevo grupo creado: GestorT en fecha: 2024-05-05 20:38:23', 'Activa'),
(5, 'cangulo009@outlook.es', 'Nuevo grupo creado: hola xd en fecha: 2024-05-05 21:34:17', 'Inactiva'),
(6, 'cangulo009@outlook.es', 'Nueva tarea asignada: \"cable\" - aaaa Fecha de creación: 2024-05-07 20:18:08, Responsable: cangulo009@outlook.es', 'Inactiva'),
(7, ' ricardo@gmail.com', 'Nueva tarea asignada: \"cable\" - aaaa Fecha de creación: 2024-05-07 20:18:08, Responsable: cangulo009@outlook.es', 'Activa'),
(8, 'ricardo@gmail.com', 'Nuevo grupo creado: GestorTaaa en fecha: 2024-05-07 21:23:10', 'Inactiva'),
(9, 'cangulo009@outlook.es', 'Nueva tarea asignada: \"jkhjl\" - kljklj Fecha de creación: 2024-05-11 21:21:51, Responsable: cangulo009@outlook.es', 'Inactiva'),
(10, ' ricardo@gmail.com', 'Nueva tarea asignada: \"jkhjl\" - kljklj Fecha de creación: 2024-05-11 21:21:51, Responsable: cangulo009@outlook.es', 'Activa'),
(11, 'ricardo@gmail.com', 'Nuevo grupo creado: Pruebaaaaaa en fecha: 2024-05-16 20:45:42', 'Inactiva'),
(12, ' cangulo009@outlook.es', 'Nuevo grupo creado: Pruebaaaaaa en fecha: 2024-05-16 20:45:42', 'Activa'),
(13, 'ricardo@gmail.com', 'Nuevo grupo creado: segundadada en fecha: 2024-05-16 21:25:28', 'Inactiva'),
(14, 'cangulo009@outlook.es', 'Nuevo grupo creado: segundadada en fecha: 2024-05-16 21:25:28', 'Inactiva'),
(15, 'ricardo@gmail.com', 'Nueva tarea asignada: \"dfsdf\" - sdfsdfs Fecha de creación: 2024-05-21 20:44:18, Responsable: ricardo@gmail.com', 'Inactiva'),
(16, 'ricardo@gmail.com', 'Nueva tarea asignada: \"a\" - b Fecha de creación: 2024-05-25 21:57:20, Responsable: ricardo@gmail.com', 'Inactiva'),
(17, 'cangulo009@outlook.es', 'Nueva tarea asignada: \"a\" - b Fecha de creación: 2024-05-25 21:57:20, Responsable: ricardo@gmail.com', 'Activa'),
(18, 'ricardo@gmail.com', 'Nueva tarea asignada: \"si\" - no Fecha de creación: 2024-05-25 21:58:47, Responsable: ricardo@gmail.com', 'Inactiva'),
(19, 'cangulo009@outlook.es', 'Nueva tarea asignada: \"si\" - no Fecha de creación: 2024-05-25 21:58:47, Responsable: ricardo@gmail.com', 'Activa'),
(20, 'ricardo@gmail.com', 'Nuevo grupo creado: PreubaS en fecha: 2024-05-25 22:02:23', 'Inactiva'),
(21, 'prueba7@gmail.com', 'Nuevo grupo creado: PreubaS en fecha: 2024-05-25 22:02:23', 'Inactiva'),
(22, 'ricardo@gmail.com', 'Nueva tarea asignada: \"dss\" - sds Fecha de creación: 2024-05-25 22:03:17, Responsable: ricardo@gmail.com', 'Inactiva'),
(23, 'prueba7@gmail.com', 'Nueva tarea asignada: \"dss\" - sds Fecha de creación: 2024-05-25 22:03:17, Responsable: ricardo@gmail.com', 'Inactiva'),
(24, 'ricardo@gmail.com', 'Nueva tarea asignada: \"sds\" - sds Fecha de creación: 2024-05-25 22:03:24, Responsable: prueba7@gmail.com', 'Inactiva'),
(25, 'prueba7@gmail.com', 'Nueva tarea asignada: \"sds\" - sds Fecha de creación: 2024-05-25 22:03:24, Responsable: prueba7@gmail.com', 'Inactiva'),
(26, 'ricardo@gmail.com', 'Nuevo grupo creado: PruebaxD en fecha: 2024-05-25 22:04:41', 'Inactiva'),
(27, 'prueba7@gmail.com', 'Nuevo grupo creado: PruebaxD en fecha: 2024-05-25 22:04:41', 'Inactiva'),
(28, 'ricardo@gmail.com', 'Nueva tarea asignada: \"df\" - dsdf Fecha de creación: 2024-05-27 12:36:39, Responsable: ricardo@gmail.com', 'Inactiva'),
(29, 'prueba7@gmail.com', 'Nueva tarea asignada: \"df\" - dsdf Fecha de creación: 2024-05-27 12:36:39, Responsable: ricardo@gmail.com', 'Inactiva'),
(30, 'prueba7@gmail.com', 'Nuevo grupo creado: Prueba en fecha: 2024-05-28 15:16:50', 'Inactiva'),
(31, 'ricardo@gmail.com', 'Nuevo grupo creado: Prueba en fecha: 2024-05-28 15:16:50', 'Inactiva'),
(32, 'prueba7@gmail.com', 'Nueva tarea asignada: \"sa\" - asa Fecha de creación: 2024-05-28 18:59:07, Responsable: ricardo@gmail.com', 'Inactiva'),
(33, 'ricardo@gmail.com', 'Nueva tarea asignada: \"sa\" - asa Fecha de creación: 2024-05-28 18:59:07, Responsable: ricardo@gmail.com', 'Inactiva'),
(34, 'prueba7@gmail.com', 'Nueva tarea asignada: \"FS\" - SDSD Fecha de creación: 2024-05-28 19:15:40, Responsable: prueba7@gmail.com', 'Inactiva'),
(35, 'ricardo@gmail.com', 'Nueva tarea asignada: \"FS\" - SDSD Fecha de creación: 2024-05-28 19:15:40, Responsable: prueba7@gmail.com', 'Inactiva'),
(36, 'prueba7@gmail.com', 'Nueva tarea asignada: \"DSSD\" - SDSDS Fecha de creación: 2024-05-28 19:17:53, Responsable: prueba7@gmail.com', 'Inactiva'),
(37, 'ricardo@gmail.com', 'Nueva tarea asignada: \"DSSD\" - SDSDS Fecha de creación: 2024-05-28 19:17:53, Responsable: prueba7@gmail.com', 'Inactiva'),
(38, 'prueba7@gmail.com', 'Nueva tarea asignada: \"DFDF\" - DFDFD Fecha de creación: 2024-05-28 19:38:32, Responsable: prueba7@gmail.com', 'Inactiva'),
(39, 'ricardo@gmail.com', 'Nueva tarea asignada: \"DFDF\" - DFDFD Fecha de creación: 2024-05-28 19:38:32, Responsable: prueba7@gmail.com', 'Inactiva'),
(40, 'prueba7@gmail.com', 'Nueva tarea asignada: \"esafsd\" - asdasd Fecha de creación: 2024-05-28 19:43:18, Responsable: prueba7@gmail.com', 'Inactiva'),
(41, 'ricardo@gmail.com', 'Nueva tarea asignada: \"esafsd\" - asdasd Fecha de creación: 2024-05-28 19:43:18, Responsable: prueba7@gmail.com', 'Inactiva'),
(42, 'prueba7@gmail.com', 'Nueva tarea asignada: \"sgsdf\" - sdfsdf Fecha de creación: 2024-05-28 19:56:31, Responsable: prueba7@gmail.com', 'Inactiva'),
(43, 'ricardo@gmail.com', 'Nueva tarea asignada: \"sgsdf\" - sdfsdf Fecha de creación: 2024-05-28 19:56:31, Responsable: prueba7@gmail.com', 'Inactiva'),
(44, 'prueba7@gmail.com', 'Nueva tarea asignada: \"fgfg\" - fgfgf Fecha de creación: 2024-05-28 19:56:40, Responsable: ricardo@gmail.com', 'Inactiva'),
(45, 'ricardo@gmail.com', 'Nueva tarea asignada: \"fgfg\" - fgfgf Fecha de creación: 2024-05-28 19:56:40, Responsable: ricardo@gmail.com', 'Inactiva'),
(46, 'ricardo@gmail.com', 'Nueva tarea asignada: \"sdsdsd\" - sdsdss Fecha de creación: 2024-05-28 20:28:21, Responsable: ricardo@gmail.com', 'Inactiva');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tasks`
--

CREATE TABLE `tasks` (
  `id` int NOT NULL,
  `email` varchar(250) NOT NULL,
  `title` varchar(350) NOT NULL,
  `description` varchar(400) NOT NULL,
  `status` enum('Pendiente','Pospuesto','Terminado') DEFAULT 'Pendiente',
  `date_task` timestamp NOT NULL,
  `group_id` int DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `tasks`
--

INSERT INTO `tasks` (`id`, `email`, `title`, `description`, `status`, `date_task`, `group_id`, `updated_at`) VALUES
(3, 'prueba6@gmail.com', 'Hola mundo', '123456', 'Pendiente', '2024-01-18 05:00:00', NULL, '2024-04-05 02:02:35'),
(7, 'prueba8@gmail.com', 'Prueba8', 'Hola prueba 8', 'Pendiente', '2024-01-20 05:00:00', NULL, '2024-04-05 02:02:35'),
(9, 'ricardoh@gmail.com', 'Hola mundo', 'Hola mundo', 'Pendiente', '2024-02-10 05:00:00', NULL, '2024-04-05 02:02:35'),
(10, 'ricardoh@gmail.com', 'XD', 'XD', 'Pendiente', '2024-03-01 05:00:00', NULL, '2024-04-05 02:02:35'),
(11, 'ricardoh@gmail.com', 'nnm nm', 'hiuhiuhui', 'Pendiente', '2024-03-02 05:00:00', NULL, '2024-04-05 02:02:35'),
(13, 'prueba7@gmail.com', 'Hola', 'Hola', 'Pendiente', '2024-03-27 05:00:00', NULL, '2024-05-29 00:34:31'),
(14, 'ricardo@gmail.com', 'kimokdsm', 'kasmdkm', 'Terminado', '2024-03-27 05:00:00', NULL, '2024-04-05 02:02:35'),
(17, 'cangulo009@outlook.es', 'AAAA', 'BBBBBB', 'Terminado', '2024-03-29 05:00:00', NULL, '2024-04-05 02:02:35'),
(18, 'cangulo009@outlook.es', 'AAA', 'BBBBBBBB', 'Pendiente', '2024-03-29 05:00:00', NULL, '2024-04-05 02:02:35'),
(19, 'cangulo009@outlook.es', 'ca', 'sdas', 'Pendiente', '2024-03-31 05:00:00', NULL, '2024-04-05 02:02:35'),
(20, 'cangulo009@outlook.es', '4324', '34234', 'Pendiente', '2024-03-31 05:00:00', NULL, '2024-04-05 02:02:35'),
(24, 'prueba7@gmail.com', 'n kjnk', 'jknkjnj', 'Pospuesto', '2024-04-02 05:00:00', NULL, '2024-05-29 00:22:37'),
(28, 'cangulo009@outlook.es', 'gffdgfd', 'gfdgdf', 'Pendiente', '2024-04-04 05:00:00', NULL, '2024-04-05 02:02:35'),
(30, 'cangulo009@outlook.es', 'jhgjgh', 'jhgjghj', 'Pendiente', '2024-04-09 05:00:00', NULL, '2024-04-10 02:24:31'),
(31, 'cangulo009@outlook.es', 'dfdfgfd', 'gfdgdfgfd', 'Pendiente', '2024-04-20 05:00:00', NULL, '2024-04-21 01:12:19'),
(32, 'cangulo009@outlook.es', 'ñlñ', '´´ñlñ´lñ', 'Pendiente', '2024-05-11 05:00:00', NULL, '2024-05-12 02:22:20'),
(33, 'ricardo@gmail.com', 'dfdf', 'dfdf', 'Terminado', '2024-05-25 05:00:00', NULL, '2024-05-27 17:35:46'),
(35, 'prueba7@gmail.com', 'CXXC', 'XCXC', 'Terminado', '2024-05-28 05:00:00', NULL, '2024-05-29 00:22:38');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `name` varchar(250) NOT NULL,
  `surnames` varchar(250) NOT NULL,
  `email` varchar(250) NOT NULL,
  `password` varchar(250) NOT NULL,
  `profile_image` varchar(250) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `name`, `surnames`, `email`, `password`, `profile_image`) VALUES
(1, 'ricardo', 'hidalgo', 'ricardo@gmail.com', '12345', 'a1019d64-459d-4acf-98ad-7cde02af77abe013a95f-1760-45d7-bae5-9d54d3d71868.gif'),
(5, 'Prueba', 'prueba', 'prueba@gmail.com', '12345', NULL),
(6, 'prueba2', 'prueba2', 'prueba2@gmail.com', '12345', NULL),
(7, 'prueba3', 'prueb3', 'prueba3@gmail.com', '1234', NULL),
(8, 'prueba4', 'p', 'prueba4@gmail.com', '12345', NULL),
(9, 'prueba6', 'p', 'prueba6@gmail.com', '123456', NULL),
(10, 'prueba7', 'P7', 'prueba7@gmail.com', '12345', 'b2ca5bf5-3644-4135-8a79-cb3acadd2686image.png'),
(11, 'Prueba8', 'P8', 'prueba8@gmail.com', '12345', NULL),
(12, 'Ricardo', 'Hidalgo', 'ricardoh@gmail.com', '12345', NULL),
(13, 'CARLOS ALBERTO', 'ANGULO PIZARRO', 'cangulo009@outlook.es', '1234', 'lemomemebelike-lemomeme.gif'),
(14, 'Usuario1', 'Usuario', 'usuario1@gmail.com', '12345', NULL),
(15, 'Pepito', 'Montero', 'pepito@gmail.com', '12345', NULL);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `groups`
--
ALTER TABLE `groups`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_group_id` (`id`);

--
-- Indices de la tabla `group_chats`
--
ALTER TABLE `group_chats`
  ADD PRIMARY KEY (`id`),
  ADD KEY `group_id` (`group_id`);

--
-- Indices de la tabla `group_tasks`
--
ALTER TABLE `group_tasks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `group_id` (`group_id`),
  ADD KEY `user_email` (`user_email`),
  ADD KEY `assigned_user_email` (`assigned_user_email`);

--
-- Indices de la tabla `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `tasks`
--
ALTER TABLE `tasks`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_email` (`email`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `groups`
--
ALTER TABLE `groups`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `group_chats`
--
ALTER TABLE `group_chats`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT de la tabla `group_tasks`
--
ALTER TABLE `group_tasks`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT de la tabla `tasks`
--
ALTER TABLE `tasks`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `group_chats`
--
ALTER TABLE `group_chats`
  ADD CONSTRAINT `group_chats_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `group_tasks`
--
ALTER TABLE `group_tasks`
  ADD CONSTRAINT `group_tasks_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`),
  ADD CONSTRAINT `group_tasks_ibfk_2` FOREIGN KEY (`user_email`) REFERENCES `users` (`email`),
  ADD CONSTRAINT `group_tasks_ibfk_3` FOREIGN KEY (`assigned_user_email`) REFERENCES `users` (`email`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
