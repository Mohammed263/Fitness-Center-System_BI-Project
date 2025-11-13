USE FitnessCenter;
GO

-- ================================================
-- Table: Branch
CREATE TABLE Branch (
    ID INT PRIMARY KEY,
    [Location] VARCHAR(20) ,
    OpeningDate DATE,
    ManagerID INT,
);
GO

-- ================================================
-- Table: Trainer
CREATE TABLE Trainer (
    ID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Gender VARCHAR(1),
    EmailAddress VARCHAR(50),
    PhoneNumber VARCHAR(20),
    EmploymentStatus VARCHAR(20),
    [Certificates] VARCHAR(200),
    Specialization VARCHAR(100),
    Salary float,
    HiringDate DATE
) on GymPerson
GO

-- ================================================

-- Table: TrainerSchedule

CREATE TABLE TrainerSchedule (
    TrainerID INT,
    BranchID INT,
    WeeklyShifts INT,
    Duration INT,
	StartShiftTime TIME,
    EndShiftTime TIME,
    FOREIGN KEY (TrainerID) REFERENCES Trainer(ID),
    FOREIGN KEY (BranchID) REFERENCES Branch(ID)
);
GO

-- ================================================
-- Table: Equipment
CREATE TABLE Equipment (
    ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Category VARCHAR(50),
    PurchaseDate DATE,
    [Status] VARCHAR(50),
    BranchID INT,
    FOREIGN KEY (BranchID) REFERENCES Branch(ID)
);
GO

-- ================================================
-- Table: Maintenance
CREATE TABLE Maintenance (
    ID INT PRIMARY KEY,
    Type VARCHAR(100)
);
GO

-- ================================================
-- Table: EquipmentMaintenance
CREATE TABLE EquipmentMaintenance (
    EquipmentID INT,
    MaintenanceID INT,
    [Date] DATE,
    Cost FLOAT,
    PRIMARY KEY (EquipmentID, MaintenanceID),
    FOREIGN KEY (EquipmentID) REFERENCES Equipment(ID),
    FOREIGN KEY (MaintenanceID) REFERENCES Maintenance(ID)
);
GO

-- ================================================
-- Table: Staff
CREATE TABLE Staff (
    ID INT PRIMARY KEY,
    Name VARCHAR(100),
    DateOfBirth DATE,
    Gender VARCHAR(10),
    JobPosition VARCHAR(100),
    PhoneNumber VARCHAR(20),
    EmailAddress VARCHAR(100),
    Salary FLOAT,
    HiringDate DATE,
    StartShiftTime TIME,
    EndShiftTime TIME,
    EmploymentStatus VARCHAR(50),
    BranchID INT,
    FOREIGN KEY (BranchID) REFERENCES Branch(ID)
)on GymPerson
GO

-- ================================================
-- Table: Facility
CREATE TABLE Facility (
    ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Capacity INT,
    AvailabilityStatus VARCHAR(20),
    BranchID INT,
    FOREIGN KEY (BranchID) REFERENCES Branch(ID)
);
GO

-- ================================================
-- Table: Supplier
CREATE TABLE Supplier (
    ID INT PRIMARY KEY,
    Name VARCHAR(100),
    ContactNumber VARCHAR(20),
    EmailAddress VARCHAR(100),
    [Status] VARCHAR(50),
    City VARCHAR(100),
    Country VARCHAR(100)
);
GO

-- ================================================
-- Table: Supplies

CREATE TABLE Supplies (
    SupplierID INT,
    BranchID INT,
    Name VARCHAR(100),
    Quantity INT,
    Price DECIMAL(10,2),
	PurchaseDate Date,
    PRIMARY KEY (SupplierID, BranchID, PurchaseDate),
    FOREIGN KEY (SupplierID) REFERENCES Supplier(ID),
    FOREIGN KEY (BranchID) REFERENCES Branch(ID)
);
GO

-- ================================================
-- Table: Trainee
CREATE TABLE Trainee (
    ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Gender VARCHAR(10),
    BirthDate DATE,
    PhoneNumber VARCHAR(20),
    EmailAddress VARCHAR(100),
    BranchID INT,
    FOREIGN KEY (BranchID) REFERENCES Branch(ID)
)on GymPerson
GO

-- ================================================
-- Table: TraineeHealthCondition
CREATE TABLE TraineeHealthCondition (
    TraineeID INT,
    HealthCondition VARCHAR(200),
    PRIMARY KEY (TraineeID, HealthCondition),
    FOREIGN KEY (TraineeID) REFERENCES Trainee(ID)
);
GO

-- ================================================
-- Table: TraineeAttendance
CREATE TABLE TraineeAttendance (
    TraineeID INT,
    BranchID INT,
    [DateTime] DATETIME,
    PRIMARY KEY (TraineeID, BranchID, [DateTime]),
    FOREIGN KEY (TraineeID) REFERENCES Trainee(ID),
    FOREIGN KEY (BranchID) REFERENCES Branch(ID)
);
GO

