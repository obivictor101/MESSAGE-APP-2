-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 01, 2023 at 12:03 PM
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
-- Database: `messageapp`
--

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  `message` longblob NOT NULL,
  `encryption_key` longblob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`id`, `sender_id`, `receiver_id`, `message`, `encryption_key`) VALUES
(1, 1, 2, 0xbd3d4058b90130c2bdc95a6ee21cbbc1192a9ff4647d8c87850c8bb87a7d7acb, 0x3559d18c4f52006bbaa06ad8ac05c6b45842af5eafe37976f89ae23552b91a503732dd5270e9f69797105c852c94743435dc100d3b7c04263e6f620ad14c4f794db71c40a8ae03300e7b3cd2ce41bab55dc01eec0204b99e0ecc410f61793fea98a89fcbac98c5c16106064627b5b0e6abb2dcb9554968864d228f1ddb4dcff8977c7b20b81b9dc34f4e53cb9c640187331804eec265fe6c93e29a2b917d5c5c24c3d88e78be6f426519c8c2b03d9f0e5e3b981e3f149f90b2f399d0449a1fdac4ae90d965d60fbed25dff5ef9a18c92406366319b78a76eb421312879d06ae790a7d60148af2ac524d02d7be1ee4dac666e87404c1a89bd78fcc5fd6f0fe169),
(2, 2, 1, 0x0b92b644a1120551530be7312e177dc082bca0da1234bc1df106a2a6eaae10d2, 0x115e7d7821cc992e009c7f735d9f4d94fa2cdb9ae20382b2f1221afc7bb2e84818e84679c854e5a1071ebccfb9727bb37092ba8246ee6da94ad63f23585709daf4fb88f39b34a21c10e6dee36dbfa3cfdd6fb8cb565868cf183f531fee05e96418e97caff230f386ce6e0346247307c0787ea79b4b0b54b06b2f484f6e5dfd1872cabf87a7591a96f8f70291a91cb89e9985dfe38e40dededa7d729e0b8ad2091950871175df40e2d90580cc49c9f3e801932c46029cd3c95fcc366c72019afb52b9ba59c4c54f0a98265be2e6efc7660a4a401a40f1564becc40abd5f49dc6e1e4fc0be8e6fa09ed5e69f467c501eb6fd399352d8c943134c63fa1c9b8ebf42),
(3, 1, 2, 0x0b8d308e0a1b55efce1f6cddafdbd96085ab1440d62415ef4168babdb844dd13, 0x512b0fa5c108417c2df191ba27ecc295c3d2bdabeac3d3ce0e2270bda489d22c9a7fc8e77a584781f12aae318da5ddf52ca5f033b53e5639039b76b02f91f1e3ead74db38ca0aab7118dfd8c34e7808deaa456c520729ae08136140f1a5a1768847aa8b1184b07c6b4f0942998e7421423e7b35d3febe594256bb7e29f902fcd0114ddd10017e6f70d89f0a9e2c3d1adf803d50092a497fc6e211787123bbe200ea782abac7b3f5f194e9930570a528dda9032e1191363e20d067bf15dea303b9c89e63e712eb5c273f8164dbd08f5653664ec73191b53f3ec2393191c6cd8bd42fef1719349e3cbbf1a20ab863838fdb164af95688c8c92a83390f82a283b74);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(128) NOT NULL,
  `rsa_public_key` text NOT NULL,
  `rsa_private_key` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `username`, `password_hash`, `rsa_public_key`, `rsa_private_key`) VALUES
