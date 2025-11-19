
--trainee (Add-update-bodydetails-attendance-feedback-health-subscription-freeze-payment)
--trainer (Add-update-schedule-certificates)
--staff   ((Add-update)
--Membership (Add-update-delete)
--supplier ((Add-update)
--supplies ((Add-update)
--Equipment ((Add-update,equipmentmaintenance)
--Maintenance (Add-update-delete)
--Branch   (Add-update-delete)
--Facility  (Add-update-delete)
--Feedback (Add-update-delete)

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------


-- SP to add trainee with his health condition and his body details
CREATE OR ALTER PROCEDURE Add_Trainee
    @ID INT,
    @Name VARCHAR(100) = NULL,
    @Gender VARCHAR(10) = NULL,
    @BirthDate DATE = NULL,
    @PhoneNumber VARCHAR(20) = NULL,
    @EmailAddress VARCHAR(100) = NULL,
    @BranchID INT = NULL,
    @HealthCondition VARCHAR(200) = NULL,
    @MembershipID INT = NULL,
    @StartDate DATE = NULL,
    @ExpiryDate DATE = NULL,
    @TrainerID INT = NULL,
    @Height FLOAT = NULL,
    @Weight FLOAT = NULL,
    @ChestSize FLOAT = NULL,
    @FatPercentage FLOAT = NULL,
    @WaistSize FLOAT = NULL,
    @HipSize FLOAT = NULL,
    @MuscleMass FLOAT = NULL,
    @Goal VARCHAR(100) = NULL,
    @InvoiceNumber VARCHAR(20) = NULL,
    @PaymentMethod VARCHAR(50) = NULL,
    @TotalAmount FLOAT = NULL
AS
BEGIN

    -- 1. Check if Trainee exists
    IF NOT EXISTS (SELECT 1 FROM Trainee WHERE ID = @ID)
    BEGIN
        -- Insert Trainee
        INSERT INTO Trainee (ID, Name, Gender, BirthDate, PhoneNumber, EmailAddress, BranchID)
        VALUES (@ID, @Name, @Gender, @BirthDate, @PhoneNumber, @EmailAddress, @BranchID);

        -- Insert Health Condition if provided
        IF @HealthCondition IS NOT NULL
        BEGIN
            INSERT INTO TraineeHealthCondition (TraineeID, HealthCondition)
            VALUES (@ID, @HealthCondition);
        END

        -- Insert Body Details if at least one value exists
        IF @TrainerID IS NOT NULL AND
           (@Height IS NOT NULL OR @Weight IS NOT NULL OR @ChestSize IS NOT NULL OR @FatPercentage IS NOT NULL
            OR @WaistSize IS NOT NULL OR @HipSize IS NOT NULL OR @MuscleMass IS NOT NULL OR @Goal IS NOT NULL)
        BEGIN
            INSERT INTO TraineeBodyDetails
                (TraineeID, TrainerID, [Date], Height, [Weight], ChestSize, FatPercentage, WaistSize, HipSize, MuscleMass, Goal)
            VALUES
                (@ID, @TrainerID, @StartDate, @Height, @Weight, @ChestSize, @FatPercentage, @WaistSize, @HipSize, @MuscleMass, @Goal);
        END

        -- Insert Trainee Subscription if provided
        IF @MembershipID IS NOT NULL AND @StartDate IS NOT NULL AND @ExpiryDate IS NOT NULL
        BEGIN
            INSERT INTO TraineeSubscription (TraineeID, MembershipID, [Status], StartDate, ExpiryDate)
            VALUES (@ID, @MembershipID, 'Active', @StartDate, @ExpiryDate);
        END

        -- Insert Payment Details if provided
        IF @MembershipID IS NOT NULL AND @StartDate IS NOT NULL AND @InvoiceNumber IS NOT NULL
        BEGIN
            INSERT INTO PaymentDetails (TraineeID, MembershipID, BranchID, [Date], InvoiceNumber, PaymentMethod, TotalAmount)
            VALUES (@ID, @MembershipID, @BranchID, @StartDate, @InvoiceNumber, @PaymentMethod, @TotalAmount);
        END
    END
    ELSE
    BEGIN
        -- Trainee exists → just insert Health Condition and/or Body Details

        -- Health Condition
        IF @HealthCondition IS NOT NULL
        BEGIN
            INSERT INTO TraineeHealthCondition (TraineeID, HealthCondition)
            VALUES (@ID, @HealthCondition);
        END

        -- Body Details
        IF @TrainerID IS NOT NULL AND
           (@Height IS NOT NULL OR @Weight IS NOT NULL OR @ChestSize IS NOT NULL OR @FatPercentage IS NOT NULL
            OR @WaistSize IS NOT NULL OR @HipSize IS NOT NULL OR @MuscleMass IS NOT NULL OR @Goal IS NOT NULL)
        BEGIN
            INSERT INTO TraineeBodyDetails
                (TraineeID, TrainerID, [Date], Height, [Weight], ChestSize, FatPercentage, WaistSize, HipSize, MuscleMass, Goal)
            VALUES
                (@ID, @TrainerID, GETDATE(), @Height, @Weight, @ChestSize, @FatPercentage, @WaistSize, @HipSize, @MuscleMass, @Goal);
        END
    END
END;


----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

-- SP to update trainee with his health condition and his body details

CREATE OR ALTER PROCEDURE Update_Trainee
    @ID INT,
    @Name VARCHAR(100) = NULL,
    @Gender VARCHAR(10) = NULL,
    @BirthDate DATE = NULL,
    @PhoneNumber VARCHAR(20) = NULL,
    @EmailAddress VARCHAR(100) = NULL,
    @BranchID INT = NULL,
    @HealthCondition VARCHAR(200) = NULL,
    @TrainerID INT = NULL,
    @Height FLOAT = NULL,
    @Weight FLOAT = NULL,
    @ChestSize FLOAT = NULL,
    @FatPercentage FLOAT = NULL,
    @WaistSize FLOAT = NULL,
    @HipSize FLOAT = NULL,
    @MuscleMass FLOAT = NULL,
    @Goal VARCHAR(100) = NULL,
    @MembershipID INT = NULL,
    @StartDate DATE = NULL,
    @ExpiryDate DATE = NULL,
    @InvoiceNumber VARCHAR(20) = NULL,
    @PaymentMethod VARCHAR(50) = NULL,
    @TotalAmount FLOAT = NULL
AS
BEGIN

    -- 1. Check if Trainee exists
    IF NOT EXISTS (SELECT 1 FROM Trainee WHERE ID = @ID)
    BEGIN
        RAISERROR('Trainee ID not found. No update performed.', 16, 1);
        RETURN;
    END

    -- 2. Update Trainee basic info
    UPDATE Trainee
    SET Name = COALESCE(@Name, Name),
        Gender = COALESCE(@Gender, Gender),
        BirthDate = COALESCE(@BirthDate, BirthDate),
        PhoneNumber = COALESCE(@PhoneNumber, PhoneNumber),
        EmailAddress = COALESCE(@EmailAddress, EmailAddress),
        BranchID = COALESCE(@BranchID, BranchID)
    WHERE ID = @ID;

    -- 3. Update Health Condition ONLY if row exists
    IF @HealthCondition IS NOT NULL AND
       EXISTS (SELECT 1 FROM TraineeHealthCondition WHERE TraineeID = @ID AND HealthCondition = @HealthCondition)
  

    -- 4. Update Body Details ONLY if row exists
    IF @TrainerID IS NOT NULL AND
       (@Height IS NOT NULL OR @Weight IS NOT NULL OR @ChestSize IS NOT NULL OR @FatPercentage IS NOT NULL
        OR @WaistSize IS NOT NULL OR @HipSize IS NOT NULL OR @MuscleMass IS NOT NULL OR @Goal IS NOT NULL)
       AND EXISTS (SELECT 1 FROM TraineeBodyDetails WHERE TraineeID = @ID AND TrainerID = @TrainerID)
    BEGIN
        UPDATE TraineeBodyDetails
        SET Height = COALESCE(@Height, Height),
            [Weight] = COALESCE(@Weight, [Weight]),
            ChestSize = COALESCE(@ChestSize, ChestSize),
            FatPercentage = COALESCE(@FatPercentage, FatPercentage),
            WaistSize = COALESCE(@WaistSize, WaistSize),
            HipSize = COALESCE(@HipSize, HipSize),
            MuscleMass = COALESCE(@MuscleMass, MuscleMass),
            Goal = COALESCE(@Goal, Goal),
            [Date] = GETDATE()
        WHERE TraineeID = @ID AND TrainerID = @TrainerID;
    END

    -- 5. Update Trainee Subscription ONLY if row exists
    IF @MembershipID IS NOT NULL AND @StartDate IS NOT NULL AND @ExpiryDate IS NOT NULL
       AND EXISTS (SELECT 1 FROM TraineeSubscription WHERE TraineeID = @ID AND MembershipID = @MembershipID AND StartDate = @StartDate)
    BEGIN
        UPDATE TraineeSubscription
        SET [Status] = 'Active',
            ExpiryDate = COALESCE(@ExpiryDate, ExpiryDate)
        WHERE TraineeID = @ID AND MembershipID = @MembershipID AND StartDate = @StartDate;
    END

    -- 6. Update Payment Details ONLY if row exists
    IF @MembershipID IS NOT NULL AND @StartDate IS NOT NULL AND @InvoiceNumber IS NOT NULL
       AND EXISTS (SELECT 1 FROM PaymentDetails WHERE TraineeID = @ID AND MembershipID = @MembershipID AND BranchID = @BranchID AND [Date] = @StartDate)
    BEGIN
        UPDATE PaymentDetails
        SET InvoiceNumber = COALESCE(@InvoiceNumber, InvoiceNumber),
            PaymentMethod = COALESCE(@PaymentMethod, PaymentMethod),
            TotalAmount = COALESCE(@TotalAmount, TotalAmount)
        WHERE TraineeID = @ID AND MembershipID = @MembershipID AND BranchID = @BranchID AND [Date] = @StartDate;
    END
END;


----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

--SP to add Trainee Attendance
CREATE OR ALTER PROCEDURE Add_TraineeAttendance
    @TraineeID INT,
    @BranchID INT
AS
BEGIN

    --  Check if Trainee not exists
    IF NOT EXISTS (SELECT 1 FROM Trainee WHERE ID = @TraineeID)
    BEGIN
        RAISERROR('Trainee ID not found. Attendance not recorded.', 16, 1);
        RETURN;
    END

    -- Insert Attendance with current date and time
    INSERT INTO TraineeAttendance (TraineeID, BranchID, [DateTime])
    VALUES (@TraineeID, @BranchID, GETDATE());
END;


----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

--SP to add & update trainee feedback
CREATE OR ALTER PROCEDURE AddOrUpdate_TraineeFeedback
    @TraineeID INT,
    @FeedbackID INT,
	@Date DATE,
    @Rating INT
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Check if Trainee exists
    IF NOT EXISTS (SELECT 1 FROM Trainee WHERE ID = @TraineeID)
    BEGIN
        RAISERROR('Trainee ID not found. Feedback not recorded.', 16, 1);
        RETURN;
    END

    -- 2. Update first 
    UPDATE TraineeFeedback
    SET Rating = @Rating
    WHERE TraineeID = @TraineeID 
      AND FeedbackID = @FeedbackID 
      AND [Date] = @Date;

    -- 3. Insert only if row not updated 
    IF @@ROWCOUNT = 0
    BEGIN
        INSERT INTO TraineeFeedback (TraineeID, FeedbackID, [Date], Rating)
        VALUES (@TraineeID, @FeedbackID, CAST(GETDATE() AS DATE), @Rating);
    END
END;



----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--SP to add & update trainee freeze
CREATE OR ALTER PROCEDURE AddOrUpdate_Freeze
    @TraineeID INT,
    @MembershipID INT,
    @TakenFreezes INT,
    @StartDate DATE,
    @EndDate DATE,
    @RemainingFreezes INT
AS
BEGIN

    -- 1. Check if Trainee exists
    IF NOT EXISTS (SELECT 1 FROM Trainee WHERE ID = @TraineeID)
    BEGIN
        RAISERROR('Trainee ID not found. Freeze not recorded.', 16, 1);
        RETURN;
    END

    -- 2. Update if row exists
    UPDATE Freeze
    SET TakenFreezes = @TakenFreezes,
        StartDate = @StartDate,
        EndDate = @EndDate,
        RemainingFreezes = @RemainingFreezes
    WHERE TraineeID = @TraineeID AND MembershipID = @MembershipID;

    -- 3. Insert only if no row was updated
    IF @@ROWCOUNT = 0
    BEGIN
        INSERT INTO Freeze (TraineeID, MembershipID, TakenFreezes, StartDate, EndDate, RemainingFreezes)
        VALUES (@TraineeID, @MembershipID, @TakenFreezes, @StartDate, @EndDate, @RemainingFreezes);
    END
END;




-------------------------------------------------- Trainer --------------------------------------------------

------------------------- Add Trainer -------------------------

CREATE OR ALTER PROC add_trainer
    @ID INT,
    @Name VARCHAR(50),
    @Gender VARCHAR(1),
    @EmailAddress VARCHAR(50),
    @PhoneNumber VARCHAR(20),
    @EmploymentStatus VARCHAR(20),
    @Specialization VARCHAR(100),
    @Salary FLOAT,
    @HiringDate DATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Trainer WHERE ID = @ID)
    BEGIN
        THROW 50001, 'Trainer ID already exists.', 1
    END

    INSERT INTO Trainer(ID, Name, Gender, EmailAddress, PhoneNumber, EmploymentStatus, Specialization, Salary, HiringDate)
    VALUES (@ID, @Name, @Gender, @EmailAddress, @PhoneNumber, @EmploymentStatus, @Specialization, @Salary, @HiringDate)
END

------------------------- Update Trainer -------------------------

go

CREATE OR ALTER PROC update_trainer
    @ID INT,
    @Name VARCHAR(50) = NULL,
    @Gender VARCHAR(1) = NULL,
    @EmailAddress VARCHAR(50) = NULL,
    @PhoneNumber VARCHAR(20) = NULL,
    @EmploymentStatus VARCHAR(20) = NULL,
    @Specialization VARCHAR(100) = NULL,
    @Salary FLOAT = NULL,
    @HiringDate DATE = NULL
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Trainer WHERE ID = @ID)
    BEGIN
        THROW 50010, 'Trainer does not exist.', 1
    END

    UPDATE Trainer
    SET
        Name = ISNULL(@Name, Name),
        Gender = ISNULL(@Gender, Gender),
        EmailAddress = ISNULL(@EmailAddress, EmailAddress),
        PhoneNumber = ISNULL(@PhoneNumber, PhoneNumber),
        EmploymentStatus = ISNULL(@EmploymentStatus, EmploymentStatus),
        Specialization = ISNULL(@Specialization, Specialization),
        Salary = ISNULL(@Salary, Salary),
        HiringDate = ISNULL(@HiringDate, HiringDate)
    WHERE ID = @ID
END

------------------------- Add Trainer Schedule -------------------------

go

CREATE OR ALTER PROC add_trainer_schedule
    @TrainerID INT,
    @BranchID INT,
    @WeeklyShifts INT,
    @Duration INT,
    @StartShiftTime TIME,
    @EndShiftTime TIME
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Trainer WHERE ID = @TrainerID)
    BEGIN
        THROW 50002, 'Trainer ID does not exist.', 1
    END

    INSERT INTO TrainerSchedule(TrainerID, BranchID, WeeklyShifts, Duration, StartShiftTime, EndShiftTime)
    VALUES (@TrainerID, @BranchID, @WeeklyShifts, @Duration, @StartShiftTime, @EndShiftTime)
END

------------------------- Update Trainer Schedule -------------------------

go

CREATE OR ALTER PROC update_trainer_schedule
    @TrainerID INT,
    @BranchID INT = NULL,
    @WeeklyShifts INT = NULL,
    @Duration INT = NULL,
    @StartShiftTime TIME = NULL,
    @EndShiftTime TIME = NULL
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM TrainerSchedule WHERE TrainerID = @TrainerID)
    BEGIN
        THROW 50011, 'Trainer schedule does not exist.', 1
    END

    UPDATE TrainerSchedule
    SET
        BranchID = ISNULL(@BranchID, BranchID),
        WeeklyShifts = ISNULL(@WeeklyShifts, WeeklyShifts),
        Duration = ISNULL(@Duration, Duration),
        StartShiftTime = ISNULL(@StartShiftTime, StartShiftTime),
        EndShiftTime = ISNULL(@EndShiftTime, EndShiftTime)
    WHERE TrainerID = @TrainerID;
