
-- Trainer

-- Add Trainer

EXEC add_trainer
    @ID = 1,
    @Name = 'Ahmed Ali',
    @Gender = 'M',
    @EmailAddress = 'ahmed@example.com',
    @PhoneNumber = '01000000000',
    @EmploymentStatus = 'Active',
    @Specialization = 'Fitness Coach',
    @Salary = 12000,
    @HiringDate = '2023-01-10';

--- Update Trainer

EXEC update_trainer
    @ID = 1,
    @PhoneNumber = '01011111111',
    @Salary = 15000;

-- Add Trainer Schedule

EXEC add_trainer_schedule
    @TrainerID = 1,
    @BranchID = 10,
    @WeeklyShifts = 5,
    @Duration = 60,
    @StartShiftTime = '09:00',
    @EndShiftTime = '15:00';

-- Update Trainer Schedule

EXEC update_trainer_schedule
    @TrainerID = 1,
    @WeeklyShifts = 6,
    @EndShiftTime = '16:00';

-- Add Trainer Certificate

EXEC add_trainer_certificate
    @TrainerID = 1,
    @Certificate = 'ACE Certified Personal Trainer';

-- Update Trainer Certificate

EXEC update_trainer_certificate
    @TrainerID = 3,
    @Certificate = 'AWS Solutions Architect Associate';

-- Staff

-- Add Staff Member

EXEC add_staff_member
    @ID = 101,
    @Name = 'Sara Mohamed',
    @DateOfBirth = '1995-05-10',
    @Gender = 'F',
    @JobPosition = 'Receptionist',
    @PhoneNumber = '01022222222',
    @EmailAddress = 'sara@example.com',
    @Salary = 8000,
    @HiringDate = '2022-03-05',
    @StartShiftTime = '08:00',
    @EndShiftTime = '16:00',
    @EmploymentStatus = 'Active',
    @BranchID = 2;

-- Update Staff Member

EXEC update_staff_member
    @ID = 101,
    @PhoneNumber = '01033333333',
    @Salary = 9000;

-- Membership Package

-- Add Membership Package

EXEC add_membership_package
    @ID = 1,
    @Name = 'Premium Package',
    @NoOfMonths = 12,
    @NutritionSessions = 8,
    @PTSessions = 20,
    @Classes = 50,
    @Spa = 1,
    @NoOfInvitations = 5,
    @Price = 12000,
    @FreezableDays = 30;

-- Update Membership Package

EXEC update_membership_package
    @ID = 1,
    @Price = 14000,
    @Classes = 60;

-- Delete Membership Package

EXEC delete_membership_package @ID = 3;

-- Supplier

-- Add Supplier

EXEC add_supplier
    @ID = 200,
    @Name = 'FitPro Supplies',
    @ContactNumber = '0123456789',
    @EmailAddress = 'info@fitpro.com',
    @Status = 'Active',
    @City = 'Cairo',
    @Country = 'Egypt';

-- Update Supplier

EXEC update_supplier
    @ID = 200,
    @Status = 'Inactive',
    @City = 'Giza';

-- Supplies

-- Add Supplies

EXEC add_supplies
    @SupplierID = 200,
    @BranchID = 3,
    @Name = 'Dumbbells Set',
    @Quantity = 20,
    @Price = 3500,
    @PurchaseDate = '2024-01-05';

-- Update Supplies

EXEC update_supplies
    @SupplierID = 200,
    @BranchID = 3,
    @Name = 'Dumbbells Set',
    @Quantity = 25,
    @Price = 3600,
    @PurchaseDate = '2024-01-05';

------------------------------------------------------------------------------

EXEC AddBranch 
    @ID = 500,
    @Location = 'Cairo',
    @OpeningDate = '2021-06-01',
    @ManagerID = 60002;

-------------------------
EXEC UpdateBranch 
    @ID = 500,
    @Location = 'Giza',        -- or NULL to ignore
    @OpeningDate = NULL,
    @ManagerID = 60003;
----------------------------
EXEC DeleteBranch 
    @ID = 500;
------------------------
EXEC AddFacility
    @ID = 10,
    @Name = 'Gym Hall',
    @Capacity = 50,
    @AvailabilityStatus = 'Available',
    @BranchID = 1;
-------------------------
EXEC UpdateFacility
    @ID = 10,
    @Name = 'Gym Hall Updated',
    @Capacity = NULL,
    @AvailabilityStatus = 'Unavailable',
    @BranchID = NULL;
-------------------------
EXEC DeleteFacility
    @ID = 10;
----------------------
EXEC AddFeedback
    @ID = 200,
    @Description = 'training environment.';
------------------------------
EXEC UpdateFeedback
    @ID = 200,
    @Description = 'Facilities are excellent.';
-------------------------------
EXEC DeleteFeedback
    @ID = 200;
-----------------------------------
EXEC AddEquipment
    @ID = 300,
    @Name = 'Treadmill',
    @Category = 'Cardio',
    @PurchaseDate = '2023-01-10',
    @Status = 'Working',
    @BranchID = 1;
------------------------------------
EXEC UpdateEquipment
    @ID = 300,
    @Name = 'Treadmill Pro',
    @Category = NULL,
    @PurchaseDate = NULL,
    @Status = 'Under Maintenance',
    @BranchID = NULL;
---------------------------------
EXEC AddEquipmentMaintenance
    @EquipmentID = 300,
    @MaintenanceID = 20,
    @Date = '2024-02-15',
    @Cost = 450.75;
--------------------------------
EXEC AddMaintenance
    @ID = 20,
    @Type = 'Monthly Inspection';
-------------------------------
EXEC UpdateMaintenance
    @ID = 20,
    @Type = 'Quarterly Inspection';
----------------------
EXEC DeleteMaintenance
    @ID = 20;
----------------------------