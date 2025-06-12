-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 12, 2025 at 04:47 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `thinquizsystem`
--

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `id` int(11) NOT NULL,
  `student_id` int(11) DEFAULT NULL,
  `quiz_id` int(11) DEFAULT NULL,
  `comment` text DEFAULT NULL,
  `rating` int(11) DEFAULT NULL CHECK (`rating` >= 1 and `rating` <= 5),
  `submitted_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `feedback`
--

INSERT INTO `feedback` (`id`, `student_id`, `quiz_id`, `comment`, `rating`, `submitted_at`) VALUES
(1, 1, 2, 'best', 4, '2025-06-12 14:36:58');

-- --------------------------------------------------------

--
-- Table structure for table `questions`
--

CREATE TABLE `questions` (
  `id` int(11) NOT NULL,
  `questionText` text DEFAULT NULL,
  `questionType` varchar(50) DEFAULT NULL,
  `optionA` text DEFAULT NULL,
  `optionB` text DEFAULT NULL,
  `optionC` text DEFAULT NULL,
  `optionD` text DEFAULT NULL,
  `correctAnswer` varchar(599) DEFAULT NULL,
  `timeLimit` int(11) DEFAULT NULL,
  `marks` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `questions`
--

INSERT INTO `questions` (`id`, `questionText`, `questionType`, `optionA`, `optionB`, `optionC`, `optionD`, `correctAnswer`, `timeLimit`, `marks`) VALUES
(1, 'haiwan yang comel', 'mcq', 'kucing', 'katak', 'kuda', 'arnab', 'A', 20, 2),
(2, 'ibu negeri malaysia', 'mcq', 'kuala lumpur', 'kedah', 'selangor', 'putrajaya', 'A', 20, 3);

-- --------------------------------------------------------

--
-- Table structure for table `quiz`
--

CREATE TABLE `quiz` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `quiz`
--

INSERT INTO `quiz` (`id`, `title`, `created_by`, `created_at`) VALUES
(1, 's1', 2, '2025-06-12 14:01:02'),
(2, 's1', 2, '2025-06-12 14:01:52');

-- --------------------------------------------------------

--
-- Table structure for table `quiz_questions`
--

CREATE TABLE `quiz_questions` (
  `quiz_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `quiz_questions`
--

INSERT INTO `quiz_questions` (`quiz_id`, `question_id`) VALUES
(1, 1),
(2, 1);

-- --------------------------------------------------------

--
-- Table structure for table `student_answers`
--

CREATE TABLE `student_answers` (
  `id` int(11) NOT NULL,
  `submission_id` int(11) DEFAULT NULL,
  `question_id` int(11) DEFAULT NULL,
  `student_answer` text DEFAULT NULL,
  `score` int(11) DEFAULT 0,
  `teacher_comment` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_answers`
--

INSERT INTO `student_answers` (`id`, `submission_id`, `question_id`, `student_answer`, `score`, `teacher_comment`) VALUES
(1, 1, 1, 'A', 2, NULL),
(2, 2, 1, 'A', 2, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `student_submissions`
--

CREATE TABLE `student_submissions` (
  `id` int(11) NOT NULL,
  `student_id` int(11) DEFAULT NULL,
  `quiz_id` int(11) DEFAULT NULL,
  `submission_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `total_score` int(11) DEFAULT 0,
  `evaluated` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_submissions`
--

INSERT INTO `student_submissions` (`id`, `student_id`, `quiz_id`, `submission_time`, `total_score`, `evaluated`) VALUES
(1, 1, 1, '2025-06-12 14:08:53', 0, 1),
(2, 1, 2, '2025-06-12 14:36:48', 2, 0);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `role` enum('student','teacher') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`) VALUES
(1, 'cut', 'cut@gmail.com', '123456', 'student'),
(2, 'nurul', 'nurul@gmail.com', '123456', 'teacher');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `quiz_id` (`quiz_id`);

--
-- Indexes for table `questions`
--
ALTER TABLE `questions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `quiz`
--
ALTER TABLE `quiz`
  ADD PRIMARY KEY (`id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `quiz_questions`
--
ALTER TABLE `quiz_questions`
  ADD PRIMARY KEY (`quiz_id`,`question_id`),
  ADD KEY `question_id` (`question_id`);

--
-- Indexes for table `student_answers`
--
ALTER TABLE `student_answers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `submission_id` (`submission_id`),
  ADD KEY `question_id` (`question_id`);

--
-- Indexes for table `student_submissions`
--
ALTER TABLE `student_submissions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `quiz_id` (`quiz_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `questions`
--
ALTER TABLE `questions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `quiz`
--
ALTER TABLE `quiz`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `student_answers`
--
ALTER TABLE `student_answers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `student_submissions`
--
ALTER TABLE `student_submissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `feedback`
--
ALTER TABLE `feedback`
  ADD CONSTRAINT `feedback_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `feedback_ibfk_2` FOREIGN KEY (`quiz_id`) REFERENCES `quiz` (`id`);

--
-- Constraints for table `quiz`
--
ALTER TABLE `quiz`
  ADD CONSTRAINT `quiz_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `quiz_questions`
--
ALTER TABLE `quiz_questions`
  ADD CONSTRAINT `quiz_questions_ibfk_1` FOREIGN KEY (`quiz_id`) REFERENCES `quiz` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `quiz_questions_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `student_answers`
--
ALTER TABLE `student_answers`
  ADD CONSTRAINT `student_answers_ibfk_1` FOREIGN KEY (`submission_id`) REFERENCES `student_submissions` (`id`),
  ADD CONSTRAINT `student_answers_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`);

--
-- Constraints for table `student_submissions`
--
ALTER TABLE `student_submissions`
  ADD CONSTRAINT `student_submissions_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `student_submissions_ibfk_2` FOREIGN KEY (`quiz_id`) REFERENCES `quiz` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
