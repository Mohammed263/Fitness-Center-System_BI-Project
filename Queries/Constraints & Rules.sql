
---------------------------------------------------------------------------------------------------
---------------------------------------------Constraints-------------------------------------------

-- create unique constraint on EmailAddress
Alter Table Trainer Add Constraint UQ_TrainerEmail UNIQUE (EmailAddress)
Alter Table Staff Add Constraint UQ_StaffEmail UNIQUE (EmailAddress)
Alter Table Trainee Add Constraint UQ_TraineeEmail UNIQUE (EmailAddress)
Alter Table Supplier Add Constraint UQ_SupplierEmail UNIQUE (EmailAddress)


-- create unique constraint on PhoneNumber
Alter Table Trainer Add Constraint UQ_TrainerPhone UNIQUE (PhoneNumber)
Alter Table Staff Add Constraint UQ_StaffPhone UNIQUE (PhoneNumber)
Alter Table Trainee Add Constraint UQ_TraineePhone UNIQUE (PhoneNumber)
Alter Table Supplier Add Constraint UQ_SupplierPhone UNIQUE (ContactNumber)


-- create unique constraint on Name 
Alter Table Supplier Add Constraint UQ_SuppName UNIQUE (Name)
Alter Table MembershipPackages Add Constraint UQ_MembName UNIQUE (Name)
Alter Table Maintenance Add Constraint UQ_MainName UNIQUE (Type)
Alter Table Feedback Add Constraint UQ_FedName UNIQUE (Description)


-- create unique constraint on InvoiceNumber
Alter Table PaymentDetails Add Constraint UQ_Invoice UNIQUE (InvoiceNumber)


-- create check constraint on feedback rating
Alter Table TraineeFeedback Add Constraint C_Rating CHECK ((Rating) between 1 and 5)


-- create check constraint on Payment Method
Alter Table PaymentDetails Add Constraint C_PayMethod 
CHECK (PaymentMethod in ('Credit Card','Cash','Instapay'))


-- create check constraint on Date
Alter Table TraineeSubscription Add Constraint C_SupDate CHECK (ExpiryDate > StartDate)
Alter Table Freeze Add Constraint C_FrezDate CHECK (EndDate > StartDate)


---------------------------------------------------------------------------------------------------
-------------------------------------------Defaults------------------------------------------------

Create Default PersonStatus As 'Active'
sp_bindefault PersonStatus , 'TraineeSubscription.Status'
sp_bindefault PersonStatus , 'Trainer.EmploymentStatus'
sp_bindefault PersonStatus , 'Staff.EmploymentStatus'
sp_bindefault PersonStatus , 'Supplier.Status'
sp_bindefault PersonStatus , 'TraineeSubscription.Status'


Create Default EquipmentStatus As 'Operational'
sp_bindefault EquipmentStatus , 'Equipment.Status'


Create Default FacilityStatus As 'Operational'
sp_bindefault FacilityStatus , 'Equipment.Status'

Create Default TimeNow As GETDATE()
sp_bindefault TimeNow , 'TraineeAttendance.DateTime'


Create Default DateNow As CAST(GETDATE() AS DATE)
sp_bindefault DateNow , 'TraineeFeedback.Date'
sp_bindefault DateNow , 'TraineeBodyDetails.Date'
sp_bindefault DateNow , 'PaymentDetails.Date'


---------------------------------------------------------------------------------------------------
---------------------------------------------Rules-------------------------------------------------

Create Rule Gen_Rule As @Gen_Col in ('M','F')

Sp_bindrule Gen_Rule , 'Trainer.Gender'
Sp_bindrule Gen_Rule , 'Staff.Gender'
Sp_bindrule Gen_Rule , 'Trainee.Gender'