(1, 'testuser1', 'testuser1', '$2b$12$9cAqk.gLGxZi29SOSgSsU.c6ZyIJLhUWkpd9dYRbjrS8Vxfyf9VcG', '-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkzfEIwY/LoK2ogMwxUrE\n4+I1niDYz5yYJwt6UAcavLbPXhpjBTWfNxJ0rkhVnEWS7Vc/gkKptXOJFfxrcxUg\nnOlGfTZNg8eHLoM7o3Seg+fQrinG4zwpAlB93oEwozMVG7Yab/jJ64auqzYB8awI\nS2NNA+rLCvRSwldegveizy1Vvs2+6LfGyG7kJyCHN/vF5+gG9yzqsFvXjmtqPMFM\nhKL1JpTpZrlSgaN0Ut3yINjTHxZ86d7Yag+fAydxo1xMjFtMKTWc1Zob6lCqmbbl\nK+RcD/FcLtk+47rNuxhwUHeC3M+LbHup9NuG8kICeSNvhn3M7I6wQtNfL1hPBuDG\nyQIDAQAB\n-----END PUBLIC KEY-----\n', '-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCTN8QjBj8ugrai\nAzDFSsTj4jWeINjPnJgnC3pQBxq8ts9eGmMFNZ83EnSuSFWcRZLtVz+CQqm1c4kV\n/GtzFSCc6UZ9Nk2Dx4cugzujdJ6D59CuKcbjPCkCUH3egTCjMxUbthpv+Mnrhq6r\nNgHxrAhLY00D6ssK9FLCV16C96LPLVW+zb7ot8bIbuQnIIc3+8Xn6Ab3LOqwW9eO\na2o8wUyEovUmlOlmuVKBo3RS3fIg2NMfFnzp3thqD58DJ3GjXEyMW0wpNZzVmhvq\nUKqZtuUr5FwP8Vwu2T7jus27GHBQd4Lcz4tse6n024byQgJ5I2+GfczsjrBC018v\nWE8G4MbJAgMBAAECggEANzYiYmpM1sIiAWfF6jAM4FQtfKTf+xjE/VuyHwJTFjRP\nWAD4YvNFx28uAFDTfpyfKlDe2hjrMchnQK4elBX32bEpBPuRHZt+iMSh4L7zVg/h\n9PdpBj7BOIN8eS6lUYduYqqshpLdE2464q4KE5tLrw5KS25KgMy5nvYKVX7O+fh6\nYxWmSlCid6PvpXDb1iiyM3N80GRt8YNvnDU9UZAxsgHtrFFotyAkrjegrreXpce1\nxvlIaF/uk4gAs+NnF4NrGD/3LKkx0koo2cVDICm/yZoIJIAjTRlGyDS4xJvsbYfw\nhzML1Ketxkyb1SogOx+itoL5tzQ6ei0IgnNFI9r/swKBgQDKVgo6KO9xca+6o5ax\nUW+Qosg2VlD2dp12l8nyzhGH1cAOGBwcwgqG6X5cbwwfiHuxZLZM0QBn8B7PAfou\nM6tCuYQ6CwBOwqVTsVdZ6oF2pCps/U1e13BqT2S4wLsIXIOxgw9mBTOpAY9at6hF\nfw48zXxAszzUrTpzrNiGWaUnpwKBgQC6Q2Bk/17gqmKTKR2CpgB38v7IyAzzY0BJ\nQDKeP4j2VmOLOYogGmrF4f+udvqXOj/2Va6mXrO3DYjCFym+P2JE64TvIB2avQBn\ni62G71QYh7JqngDyHbzKtfkyIg6HPezpX2vM2mJQc/PM2FsS4y4mgkPN5HbiIwPg\nOtY82d9sDwKBgGqj8F3450ImRhUbVTf9kMxtTxJ8ac2MdK9ljtV+0HSELuX+xQpP\nJtc2RxgWmxAfkfnL990CprEhOEuoYiBpsRDI0Cz7UV0xb4ttw3krhLJwEcBBvL6I\n08HkOFS7l5fvkqVDSyFdCn4/yTtp4rFGJs3bC2raTOxWpKEE71XX95ivAoGAEu2t\n6hWZirNF+TaAbTp5abcj9Tt/NWysp8UCX9qNDJuS2h8qzkBhAWMKHKyyopOk1F+4\ns+eD0+JoN3ErKM5AKkjU5YgZ+hOi6uLi64d+wE9p7jPIXNJw0RjVDicv2saMQNsV\nlWfL/ekKqZKDDtRPaFJsmYvSGQD979eK1fw+HDkCgYBVZRF/paRK3zDMPHRvG2Ma\no6OPeHz55WJkGcbuQ/nBXH7cWCfUEneslx3qMuOC/t2mHvBwQirTfyNN4xy6AiFh\nK6sV0OL9ozS60XnBuHAGJScpV6QfOvDJnRidOaWywTrsr1QoonR/EMorpsuu8LtP\nxc9IGUHHCCMznFxHt/ZYDw==\n-----END PRIVATE KEY-----\n'),
(2, 'testuser2', 'testuser2', '$2b$12$DKf.62rx3t0B6GRrEcm5qumsebGpiFL/8qd5iRRVGVkDX7O8MBsY2', '-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1YNjmd6Eh4Z7UQaSZAMH\ndhkOtZmsS61E9WABYDaQSLl2GsbE44fgGYPCdHCe0v3WGXyh7q2K0uiIozI4ykI+\nkRC1nhe64DubuFivaFuj/4trixwVOY6y2KLc9SzYfCr3akVbqlxpBTS/jCS9piQu\n7EhqdsnzMwwXtYRxflMrRJAFdfIUvdeb5z/5liUud32x4vglQndZPJfxtBqxU6zF\nvw6PR3hXitz7Nr+dDlRX+KGzpga9gH6UTi4jussty7zpV6gr1SZmKNfKpkaSKSlQ\ns9muwBhFLbF1HYZlcCkaA8UJC8RtAmBsTKbtZdBoFXg9uhMqmapx2k4AXGG5/aAa\n6wIDAQAB\n-----END PUBLIC KEY-----\n', '-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDVg2OZ3oSHhntR\nBpJkAwd2GQ61maxLrUT1YAFgNpBIuXYaxsTjh+AZg8J0cJ7S/dYZfKHurYrS6Iij\nMjjKQj6RELWeF7rgO5u4WK9oW6P/i2uLHBU5jrLYotz1LNh8KvdqRVuqXGkFNL+M\nJL2mJC7sSGp2yfMzDBe1hHF+UytEkAV18hS915vnP/mWJS53fbHi+CVCd1k8l/G0\nGrFTrMW/Do9HeFeK3Ps2v50OVFf4obOmBr2AfpROLiO6yy3LvOlXqCvVJmYo18qm\nRpIpKVCz2a7AGEUtsXUdhmVwKRoDxQkLxG0CYGxMpu1l0GgVeD26EyqZqnHaTgBc\nYbn9oBrrAgMBAAECggEANGAtNCcaMpaiNH+ctIzrrSQ7b//Y/J1t/5VD8SKhZT2d\ng7cDwF7p8chZELA5vb9H4Guq235VwiQJtKLSvIbgizximPvwOyZULjYPHVXxlnPQ\nd0j1ye8/3xWgh0IvftIZbEfEUzelCYJlhI7UuOdCXXLsLuSeVITgYgYxww/K2t/Y\nqJFUIiNIlC2RGpt03KJ1vr5z8EehTmn4JcFmAV0vWNOiXXlw0GChn0z43FM5dcns\niRlD4hLWRb639o6CVojFXHha1jkrcj31WZPZRY/Vw2sVlcQ9JdXR37pmxUqV9dkS\n1mYKAMCM7Y/Kno/3TUV5LgHGd/FVPvx/4cjE9yuYZQKBgQD1bATFXGmAGJu2900+\npadqIB3VD2vTxxAY2J+wtB9c7pv6mhYHgOL+2bNX4ZQpIr3jcAHtc6E/RYpx6p9C\ncIYKEwsbbCmpNP9Jr63xzJiZlVs3zNSir8FcXoycYNtYy7D/ulEzxZgWkCO25KL7\nQpxudQDM4xCLtfgxado8llrB1wKBgQDet0pRc4NS314KGppR5K+OLmIsO0zpSwaF\nPNB6Qu+oBBCpcLWQ5E0wIASp++s4eimN/80cfs3lfFu5Lnkes73H4UbrSEmZkjO8\n8qjrPrbdHAMmcxR0JPSyASSYwnclFCM3g4RFiryq9YhMNg4lEy2/Ja+//e1kjGbV\nRcjmr1t1DQKBgQCUN/R5rWIZ9sK0MY75Mtp1AYiC0JlygVp7Zviqo139pi2Vn9GG\nHpT5DUl+3cG5Rj4gSdkgKyFLMRh3zBb67TJGi1G98gkHI/a57dvDmKjguI8qmA4j\nYroIqyGIoAZZDkuLZl78QW2k0tB++H5l+Mi4/PjKxKeNeQy36xHeXX/aaQKBgQCv\nP4kCOKPgZRUJXE+MGyes+ICVj4AAnuGdm/HsEpmkGrbFrYOhZJP8R2WEIE/B3Baw\nvtU2E+2OI2HFgHUcHJE8I977KqGHbwy5JDSZD3sy12T/L1Sr45yMKOwULAk2qvbf\nKuS9F+NHnvbGCU7uC35Wx5/YskXHdddBAK2KH/gWTQKBgQCCjaDoUQUoCeQ4MR3S\nX17lwJO2raQZ1jO9pJxa2qbtaSN5S1BlsfRlH4ZT2m6FNv9cec3IFlZrBGA9fwA1\ntKcNBsSgv95nKPDX7t5cMvb/xvtLnE9peAUuMIKlZ8Kpl9EHluBHQQp8T6TuIQbz\nCDk9odsFRcRQQmqEvQFcFmdMkw==\n-----END PRIVATE KEY-----\n');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sender_id` (`sender_id`),
  ADD KEY `receiver_id` (`receiver_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
