-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 17, 2024 at 08:52 AM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `efhan`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_log`
--

CREATE TABLE `activity_log` (
  `ActivityLogID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `ActionType` varchar(50) NOT NULL,
  `ResourceType` varchar(50) NOT NULL,
  `ResourceID` varchar(50) NOT NULL,
  `Description` text DEFAULT NULL,
  `ActionDate` datetime DEFAULT current_timestamp(),
  `IP_Address` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `activity_log`
--

INSERT INTO `activity_log` (`ActivityLogID`, `UserID`, `ActionType`, `ResourceType`, `ResourceID`, `Description`, `ActionDate`, `IP_Address`) VALUES
(0, 1, 'Add Book', 'Book', '17', 'New book added: THE MONKEY AND KING', '2024-12-16 02:51:54', '::1'),
(0, 1, 'Add Book', 'Book', '18', 'New book added: THE MONKEY AND KING', '2024-12-16 03:48:15', '::1'),
(0, 1, 'Add Book', 'Book', '19', 'New book added: THE MONKEY AND KING', '2024-12-16 04:14:45', '::1'),
(0, 1, 'Add Periodical', 'Periodical', '39', 'Periodical added: bahala na ni', '2024-12-16 05:41:53', '::1'),
(0, 1, 'Add Media Resource', 'MediaResource', '40', 'Media resource added: mao nani', '2024-12-16 05:44:47', '::1'),
(0, 3, 'Add User', 'User', '3', 'User added: Divina efhan', '2024-12-16 06:21:04', '::1'),
(0, 0, 'Add User', 'User', '0', 'User added: Dante Efhan', '2024-12-16 07:05:54', '::1'),
(0, 1, 'Delete User', 'User', '2', 'User deleted: Irish Efhan (Email: irish@gmail.com)', '2024-12-16 07:16:53', '::1'),
(0, 1, 'Add Media Resource', 'MediaResource', '43', 'Media resource added: wala na finish na ', '2024-12-16 13:38:43', '::1'),
(0, 1, 'Add Periodical', 'Periodical', '44', 'Periodical added: ato ni', '2024-12-16 13:41:01', '::1'),
(0, 10, 'Borrow Book', 'Book', '45', 'Borrowed book: ato ni  by Philipi', '2024-12-17 10:13:56', '::1'),
(0, 10, 'Borrow Book', 'Book', '45', 'Borrowed book: ato ni  by Philipi', '2024-12-17 10:28:32', '::1'),
(0, 1, 'Add Periodical', 'Periodical', '46', 'Periodical added: medyo ipit naman ta nai', '2024-12-17 10:34:25', '::1'),
(0, 0, 'Add User', 'User', '0', 'User added: kyami', '2024-12-17 13:55:48', '::1'),
(0, 1, 'Add Media Resource', 'MediaResource', '48', 'Media resource added: The goat and the pig', '2024-12-17 14:39:07', '::1'),
(0, 0, 'Borrow Book', 'Book', '47', 'Borrowed book: ako si cardo by dalisay', '2024-12-17 15:07:32', '::1'),
(0, 1, 'Add Periodical', 'Periodical', '49', 'Periodical added: panpan', '2024-12-17 15:28:26', '::1');

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE `books` (
  `BookID` int(11) NOT NULL,
  `ResourceID` int(11) DEFAULT NULL,
  `Title` varchar(255) NOT NULL,
  `Author` varchar(255) DEFAULT NULL,
  `Genre` varchar(100) DEFAULT NULL,
  `ISBN` varchar(50) DEFAULT NULL,
  `Publisher` varchar(255) DEFAULT NULL,
  `Edition` varchar(100) DEFAULT NULL,
  `PublicationDate` date DEFAULT NULL,
  `Quantity` int(11) DEFAULT 0,
  `Available_Quantity` int(11) DEFAULT 0,
  `AccessionNumber` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `books`
--

INSERT INTO `books` (`BookID`, `ResourceID`, `Title`, `Author`, `Genre`, `ISBN`, `Publisher`, `Edition`, `PublicationDate`, `Quantity`, `Available_Quantity`, `AccessionNumber`) VALUES
(28, 47, 'ako si cardo', 'dalisay', 'non-fiction', '1312', 'mang kanor', '3rd edition', '2012-03-20', 123, 100, '22113');

--
-- Triggers `books`
--
DELIMITER $$
CREATE TRIGGER `update_library_resources_after_book_update` AFTER UPDATE ON `books` FOR EACH ROW BEGIN
    IF NEW.Available_Quantity = 0 THEN
        UPDATE libraryResources
        SET Available = 'Not Available'
        WHERE ResourceID = NEW.ResourceID;
    ELSE
        UPDATE libraryResources
        SET Available = 'Available'
        WHERE ResourceID = NEW.ResourceID;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `borrowingtransactions`
--

CREATE TABLE `borrowingtransactions` (
  `TransactionID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `ResourceID` int(11) NOT NULL,
  `BorrowDate` date DEFAULT NULL,
  `DueDate` date DEFAULT NULL,
  `ReturnDate` date DEFAULT NULL,
  `FineAmount` decimal(10,2) DEFAULT 0.00,
  `Title` varchar(255) NOT NULL,
  `Author` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `borrow_records`
--

CREATE TABLE `borrow_records` (
  `RecordID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `ResourceID` int(11) NOT NULL,
  `BorrowDate` date NOT NULL,
  `return_date` date DEFAULT NULL,
  `Status` enum('Borrowed','Returned','Overdue') NOT NULL,
  `FineAmount` decimal(10,2) DEFAULT 0.00,
  `TransactionID` int(11) NOT NULL,
  `DueDate` date NOT NULL,
  `Title` varchar(255) NOT NULL,
  `Author` varchar(255) NOT NULL,
  `due_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `borrow_records`
--

INSERT INTO `borrow_records` (`RecordID`, `UserID`, `ResourceID`, `BorrowDate`, `return_date`, `Status`, `FineAmount`, `TransactionID`, `DueDate`, `Title`, `Author`, `due_date`) VALUES
(35, 0, 47, '2024-12-17', NULL, '', '0.00', 24, '2024-12-31', 'ako si cardo', 'dalisay', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `fines`
--

CREATE TABLE `fines` (
  `FineID` int(11) NOT NULL,
  `TransactionID` int(11) DEFAULT NULL,
  `UserID` int(11) DEFAULT NULL,
  `FineAmount` decimal(10,2) NOT NULL,
  `PaymentStatus` enum('Paid','Unpaid') NOT NULL,
  `PaymentDate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `libraryresources`
--

CREATE TABLE `libraryresources` (
  `ResourceID` int(11) NOT NULL,
  `Title` varchar(255) NOT NULL,
  `AccessionNumber` varchar(50) NOT NULL,
  `Category` enum('Book','Periodical','MediaResource') NOT NULL,
  `AcquisitionYear` year(4) NOT NULL,
  `AvailabilityStatus` enum('Available','Borrowed') NOT NULL,
  `Author` varchar(255) DEFAULT NULL,
  `available_quantity` int(11) NOT NULL DEFAULT 0,
  `AvailableQuantity` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `libraryresources`
--

INSERT INTO `libraryresources` (`ResourceID`, `Title`, `AccessionNumber`, `Category`, `AcquisitionYear`, `AvailabilityStatus`, `Author`, `available_quantity`, `AvailableQuantity`) VALUES
(47, 'ako si cardo', '22113', 'Book', 2024, 'Available', 'dalisay', 100, 0),
(48, 'The goat and the pig', '553535', 'MediaResource', 2013, 'Available', NULL, 0, 123332),
(49, 'panpan', '12345', 'Periodical', 2013, 'Available', NULL, 2324234, 0);

-- --------------------------------------------------------

--
-- Table structure for table `mediaresources`
--

CREATE TABLE `mediaresources` (
  `MediaResourceID` int(11) NOT NULL,
  `ResourceID` int(11) DEFAULT NULL,
  `Title` varchar(255) DEFAULT NULL,
  `Format` varchar(100) DEFAULT NULL,
  `Runtime` int(11) DEFAULT NULL,
  `MediaType` varchar(100) DEFAULT NULL,
  `Author` varchar(255) DEFAULT NULL,
  `Quantity` int(11) DEFAULT NULL,
  `Available_Quantity` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `mediaresources`
--

INSERT INTO `mediaresources` (`MediaResourceID`, `ResourceID`, `Title`, `Format`, `Runtime`, `MediaType`, `Author`, `Quantity`, `Available_Quantity`) VALUES
(15, 48, 'The goat and the pig', '23423342', 10, 'C1312DE', 'Reymie', 123332, 123332);

-- --------------------------------------------------------

--
-- Table structure for table `periodicals`
--

CREATE TABLE `periodicals` (
  `PeriodicalID` int(11) NOT NULL,
  `ResourceID` int(11) DEFAULT NULL,
  `Title` varchar(255) NOT NULL,
  `Author` varchar(255) NOT NULL,
  `Quantity` int(11) NOT NULL,
  `Available_Quantity` int(11) NOT NULL,
  `ISSN` varchar(50) DEFAULT NULL,
  `Volume` varchar(50) DEFAULT NULL,
  `Issue` varchar(50) DEFAULT NULL,
  `PublicationDate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `periodicals`
--

INSERT INTO `periodicals` (`PeriodicalID`, `ResourceID`, `Title`, `Author`, `Quantity`, `Available_Quantity`, `ISSN`, `Volume`, `Issue`, `PublicationDate`) VALUES
(7, 49, 'panpan', 'dalisay', 2324234, 2324234, '213123', 'was3423sad2', 'damage book', '2000-01-02');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `user_type` enum('student','faculty','staff','admin') DEFAULT 'student',
  `password` varchar(255) NOT NULL,
  `membership_id` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `fines` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `user_type`, `password`, `membership_id`, `created_at`, `updated_at`, `fines`) VALUES
(0, 'kyami', 'kyami@gmail.com', 'student', '$2y$10$BTX3ssKcoX64zrAaYLCPIOVh9QntF20KW6exfa3P2u9/WicOG1hx6', '2112', '2024-12-17 05:55:48', '2024-12-17 05:55:48', 0),
(1, 'Admin', 'admin@gmail.com', 'admin', '$2y$10$i4K5wKJOcEUhsXP9nxO32./dE/edQzH5PpeLbry/1XeZNlzq7zkTO', 'A2211600109', '2024-12-01 11:34:24', '2024-12-17 05:07:10', 0),
(3, 'Aljun', 'aljuninato@gmail.com', 'staff', '$2y$10$iBTSFFaEIftLs.6Mc9XENegm0TwlQDEjhNrgwL37/yRx6YeAnrV0W', 'F2211600109', '2024-12-01 11:38:55', '2024-12-17 05:07:35', 0),
(4, 'hahaha', 'kurikong@gmail.com', 'staff', '$2y$10$KqrTQm4Eu2MoxOXhso7rT.vyaVXSExQ6Z4jfGf4J1LeDQNVonZV62', 'Stf2211600109', '2024-12-01 11:39:46', '2024-12-17 05:08:30', 0),
(10, 'irish', 'irish1@gmail.com', 'student', '$2y$10$dk5pNqWnalnZ16Gp0uPBReTIiab3mGuMxn.Bdzb1s2z5kGRD9tqe6', 'ST1122113231', '2024-12-09 17:49:17', '2024-12-17 05:08:54', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`BookID`),
  ADD KEY `fk_books_libraryResources_new` (`ResourceID`);

--
-- Indexes for table `borrowingtransactions`
--
ALTER TABLE `borrowingtransactions`
  ADD PRIMARY KEY (`TransactionID`),
  ADD KEY `UserID` (`UserID`),
  ADD KEY `ResourceID` (`ResourceID`);

--
-- Indexes for table `borrow_records`
--
ALTER TABLE `borrow_records`
  ADD PRIMARY KEY (`RecordID`),
  ADD KEY `UserID` (`UserID`),
  ADD KEY `ResourceID` (`ResourceID`);

--
-- Indexes for table `libraryresources`
--
ALTER TABLE `libraryresources`
  ADD PRIMARY KEY (`ResourceID`);

--
-- Indexes for table `mediaresources`
--
ALTER TABLE `mediaresources`
  ADD PRIMARY KEY (`MediaResourceID`),
  ADD KEY `ResourceID` (`ResourceID`);

--
-- Indexes for table `periodicals`
--
ALTER TABLE `periodicals`
  ADD PRIMARY KEY (`PeriodicalID`),
  ADD KEY `ResourceID` (`ResourceID`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `books`
--
ALTER TABLE `books`
  MODIFY `BookID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `borrowingtransactions`
--
ALTER TABLE `borrowingtransactions`
  MODIFY `TransactionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `borrow_records`
--
ALTER TABLE `borrow_records`
  MODIFY `RecordID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `libraryresources`
--
ALTER TABLE `libraryresources`
  MODIFY `ResourceID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- AUTO_INCREMENT for table `mediaresources`
--
ALTER TABLE `mediaresources`
  MODIFY `MediaResourceID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `periodicals`
--
ALTER TABLE `periodicals`
  MODIFY `PeriodicalID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `books`
--
ALTER TABLE `books`
  ADD CONSTRAINT `books_ibfk_1` FOREIGN KEY (`ResourceID`) REFERENCES `libraryresources` (`ResourceID`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_books_libraryResources_new` FOREIGN KEY (`ResourceID`) REFERENCES `libraryresources` (`ResourceID`) ON DELETE CASCADE;

--
-- Constraints for table `borrowingtransactions`
--
ALTER TABLE `borrowingtransactions`
  ADD CONSTRAINT `fk_resource` FOREIGN KEY (`ResourceID`) REFERENCES `libraryresources` (`ResourceID`),
  ADD CONSTRAINT `fk_user` FOREIGN KEY (`UserID`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