END

------------------------- Add Trainer Certificate -------------------------

go

CREATE OR ALTER PROC add_trainer_certificate
    @TrainerID INT,
    @Certificate VARCHAR(200)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Trainer WHERE ID = @TrainerID)
    BEGIN
        THROW 50003, 'Trainer ID does not exist.', 1
    END

    INSERT INTO TrainerCertificates(TrainerID, Certificates)
    VALUES (@TrainerID, @Certificate)
END

------------------------- Update Trainer Certificate -------------------------
go

CREATE OR ALTER PROC update_trainer_certificate
    @TrainerID INT,
    @Certificate VARCHAR(200)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM TrainerSchedule WHERE TrainerID = @TrainerID)
    BEGIN
        THROW 50011, 'Trainer Certificate does not exist.', 1
    END

    UPDATE TrainerCertificates
    SET Certificates = @Certificate
    WHERE TrainerID = @TrainerID
END

----------------------------------------------------------------------------------------------------

-------------------------------------------------- Staff --------------------------------------------------

------------------------- Add Staff Member -------------------------

go

CREATE OR ALTER PROC add_staff_member
    @ID INT,
    @Name VARCHAR(50),
    @DateOfBirth DATE,
    @Gender VARCHAR(1),
    @JobPosition VARCHAR(100),
    @PhoneNumber VARCHAR(20),
    @EmailAddress VARCHAR(100),
    @Salary FLOAT,
    @HiringDate DATE,
    @StartShiftTime TIME,
    @EndShiftTime TIME,
    @EmploymentStatus VARCHAR(50),
    @BranchID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Staff WHERE ID = @ID)
    BEGIN
        THROW 50011, 'Staff ID already exists.', 1
    END

    INSERT INTO Staff
    (ID, Name, DateOfBirth, Gender, JobPosition, PhoneNumber, EmailAddress, Salary,
     HiringDate, StartShiftTime, EndShiftTime, EmploymentStatus, BranchID)
    VALUES
    (@ID, @Name, @DateOfBirth, @Gender, @JobPosition, @PhoneNumber, @EmailAddress,
     @Salary, @HiringDate, @StartShiftTime, @EndShiftTime, @EmploymentStatus, @BranchID)
