CREATE DATABASE [FitnessCenter]
ON 
PRIMARY
(
    NAME = N'FitnessCenter_data',
    FILENAME = N'D:\ITI\Graduation Project\DataBase\FitnessCenter_data.mdf',
    SIZE = 50MB,
    FILEGROWTH = 10MB
),
FILEGROUP [GymPerson]
(
    NAME = N'GymPerson_data',
    FILENAME = N'D:\ITI\Graduation Project\DataBase\GymPerson_data.ndf',
    SIZE = 50MB,
    FILEGROWTH = 10MB
)
LOG ON
(
    NAME = N'FitnessCenter_log',
    FILENAME = N'D:\ITI\Graduation Project\DataBase\FitnessCenter_log.ldf',
    SIZE = 10MB,
    FILEGROWTH = 5MB
);


