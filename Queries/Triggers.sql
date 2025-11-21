
--------------------------------------------------------------------------------------------------
-----------------------------------------Triggers-------------------------------------------------
--------------------------------------------------------------------------------------------------


-- Trigger to prevent the subscriber from attending after the subscription ends
Create or Alter Trigger PreventAttendance_AfterExpiry
on TraineeAttendance
After Insert
AS
Begin
		if Exists (
					select 1 from inserted inner join TraineeSubscription
					on TraineeSubscription.TraineeID=inserted.TraineeID
					and TraineeSubscription.StartDate=
					(select max(TraineeSubscription.StartDate) from TraineeSubscription 
					 where TraineeSubscription.TraineeID=inserted.TraineeID)
					 where CAST(getdate() as Date) > TraineeSubscription.ExpiryDate
					 )
		Begin
			rollback
			RAISERROR('the subscription has expired.', 16, 1);
		End
End

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

-- Trigger to evaluate freeze end date and remaining freeze
CREATE OR ALTER TRIGGER HandleFreeze
ON Freeze
AFTER INSERT, UPDATE
AS
BEGIN
    -- check if it's the first freeze in the subscription
    IF EXISTS (
        SELECT 1
        FROM inserted
        INNER JOIN TraineeSubscription
            ON TraineeSubscription.TraineeID = inserted.TraineeID
           AND TraineeSubscription.MembershipID = inserted.MembershipID
           AND inserted.StartDate BETWEEN TraineeSubscription.StartDate AND TraineeSubscription.ExpiryDate
        INNER JOIN MembershipPackages
            ON MembershipPackages.ID = inserted.MembershipID
        WHERE NOT EXISTS (
            SELECT 1
            FROM Freeze
            INNER JOIN TraineeSubscription
                ON TraineeSubscription.TraineeID = Freeze.TraineeID
               AND TraineeSubscription.MembershipID = Freeze.MembershipID
               AND Freeze.StartDate BETWEEN TraineeSubscription.StartDate AND TraineeSubscription.ExpiryDate
            WHERE Freeze.TraineeID = inserted.TraineeID
              AND Freeze.MembershipID = inserted.MembershipID
              AND Freeze.StartDate < inserted.StartDate
        )
        AND inserted.TakenFreezes > MembershipPackages.FreezableDays
    )
    BEGIN
        RAISERROR('Taken freeze exceeds allowed FreezableDays for first freeze in this subscription', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- check if he has past freeze in same subscription
    IF EXISTS (
        SELECT 1
        FROM inserted
        INNER JOIN TraineeSubscription
            ON TraineeSubscription.TraineeID = inserted.TraineeID
           AND TraineeSubscription.MembershipID = inserted.MembershipID
           AND inserted.StartDate BETWEEN TraineeSubscription.StartDate AND TraineeSubscription.ExpiryDate
        INNER JOIN MembershipPackages
            ON MembershipPackages.ID = inserted.MembershipID
        WHERE EXISTS (
            SELECT 1
            FROM Freeze
            INNER JOIN TraineeSubscription
                ON TraineeSubscription.TraineeID = Freeze.TraineeID
               AND TraineeSubscription.MembershipID = Freeze.MembershipID
               AND Freeze.StartDate BETWEEN TraineeSubscription.StartDate AND TraineeSubscription.ExpiryDate
            WHERE Freeze.TraineeID = inserted.TraineeID
              AND Freeze.MembershipID = inserted.MembershipID
              AND Freeze.StartDate < inserted.StartDate
              AND inserted.TakenFreezes >
                  (MembershipPackages.FreezableDays -
                   (SELECT SUM(Freeze.TakenFreezes)
                    FROM Freeze
                    INNER JOIN TraineeSubscription
                        ON TraineeSubscription.TraineeID = Freeze.TraineeID
                       AND TraineeSubscription.MembershipID = Freeze.MembershipID
                       AND Freeze.StartDate BETWEEN TraineeSubscription.StartDate AND TraineeSubscription.ExpiryDate
                    WHERE Freeze.TraineeID = inserted.TraineeID
                      AND Freeze.MembershipID = inserted.MembershipID
                      AND Freeze.StartDate < inserted.StartDate))
        )
    )
    BEGIN
        RAISERROR('Taken freeze exceeds remaining freeze for this subscription', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- evaluate freeze end date and remaining freeze
    UPDATE Freeze
    SET 
        EndDate = DATEADD(DAY,freeze.TakenFreezes,freeze.StartDate),
        RemainingFreezes = MembershipPackages.FreezableDays -
            (SELECT SUM(Freeze.TakenFreezes)
             FROM Freeze
             INNER JOIN TraineeSubscription
                 ON TraineeSubscription.TraineeID = Freeze.TraineeID
                AND TraineeSubscription.MembershipID = Freeze.MembershipID
                AND Freeze.StartDate BETWEEN TraineeSubscription.StartDate AND TraineeSubscription.ExpiryDate
             WHERE Freeze.TraineeID = inserted.TraineeID
               AND Freeze.MembershipID = inserted.MembershipID
               AND Freeze.StartDate <= inserted.StartDate)
    FROM Freeze
    INNER JOIN MembershipPackages
        ON MembershipPackages.ID = Freeze.MembershipID
    INNER JOIN inserted
        ON Freeze.TraineeID = inserted.TraineeID
       AND Freeze.MembershipID = inserted.MembershipID
       AND Freeze.StartDate = inserted.StartDate

	 -- update expiry date of subscription
	 UPDATE TraineeSubscription
	 SET ExpiryDate = DATEADD(DAY, inserted.TakenFreezes, ExpiryDate)
	 FROM TraineeSubscription
	 INNER JOIN inserted
	 	 ON TraineeSubscription.TraineeID = inserted.TraineeID
		 AND TraineeSubscription.MembershipID = inserted.MembershipID
		 AND inserted.StartDate BETWEEN TraineeSubscription.StartDate AND TraineeSubscription.ExpiryDate;
END

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------


-- Trigger to Prevent Deleting a Branch That Still Has Related Records
CREATE OR ALTER TRIGGER TR_PreventBranchDelete
ON Branch
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Check Equipment
    IF EXISTS (
        SELECT 1 
        FROM Equipment E
        INNER JOIN deleted D ON E.BranchID = D.ID
    )
    BEGIN
        RAISERROR('Cannot delete Branch because it still contains Equipment.', 16, 1);
        RETURN;
    END

    -- Check Facilities
    IF EXISTS (
        SELECT 1 
        FROM Facility F
        INNER JOIN deleted D ON F.BranchID = D.ID
    )
    BEGIN
        RAISERROR('Cannot delete Branch because it still contains Facilities.', 16, 1);
        RETURN;
    END

    -- If nothing prevents deletion -> Execute
    DELETE FROM Branch
    WHERE ID IN (SELECT ID FROM deleted);
END;


--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

--Auto-Update Equipment Status After Maintenance Insert
CREATE OR ALTER TRIGGER TR_UpdateEquipmentStatus_AfterMaintenance
ON EquipmentMaintenance
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Equipment
    SET Status = 'Under Maintenance'
    WHERE ID IN (SELECT EquipmentID FROM inserted);
END;


--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

--Prevent More Than One Branch Having the Same Manager
CREATE OR ALTER TRIGGER TR_EnforceOneManagerPerBranch
ON Branch
FOR INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT ManagerID
        FROM Branch
        WHERE ManagerID IS NOT NULL
        GROUP BY ManagerID
        HAVING COUNT(*) > 1
    )
    BEGIN
        RAISERROR('This manager is already assigned to another branch. Only one branch can have this manager.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;


--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------