END

------------------------- Update Staff Member -------------------------

go

CREATE OR ALTER PROC update_staff_member
    @ID INT,
    @Name VARCHAR(50) = NULL,
    @DateOfBirth DATE = NULL,
    @Gender VARCHAR(1) = NULL,
    @JobPosition VARCHAR(100) = NULL,
    @PhoneNumber VARCHAR(20) = NULL,
    @EmailAddress NVARCHAR(100) = NULL,
    @Salary FLOAT = NULL,
    @HiringDate DATE = NULL,
    @StartShiftTime TIME = NULL,
    @EndShiftTime TIME = NULL,
    @EmploymentStatus VARCHAR(50) = NULL,
    @BranchID INT = NULL
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Staff WHERE ID = @ID)
    BEGIN
        THROW 50012, 'Staff ID does not exist.', 1
    END

    UPDATE Staff
    SET
        Name = ISNULL(@Name, Name),
        DateOfBirth = ISNULL(@DateOfBirth, DateOfBirth),
        Gender = ISNULL(@Gender, Gender),
        JobPosition = ISNULL(@JobPosition, JobPosition),
        PhoneNumber = ISNULL(@PhoneNumber, PhoneNumber),
        EmailAddress = ISNULL(@EmailAddress, EmailAddress),
        Salary = ISNULL(@Salary, Salary),
        HiringDate = ISNULL(@HiringDate, HiringDate),
        StartShiftTime = ISNULL(@StartShiftTime, StartShiftTime),
        EndShiftTime = ISNULL(@EndShiftTime, EndShiftTime),
        EmploymentStatus = ISNULL(@EmploymentStatus, EmploymentStatus),
        BranchID = ISNULL(@BranchID, BranchID)
    WHERE ID = @ID