-- ================================================
-- Table: Feedback
CREATE TABLE Feedback (
    ID INT PRIMARY KEY,
    [Description] VARCHAR(200)
);
GO

-- ================================================
-- Table: TraineeFeedback
CREATE TABLE TraineeFeedback (
    TraineeID INT,
    FeedbackID INT,
    Date DATE,
    Rating INT,
    PRIMARY KEY (TraineeID, FeedbackID,Date),
    FOREIGN KEY (TraineeID) REFERENCES Trainee(ID),
    FOREIGN KEY (FeedbackID) REFERENCES Feedback(ID)
);
GO

-- ================================================
-- Table: MembershipPackages
CREATE TABLE MembershipPackages (
    ID INT PRIMARY KEY,
    Name VARCHAR(100),
    NoOfMonths INT,
    NutritionSessions INT,
    PTSessions INT,
    Classes INT,
    Spa INT,
    NoOfInvitations INT,
    Price FLOAT,
    FreezableDays INT
);
GO

-- ================================================
-- Table: TraineeSubscription
CREATE TABLE TraineeSubscription (
    TraineeID INT,
    MembershipID INT,
    [Status] VARCHAR(50),
    StartDate DATE,
    ExpiryDate DATE,
    PRIMARY KEY (TraineeID, MembershipID,StartDate),
    FOREIGN KEY (TraineeID) REFERENCES Trainee(ID),
    FOREIGN KEY (MembershipID) REFERENCES MembershipPackages(ID)
);
GO

-- ================================================
-- Table: TraineeBodyDetails
CREATE TABLE TraineeBodyDetails (
    TraineeID INT,
    TrainerID INT,
	[Date] Date,
    Height Float,
    [Weight] Float,
    ChestSize Float,
    FatPercentage Float,
    WaistSize Float,
    HipSize Float,
    MuscleMass Float,
    Goal VARCHAR(100),
    PRIMARY KEY (TraineeID, TrainerID),
    FOREIGN KEY (TraineeID) REFERENCES Trainee(ID),
    FOREIGN KEY (TrainerID) REFERENCES Trainer(ID)
);
GO

-- ================================================
-- Table: Freeze
CREATE TABLE Freeze (
    TraineeID INT,
    MembershipID INT,
	TakenFreezes INT,
    StartDate DATE,
    EndDate DATE,
    RemainingFreezes INT,
    PRIMARY KEY (TraineeID, MembershipID),
    FOREIGN KEY (TraineeID) REFERENCES Trainee(ID),
    FOREIGN KEY (MembershipID) REFERENCES MembershipPackages(ID)
);
GO

-- ================================================
-- Table: PaymentDetails
CREATE TABLE PaymentDetails (
    TraineeID INT,
    MembershipID INT,
	BranchID INT,
	[Date] DATE,
    InvoiceNumber VARCHAR(20),
    PaymentMethod VARCHAR(50),
    TotalAmount FLOAT,
    PRIMARY KEY (TraineeID, MembershipID, BranchID, [Date]),
    FOREIGN KEY (TraineeID) REFERENCES Trainee(ID),
    FOREIGN KEY (MembershipID) REFERENCES MembershipPackages(ID),
	FOREIGN KEY (BranchID) REFERENCES Branch(ID)
);
GO

-- ================================================
-- Adding Foreign Key(ManagerID) from Staff Table 
ALTER TABLE Branch
ADD CONSTRAINT FK_Branch_Manager
FOREIGN KEY (ManagerID) REFERENCES Staff(ID);
GO

ALTER TABLE Branch
DROP CONSTRAINT FK_Branch_Manager;



-- ========================================================================================================

ALTER TABLE Trainer
DROP CONSTRAINT FK__Trainer__BranchI__398D8EEE;

DROP TABLE IF EXISTS Trainer;

SELECT name AS ConstraintName, parent_object_id
FROM sys.foreign_keys
WHERE parent_object_id = OBJECT_ID('Trainer');

ALTER TABLE Trainer
DROP COLUMN BranchID;

ALTER TABLE Trainer
ADD Seniority VARCHAR(20);

ALTER TABLE Supplies
DROP COLUMN Category;

ALTER TABLE Supplies
ADD PurchaseDate Date;

ALTER TABLE Supplies
DROP CONSTRAINT PK__Supplies__01F0E46EA04C6A43;

ALTER TABLE Supplies
ADD CONSTRAINT PK_Supplies PRIMARY KEY (SupplierID, BranchID, PurchaseDate);

ALTER TABLE Supplies
ALTER COLUMN PurchaseDate DATE NOT NULL;


ALTER TABLE TraineeHealthCondition
DROP CONSTRAINT PK__Supplies__01F0E46EA04C6A43;

