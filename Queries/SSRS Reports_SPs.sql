
-- Trainer_Salaries

create or alter proc Trainer_Salaries @Branch nvarchar(max)
as
begin
select t.name, t.salary, t.seniority, b.location
from trainer t
join TrainerSchedule ts
on t.id = ts.TrainerID
join branch b
on ts.BranchID = b.id
where b.ID in (SELECT CAST(value AS INT) 
        FROM STRING_SPLIT(@Branch, ','))
end

go

-- Staff_Salaries

create or alter proc Staff_Salaries @Branch nvarchar(max)
as
begin
select s.name, s.salary, s.jobposition, b.location, s.EmploymentStatus
from staff s
join branch b
on s.BranchID = b.ID
where b.ID in (SELECT CAST(value AS INT) 
        FROM STRING_SPLIT(@Branch, ','))
end

go

-- Equipment_Maintenace

create or alter proc Equipment_Maintenace @Branch nvarchar(max)
as
begin
select e.name, e.category,m.Type, em.cost, em.date, b.location
from branch b
join Equipment e
on b.ID = e.BranchID
join EquipmentMaintenance em
on e.ID = em.EquipmentID
join Maintenance m
on m.ID = em.MaintenanceID
where b.ID in (SELECT CAST(value AS INT) 
        FROM STRING_SPLIT(@Branch, ','))
end

go

-- Supplies_Details

create or alter proc Supplies_Details @Branch nvarchar(max)
as
begin
select ss.name, ss.quantity, ss.price, sr.name as supplier, ss.PurchaseDate, b.location
from branch b
join Supplies ss
on b.ID = ss.BranchID
join Supplier sr
on ss.SupplierID = sr.ID
where b.ID in (SELECT CAST(value AS INT) 
        FROM STRING_SPLIT(@Branch, ','))
end

go

-- Financials

create or alter proc Financials @Branch nvarchar(max)
as
begin
SELECT 
    b.location,
    YEAR([date]) AS [year],
    sum(TotalAmount) as 'Total Amount',
    sum(TotalAmount) - LAG(sum(TotalAmount)) OVER (PARTITION BY b.location ORDER BY YEAR([date])) AS yoy_change,
    (sum(TotalAmount) - LAG(sum(TotalAmount)) OVER (PARTITION BY b.location ORDER BY YEAR([date]))) 
        / NULLIF(LAG(sum(TotalAmount)) OVER (PARTITION BY b.location ORDER BY YEAR([date])), 0) AS yoy_percent
FROM PaymentDetails p
join branch b
on b.ID = p.BranchID
where b.ID in (SELECT CAST(value AS INT) 
        FROM STRING_SPLIT(@Branch, ','))
group by b.location, YEAR([date])
end

go

-- Feedback

create or alter proc Branch_Feedback @Branch nvarchar(max)
as
begin
select f.description, b.Location, count(tf.FeedbackID) as 'Feedback Count', YEAR([date]) AS [year]
from branch b 
join Trainee t
on b.ID = t.BranchID
join TraineeFeedback tf
on t.ID = tf.TraineeID
join Feedback f
on tf.FeedbackID = f.ID
where b.ID in (SELECT CAST(value AS INT) 
        FROM STRING_SPLIT(@Branch, ','))
group by b.Location, f.Description, YEAR([date]) 
end