END

----------------------------------------------------------------------------------------------------

-------------------------------------------------- Membership Package --------------------------------------------------

------------------------- Add Membership Package -------------------------

go

CREATE OR ALTER PROC add_membership_package
    @ID INT,
    @Name VARCHAR(100),
    @NoOfMonths INT,
    @NutritionSessions INT,
    @PTSessions INT,
    @Classes INT,
    @Spa INT,
    @NoOfInvitations INT,
    @Price FLOAT,
    @FreezableDays INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM MembershipPackages WHERE ID = @ID)
    BEGIN
        THROW 50031, 'Membership Package ID already exists.', 1;
    END

    INSERT INTO MembershipPackages
    (ID, Name, NoOfMonths, NutritionSessions, PTSessions, Classes, Spa, NoOfInvitations, Price, FreezableDays)
    VALUES
    (@ID, @Name, @NoOfMonths, @NutritionSessions, @PTSessions, @Classes, @Spa, @NoOfInvitations, @Price, @FreezableDays)
END

------------------------- Update Membership Package -------------------------

go

CREATE OR ALTER PROC update_membership_package
    @ID INT,
    @Name VARCHAR(100) = NULL,
    @NoOfMonths INT = NULL,
    @NutritionSessions INT = NULL,
    @PTSessions INT = NULL,
    @Classes INT = NULL,
    @Spa INT = NULL,
    @NoOfInvitations INT = NULL,
    @Price FLOAT = NULL,
    @FreezableDays INT = NULL
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM MembershipPackages WHERE ID = @ID)
    BEGIN
        THROW 50032, 'Membership Package ID does not exist.', 1;
    END

    UPDATE MembershipPackages
    SET
        Name              = ISNULL(@Name, Name),
        NoOfMonths        = ISNULL(@NoOfMonths, NoOfMonths),
        NutritionSessions = ISNULL(@NutritionSessions, NutritionSessions),
        PTSessions        = ISNULL(@PTSessions, PTSessions),
        Classes           = ISNULL(@Classes, Classes),
        Spa               = ISNULL(@Spa, Spa),
        NoOfInvitations   = ISNULL(@NoOfInvitations, NoOfInvitations),
        Price             = ISNULL(@Price, Price),
        FreezableDays     = ISNULL(@FreezableDays, FreezableDays)
    WHERE ID = @ID
