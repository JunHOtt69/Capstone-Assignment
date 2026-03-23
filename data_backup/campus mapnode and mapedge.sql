SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;


REPLACE INTO `campus_mapedge` (`id`, `from_node_id`, `to_node_id`) VALUES
(1, 1, 10),
(2, 10, 11),
(3, 2, 11),
(4, 11, 12),
(5, 12, 13),
(6, 13, 14),
(7, 14, 25),
(8, 14, 15),
(9, 15, 3),
(10, 12, 16),
(11, 16, 19),
(12, 19, 6),
(13, 19, 24),
(14, 16, 17),
(15, 17, 4),
(16, 17, 18),
(17, 18, 5),
(18, 19, 20),
(19, 20, 7),
(20, 20, 21),
(21, 21, 22),
(22, 22, 8),
(23, 22, 23),
(24, 23, 9);

REPLACE INTO `campus_mapnode` (`id`, `node_id`, `name`, `node_type`, `x`, `y`) VALUES
(1, 'N1', 'Classroom 1', 'terminal', 170, 158),
(2, 'N2', 'Classroom 2', 'terminal', 263, 157),
(3, 'N4', 'Classroom 4', 'terminal', 729, 101),
(4, 'N5', 'Classroom 5', 'terminal', 568, 216),
(5, 'N6', 'Classroom 6', 'terminal', 731, 215),
(6, 'N7', 'Auditorium 1', 'terminal', 470, 290),
(7, 'N8', 'Audiotorium 2', 'terminal', 469, 467),
(8, 'N9', 'Lab 2', 'terminal', 261, 506),
(9, 'N10', 'Lab 1', 'terminal', 168, 508),
(10, 'N11', 'Pathway N11', 'pathway', 170, 180),
(11, 'N12', 'Pathway N12', 'pathway', 262, 180),
(12, 'N13', 'Pathway N13', 'pathway', 434, 179),
(13, 'N14', 'Pathway N14', 'pathway', 433, 124),
(14, 'N15', 'Pathway N15', 'pathway', 567, 124),
(15, 'N16', 'Pathway N16', 'pathway', 731, 124),
(16, 'N17', 'Pathway N17', 'pathway', 434, 237),
(17, 'N18', 'Pathway N18', 'pathway', 568, 238),
(18, 'N19', 'Pathway N19', 'pathway', 729, 238),
(19, 'N20', 'Pathway N20', 'pathway', 434, 290),
(20, 'N21', 'Pathway N21', 'pathway', 434, 467),
(21, 'N22', 'Pathway N22', 'pathway', 434, 532),
(22, 'N23', 'Pathway N23', 'pathway', 262, 533),
(23, 'N24', 'Pathway N24', 'pathway', 168, 533),
(24, 'N25', 'Cafeteria', 'terminal', 395, 290),
(25, 'N26', 'Classroom 3', 'terminal', 568, 101);
SET FOREIGN_KEY_CHECKS=1;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
