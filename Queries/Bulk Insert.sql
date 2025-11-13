-- ================================================

--insert Data into Branch Table
BULK INSERT Branch
FROM 'D:\ITI\Graduation Project\Data\Branch.csv'
WITH (
    FIELDTERMINATOR = ',',   
    ROWTERMINATOR = '0x0a',    
    FIRSTROW = 2             
)
select * from Branch
delete from Branch

-- ================================================

--insert Data into Trainer Table
BULK INSERT Trainer
FROM 'D:\ITI\Graduation Project\Data\Trainer.csv'
WITH (
    FIELDTERMINATOR = ',',   
    ROWTERMINATOR = '0x0a',    
    FIRSTROW = 2             
)
select * from Trainer
delete from trainer

-- ================================================

--insert Data into TrainerSchedule Table
BULK INSERT TrainerSchedule
FROM 'D:\ITI\Graduation Project\Data\TrainerSchedule.csv'
WITH (
    FIELDTERMINATOR = ',',   
    ROWTERMINATOR = '0x0a',    
    FIRSTROW = 2             
)
select * from TrainerSchedule
delete from TrainerSchedule

-- ================================================

--insert Data into Equipment Table
BULK INSERT Equipment
FROM 'D:\ITI\Graduation Project\Data\Equipment.csv'
WITH (
    FIELDTERMINATOR = ',',   
    ROWTERMINATOR = '0x0a',    
    FIRSTROW = 2             
)
select * from Equipment
delete from Equipment

-- ================================================

--insert Data into Maintenance Table
BULK INSERT Maintenance
FROM 'D:\ITI\Graduation Project\Data\Maintenance.csv'
WITH (
    FIELDTERMINATOR = ',',   
    ROWTERMINATOR = '0x0a',    
    FIRSTROW = 2             
)
select * from Maintenance
delete from Maintenance

-- ================================================

--insert Data into EquipmentMaintenance Table
BULK INSERT EquipmentMaintenance
FROM 'D:\ITI\Graduation Project\Data\EquipmentMaintenance.csv'
WITH (
    FIELDTERMINATOR = ',',   
    ROWTERMINATOR = '0x0a',    
    FIRSTROW = 2             
)
select * from EquipmentMaintenance
delete from EquipmentMaintenance
-- ================================================

--insert Data into Staff Table
BULK INSERT Staff
FROM 'D:\ITI\Graduation Project\Data\Staff.csv'
WITH (
    FIELDTERMINATOR = ',',   
    ROWTERMINATOR = '0x0a',    
    FIRSTROW = 2             
)
select * from Staff
delete from Staff

-- ================================================

--insert Data into Facility Table
BULK INSERT Facility
FROM 'D:\ITI\Graduation Project\Data\Facility.csv'
WITH (
    FIELDTERMINATOR = ',',   
    ROWTERMINATOR = '0x0a',    
    FIRSTROW = 2             
)
select * from Facility
delete from Facility
-- ================================================

--insert Data into Supplier Table
BULK INSERT Supplier
FROM 'D:\ITI\Graduation Project\Data\Supplier.csv'
WITH (
    FIELDTERMINATOR = ',',   
    ROWTERMINATOR = '0x0a',    
    FIRSTROW = 2             
)
select * from Supplier
delete from Supplier

-- ================================================

--insert Data into Supplier Table
BULK INSERT Supplies
FROM 'D:\ITI\Graduation Project\Data\Supplies.csv'
WITH (
    FIELDTERMINATOR = ',',   
    ROWTERMINATOR = '0x0a',    
    FIRSTROW = 2             
)
select * from Supplies
delete from Supplies

-- ================================================

--insert Data into Trainee Table
BULK INSERT Trainee
FROM 'D:\ITI\Graduation Project\Data\Trainee.csv'
WITH (
    FIELDTERMINATOR = ',',   
    ROWTERMINATOR = '0x0a',    
    FIRSTROW = 2             
)
select * from Trainee
delete from Trainee
-- ================================================

--insert Data into TraineeHealthCondition Table
BULK INSERT TraineeHealthCondition
FROM 'D:\ITI\Graduation Project\Data\TraineeHealthCondition.csv'
WITH (
    FIELDTERMINATOR = ',',   
    ROWTERMINATOR = '0x0a',    
    FIRSTROW = 2             
)
select * from TraineeHealthCondition
delete from TraineeHealthCondition

-- ================================================

--insert Data into TraineeAttendance Table
BULK INSERT TraineeAttendance
FROM 'D:\ITI\Graduation Project\Data\TraineeAttendance.csv'
WITH (
    FIELDTERMINATOR = ',',   
    ROWTERMINATOR = '0x0a',    
    FIRSTROW = 2             
)
select * from TraineeAttendance
delete from TraineeAttendance
-- ================================================

--insert Data into Feedback Table
BULK INSERT Feedback
FROM 'D:\ITI\Graduation Project\Data\Feedback.csv'
WITH (
    FIELDTERMINATOR = ',',   
    ROWTERMINATOR = '0x0a',    
    FIRSTROW = 2             
)
select * from Feedback
delete from Feedback

-- ================================================

--insert Data into TraineeFeedback Table
BULK INSERT TraineeFeedback
FROM 'D:\ITI\Graduation Project\Data\TraineeFeedback.csv'
WITH (
    FIELDTERMINATOR = ',',   
    ROWTERMINATOR = '0x0a',    
    FIRSTROW = 2             
)
select * from TraineeFeedback
delete from TraineeFeedback
-- ================================================

--insert Data into MembershipPackages Table
BULK INSERT MembershipPackages
FROM 'D:\ITI\Graduation Project\Data\MembershipPackages.csv'
WITH (
    FIELDTERMINATOR = ',',   
    ROWTERMINATOR = '0x0a',    
    FIRSTROW = 2             
)
select * from MembershipPackages
delete from MembershipPackages

-- ================================================

--insert Data into TraineeSubscription Table
BULK INSERT TraineeSubscription
FROM 'D:\ITI\Graduation Project\Data\TraineeSubscription.csv'
WITH (
    FIELDTERMINATOR = ',',   
    ROWTERMINATOR = '0x0a',    
    FIRSTROW = 2             
)
select * from TraineeSubscription
delete from TraineeSubscription
-- ================================================

--insert Data into TraineeBodyDetails Table
BULK INSERT TraineeBodyDetails
FROM 'D:\ITI\Graduation Project\Data\TraineeBodyDetails.csv'
WITH (
    FIELDTERMINATOR = ',',   
    ROWTERMINATOR = '0x0a',    
    FIRSTROW = 2             
)
select * from TraineeBodyDetails
delete from TraineeBodyDetails

-- ================================================

--insert Data into Freeze Table
BULK INSERT Freeze
FROM 'D:\ITI\Graduation Project\Data\Freeze.csv'
WITH (
    FIELDTERMINATOR = ',',   
    ROWTERMINATOR = '0x0a',    
    FIRSTROW = 2             
)
select * from Freeze
delete from Freeze

-- ================================================

--insert Data into PaymentDetails Table
BULK INSERT PaymentDetails
FROM 'D:\ITI\Graduation Project\Data\PaymentDetails.csv'
WITH (
    FIELDTERMINATOR = ',',   
    ROWTERMINATOR = '0x0a',    
    FIRSTROW = 2             
)
select * from PaymentDetails
delete from PaymentDetails

-- ================================================