END

------------------------- Delete Membership Package -------------------------

go

CREATE OR ALTER PROC delete_membership_package
    @ID INT
AS
BEGIN
    
    IF NOT EXISTS (SELECT 1 FROM MembershipPackages WHERE ID = @ID)
    BEGIN
        THROW 50032, 'Membership Package ID does not exist.', 1
    END

    -- Delete
    DELETE FROM MembershipPackages
    WHERE ID = @ID
END

----------------------------------------------------------------------------------------------------

-------------------------------------------------- Supplier --------------------------------------------------

------------------------- Add Supplier -------------------------

go

CREATE OR ALTER PROC add_supplier
    @ID INT,
    @Name VARCHAR(100),
    @ContactNumber VARCHAR(20),
    @EmailAddress VARCHAR(100),
    @Status VARCHAR(50),
    @City VARCHAR(100),
    @Country VARCHAR(100)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Supplier WHERE ID = @ID)
    BEGIN
        THROW 50041, 'Supplier ID already exists.', 1;
    END

    INSERT INTO Supplier
    (ID, Name, ContactNumber, EmailAddress, Status, City, Country)
    VALUES
    (@ID, @Name, @ContactNumber, @EmailAddress, @Status, @City, @Country)
END

------------------------- Update Supplier -------------------------

