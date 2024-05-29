-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 02-05-2024 a las 21:12:34
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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `groups`
--

CREATE TABLE `groups` (
  `id` int NOT NULL,
  `group_name` varchar(255) NOT NULL,
  `group_members` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;




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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;





-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notifications`
--

CREATE TABLE `notifications` (
  `id` int NOT NULL,
  `email` varchar(250) NOT NULL,
  `notification` text NOT NULL,
  `status` enum('Activa','Inactiva') NOT NULL DEFAULT 'Activa'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `tasks`
--

INSERT INTO `tasks` (`id`, `email`, `title`, `description`, `status`, `date_task`, `group_id`, `updated_at`) VALUES
(3, 'prueba6@gmail.com', 'Hola mundo', '123456', 'Pendiente', '2024-01-18 05:00:00', NULL, '2024-04-05 02:02:35'),
(7, 'prueba8@gmail.com', 'Prueba8', 'Hola prueba 8', 'Pendiente', '2024-01-20 05:00:00', NULL, '2024-04-05 02:02:35'),
(9, 'ricardoh@gmail.com', 'Hola mundo', 'Hola mundo', 'Pendiente', '2024-02-10 05:00:00', NULL, '2024-04-05 02:02:35'),
(10, 'ricardoh@gmail.com', 'XD', 'XD', 'Pendiente', '2024-03-01 05:00:00', NULL, '2024-04-05 02:02:35'),
(11, 'ricardoh@gmail.com', 'nnm nm', 'hiuhiuhui', 'Pendiente', '2024-03-02 05:00:00', NULL, '2024-04-05 02:02:35'),
(13, 'prueba7@gmail.com', 'Hola', 'Hola', 'Terminado', '2024-03-27 05:00:00', NULL, '2024-04-05 02:02:35'),
(14, 'ricardo@gmail.com', 'kimokdsm', 'kasmdkm', 'Terminado', '2024-03-27 05:00:00', NULL, '2024-04-05 02:02:35'),
(16, 'cangulo009@outlook.es', 'hgfhfg', 'gfdgdfgf', 'Terminado', '2024-03-27 05:00:00', NULL, '2024-04-05 02:02:35'),
(17, 'cangulo009@outlook.es', 'AAAA', 'BBBBBB', 'Terminado', '2024-03-29 05:00:00', NULL, '2024-04-05 02:02:35'),
(18, 'cangulo009@outlook.es', 'AAA', 'BBBBBBBB', 'Pendiente', '2024-03-29 05:00:00', NULL, '2024-04-05 02:02:35'),
(19, 'cangulo009@outlook.es', 'ca', 'sdas', 'Pendiente', '2024-03-31 05:00:00', NULL, '2024-04-05 02:02:35'),
(20, 'cangulo009@outlook.es', '4324', '34234', 'Pendiente', '2024-03-31 05:00:00', NULL, '2024-04-05 02:02:35'),
(23, 'ricardo@gmail.com', 'Otra cosa', 'Prueba', 'Pospuesto', '2024-03-31 05:00:00', NULL, '2024-04-10 01:03:11'),
(24, 'prueba7@gmail.com', 'n kjnk', 'jknkjnj', 'Pendiente', '2024-04-02 05:00:00', NULL, '2024-04-05 02:02:35'),
(25, 'ricardo@gmail.com', 'Mundial', 'AHHHHHHHHHHHHHHHHHHHHHHHH', 'Terminado', '2024-04-02 05:00:00', NULL, '2024-04-05 02:02:35'),
(28, 'cangulo009@outlook.es', 'gffdgfd', 'gfdgdf', 'Pendiente', '2024-04-04 05:00:00', NULL, '2024-04-05 02:02:35'),
(30, 'cangulo009@outlook.es', 'jhgjgh', 'jhgjghj', 'Pendiente', '2024-04-09 05:00:00', NULL, '2024-04-10 02:24:31'),
(31, 'cangulo009@outlook.es', 'dfdfgfd', 'gfdgdfgfd', 'Pendiente', '2024-04-20 05:00:00', NULL, '2024-04-21 01:12:19');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `name`, `surnames`, `email`, `password`, `profile_image`) VALUES
(1, 'ricardo', 'hidalgo', 'ricardo@gmail.com', '12345', '1e802ba5-28ac-4816-b627-be005c046fed0401c27f-8c57-4516-a75a-f7cc9d32b112.png'),
(5, 'Prueba', 'prueba', 'prueba@gmail.com', '12345', NULL),
(6, 'prueba2', 'prueba2', 'prueba2@gmail.com', '12345', NULL),
(7, 'prueba3', 'prueb3', 'prueba3@gmail.com', '1234', NULL),
(8, 'prueba4', 'p', 'prueba4@gmail.com', '12345', NULL),
(9, 'prueba6', 'p', 'prueba6@gmail.com', '123456', NULL),
(10, 'prueba7', 'P7', 'prueba7@gmail.com', '12345', NULL),
(11, 'Prueba8', 'P8', 'prueba8@gmail.com', '12345', NULL),
(12, 'Ricardo', 'Hidalgo', 'ricardoh@gmail.com', '12345', NULL),
(13, 'CARLOS ALBERTO', 'ANGULO PIZARRO', 'cangulo009@outlook.es', '1234', 'lemomemebelike-lemomeme.gif'),
(14, 'Usuario1', 'Usuario', 'usuario1@gmail.com', '12345', NULL);

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
  ADD PRIMARY KEY (`id`),
  ADD KEY `email_idx` (`email`);

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
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT de la tabla `group_tasks`
--
ALTER TABLE `group_tasks`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT de la tabla `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tasks`
--
ALTER TABLE `tasks`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `group_tasks`
--
ALTER TABLE `group_tasks`
  ADD CONSTRAINT `group_tasks_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`),
  ADD CONSTRAINT `group_tasks_ibfk_2` FOREIGN KEY (`user_email`) REFERENCES `users` (`email`),
  ADD CONSTRAINT `group_tasks_ibfk_3` FOREIGN KEY (`assigned_user_email`) REFERENCES `users` (`email`);

--
-- Filtros para la tabla `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`email`) REFERENCES `users` (`email`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