go 

CREATE OR ALTER PROC update_supplier
    @ID INT,
    @Name VARCHAR(100) = NULL,
    @ContactNumber VARCHAR(20) = NULL,
    @EmailAddress VARCHAR(100) = NULL,
    @Status VARCHAR(50) = NULL,
    @City VARCHAR(100) = NULL,
    @Country VARCHAR(100) = NULL
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Supplier WHERE ID = @ID)
    BEGIN
        THROW 50042, 'Supplier ID does not exist.', 1;
    END

    UPDATE Supplier
    SET
        Name          = ISNULL(@Name, Name),
        ContactNumber = ISNULL(@ContactNumber, ContactNumber),
        EmailAddress  = ISNULL(@EmailAddress, EmailAddress),
        Status        = ISNULL(@Status, Status),
        City          = ISNULL(@City, City),
        Country       = ISNULL(@Country, Country)
    WHERE ID = @ID
END

----------------------------------------------------------------------------------------------------

-------------------------------------------------- Supplies --------------------------------------------------

------------------------- Add Supplies -------------------------

go

CREATE OR ALTER PROC add_supplies
    @SupplierID INT,
    @BranchID INT,
    @Name VARCHAR(100),
    @Quantity INT,
    @Price FLOAT,
    @PurchaseDate DATE
AS
BEGIN
    INSERT INTO Supplies(SupplierID, BranchID, Name, Quantity, Price, PurchaseDate)
    VALUES (@SupplierID, @BranchID, @Name, @Quantity, @Price, @PurchaseDate)
END

------------------------- Update Supplies -------------------------

go

CREATE OR ALTER PROC update_supplies
    @SupplierID INT,
    @BranchID INT,
    @Name VARCHAR(100),
    @Quantity INT,
    @Price FLOAT,
    @PurchaseDate DATE
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM Supplies
        WHERE SupplierID = @SupplierID
          AND BranchID   = @BranchID
          AND Name       = @Name
          AND PurchaseDate = @PurchaseDate
    )
    BEGIN
        THROW 50003, 'Supplies record not found.', 1
    END

    UPDATE Supplies
    SET Quantity = @Quantity,
        Price = @Price
    WHERE SupplierID = @SupplierID
      AND BranchID   = @BranchID
      AND Name       = @Name
      AND PurchaseDate = @PurchaseDate
END

----------------------------------------------------------------------------------------------------

-- ================================================
-- SP: Add Branch
-- ================================================

CREATE OR ALTER PROCEDURE AddBranch
    @ID INT,
    @Location VARCHAR(20),
    @OpeningDate DATE,
    @ManagerID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if Branch already exists
    IF EXISTS (SELECT 1 FROM Branch WHERE ID = @ID)
    BEGIN
        RAISERROR('Branch with this ID already exists.', 16, 1);
        RETURN;
    END

    INSERT INTO Branch (ID, [Location], OpeningDate, ManagerID)
    VALUES (@ID, @Location, @OpeningDate, @ManagerID);

    SELECT 'Branch added successfully.' AS Message;
END;

GO
-- ================================================
-- SP: Update Branch
-- ================================================
CREATE OR ALTER PROCEDURE UpdateBranch
    @ID INT,
    @Location VARCHAR(20) = NULL,
    @OpeningDate DATE = NULL,
    @ManagerID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Validation
    IF NOT EXISTS (SELECT 1 FROM Branch WHERE ID = @ID)
    BEGIN
        RAISERROR('Branch not found.', 16, 1);
        RETURN;
    END

    UPDATE Branch
    SET 
        [Location]   = ISNULL(@Location, [Location]),
        OpeningDate  = ISNULL(@OpeningDate, OpeningDate),
        ManagerID    = ISNULL(@ManagerID, ManagerID)
    WHERE ID = @ID;

    SELECT 'Branch updated successfully.' AS Message;
END;
GO

-- ================================================
-- SP: Delete Branch
-- ================================================
CREATE OR ALTER PROCEDURE DeleteBranch
    @ID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Branch WHERE ID = @ID)
    BEGIN
        RAISERROR('Branch not found.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        DELETE FROM Branch WHERE ID = @ID;

        COMMIT TRANSACTION;

        SELECT 'Branch deleted successfully.' AS Message;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        RAISERROR('Cannot delete Branch because it has related records.', 16, 1);
    END CATCH
END;
GO
-- ================================================
-- SP: Add Facility
-- ================================================
CREATE OR ALTER PROCEDURE AddFacility
    @ID INT,
    @Name VARCHAR(100),
    @Capacity INT,
    @AvailabilityStatus VARCHAR(20),
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Facility WHERE ID = @ID)
    BEGIN
        RAISERROR('Facility with this ID already exists.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Branch WHERE ID = @BranchID)
    BEGIN
        RAISERROR('BranchID does not exist.', 16, 1);
        RETURN;
    END

    INSERT INTO Facility (ID, Name, Capacity, AvailabilityStatus, BranchID)
    VALUES (@ID, @Name, @Capacity, @AvailabilityStatus, @BranchID);

    SELECT 'Facility added successfully.' AS Message;
END;
GO
-- ================================================
-- SP: update Facility
-- ================================================
CREATE OR ALTER PROCEDURE UpdateFacility
    @ID INT,
    @Name VARCHAR(100) = NULL,
    @Capacity INT = NULL,
    @AvailabilityStatus VARCHAR(20) = NULL,
    @BranchID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Facility WHERE ID = @ID)
    BEGIN
        RAISERROR('Facility not found.', 16, 1);
        RETURN;
    END

    IF @BranchID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Branch WHERE ID = @BranchID)
    BEGIN
        RAISERROR('New BranchID does not exist.', 16, 1);
        RETURN;
    END

    UPDATE Facility
    SET
        Name = ISNULL(@Name, Name),
        Capacity = ISNULL(@Capacity, Capacity),
        AvailabilityStatus = ISNULL(@AvailabilityStatus, AvailabilityStatus),
        BranchID = ISNULL(@BranchID, BranchID)
    WHERE ID = @ID;

    SELECT 'Facility updated successfully.' AS Message;
END;
GO
-- ================================================
-- SP: Delete Facility
-- ================================================
CREATE OR ALTER PROCEDURE DeleteFacility
    @ID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Facility WHERE ID = @ID)
    BEGIN
        RAISERROR('Facility not found.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        DELETE FROM Facility WHERE ID = @ID;

        COMMIT TRANSACTION;

        SELECT 'Facility deleted successfully.' AS Message;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        RAISERROR('Cannot delete Facility due to related records.', 16, 1);
    END CATCH
END;
GO
-- ================================================
-- SP: Add Feedback
-- ================================================
CREATE OR ALTER PROCEDURE AddFeedback
    @ID INT,
    @Description VARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Feedback WHERE ID = @ID)
    BEGIN
        RAISERROR('Feedback with this ID already exists.', 16, 1);
        RETURN;
    END

    INSERT INTO Feedback (ID, [Description])
    VALUES (@ID, @Description);

    SELECT 'Feedback added successfully.' AS Message;
END;
GO
-- ================================================
-- SP: Update Feedback
-- ================================================
CREATE OR ALTER PROCEDURE UpdateFeedback
    @ID INT,
    @Description VARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Feedback WHERE ID = @ID)
    BEGIN
        RAISERROR('Feedback not found.', 16, 1);
        RETURN;
    END

    UPDATE Feedback
    SET [Description] = ISNULL(@Description, [Description])
    WHERE ID = @ID;

    SELECT 'Feedback updated successfully.' AS Message;
END;
GO
-- ================================================
-- SP: Delete Feedback
-- ================================================
CREATE OR ALTER PROCEDURE DeleteFeedback
    @ID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Feedback WHERE ID = @ID)
    BEGIN
        RAISERROR('Feedback not found.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Delete dependent records first (important)
        DELETE FROM TraineeFeedback WHERE FeedbackID = @ID;

        DELETE FROM Feedback WHERE ID = @ID;

        COMMIT TRANSACTION;

        SELECT 'Feedback deleted successfully.' AS Message;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        RAISERROR('Cannot delete Feedback due to related records.', 16, 1);
    END CATCH
END;
GO
-- ================================================
-- SP: Add Equipment
-- ================================================
CREATE OR ALTER PROCEDURE AddEquipment
    @ID INT,
    @Name VARCHAR(100),
    @Category VARCHAR(50),
    @PurchaseDate DATE,
    @Status VARCHAR(50),
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Equipment WHERE ID = @ID)
    BEGIN
        RAISERROR('Equipment with this ID already exists.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Branch WHERE ID = @BranchID)
    BEGIN
        RAISERROR('BranchID does not exist.', 16, 1);
        RETURN;
    END

    INSERT INTO Equipment (ID, Name, Category, PurchaseDate, [Status], BranchID)
    VALUES (@ID, @Name, @Category, @PurchaseDate, @Status, @BranchID);

    SELECT 'Equipment added successfully.' AS Message;
END;
GO
-- ================================================
-- SP: Update Equipment
-- ================================================
CREATE OR ALTER PROCEDURE UpdateEquipment
    @ID INT,
    @Name VARCHAR(100) = NULL,
    @Category VARCHAR(50) = NULL,
    @PurchaseDate DATE = NULL,
    @Status VARCHAR(50) = NULL,
    @BranchID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Equipment WHERE ID = @ID)
    BEGIN
        RAISERROR('Equipment not found.', 16, 1);
        RETURN;
    END

    IF @BranchID IS NOT NULL 
       AND NOT EXISTS (SELECT 1 FROM Branch WHERE ID = @BranchID)
    BEGIN
        RAISERROR('New BranchID does not exist.', 16, 1);
        RETURN;
    END

    UPDATE Equipment
    SET 
        Name = ISNULL(@Name, Name),
        Category = ISNULL(@Category, Category),
        PurchaseDate = ISNULL(@PurchaseDate, PurchaseDate),
        [Status] = ISNULL(@Status, [Status]),
        BranchID = ISNULL(@BranchID, BranchID)
    WHERE ID = @ID;

    SELECT 'Equipment updated successfully.' AS Message;
END;
GO
-- ================================================
-- SP: Add Equipment Maintenance
-- ================================================
CREATE OR ALTER PROCEDURE AddEquipmentMaintenance
    @EquipmentID INT,
    @MaintenanceID INT,
    @Date DATE,
    @Cost FLOAT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check Equipment
    IF NOT EXISTS (SELECT 1 FROM Equipment WHERE ID = @EquipmentID)
    BEGIN
        RAISERROR('EquipmentID does not exist.', 16, 1);
        RETURN;
    END

    -- Check Maintenance
    IF NOT EXISTS (SELECT 1 FROM Maintenance WHERE ID = @MaintenanceID)
    BEGIN
        RAISERROR('MaintenanceID does not exist.', 16, 1);
        RETURN;
    END

    -- Check for duplicates
    IF EXISTS (SELECT 1 FROM EquipmentMaintenance 
               WHERE EquipmentID = @EquipmentID AND MaintenanceID = @MaintenanceID)
    BEGIN
        RAISERROR('This Equipment-Maintenance record already exists.', 16, 1);
        RETURN;
    END

    INSERT INTO EquipmentMaintenance (EquipmentID, MaintenanceID, [Date], Cost)
    VALUES (@EquipmentID, @MaintenanceID, @Date, @Cost);

    SELECT 'Equipment maintenance added successfully.' AS Message;
END;
GO
-- ================================================
-- SP: Add Maintenance
-- ================================================
CREATE OR ALTER PROCEDURE AddMaintenance
    @ID INT,
    @Type VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Maintenance WHERE ID = @ID)
    BEGIN
        RAISERROR('Maintenance with this ID already exists.', 16, 1);
        RETURN;
    END

    INSERT INTO Maintenance (ID, Type)
    VALUES (@ID, @Type);

    SELECT 'Maintenance added successfully.' AS Message;
END;
GO
-- ================================================
-- SP: Update Maintenance
-- ================================================
CREATE OR ALTER PROCEDURE UpdateMaintenance
    @ID INT,
    @Type VARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Maintenance WHERE ID = @ID)
    BEGIN
        RAISERROR('Maintenance not found.', 16, 1);
        RETURN;
    END

    UPDATE Maintenance
    SET 
        Type = ISNULL(@Type, Type)
    WHERE ID = @ID;

    SELECT 'Maintenance updated successfully.' AS Message;
END;
GO
-- ================================================
-- SP: Delete Maintenance
-- ================================================
CREATE OR ALTER PROCEDURE DeleteMaintenance
    @ID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Maintenance WHERE ID = @ID)
    BEGIN
        RAISERROR('Maintenance not found.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        DELETE FROM EquipmentMaintenance WHERE MaintenanceID = @ID;
        DELETE FROM Maintenance WHERE ID = @ID;

        COMMIT TRANSACTION;

        SELECT 'Maintenance deleted successfully.' AS Message;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        RAISERROR('Cannot delete maintenance due to related records.', 16, 1);
    END CATCH
END;
GO



