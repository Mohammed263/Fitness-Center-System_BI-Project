
go

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

create or alter proc RFM
as
begin
with rfm_base as(
	select
		TraineeID,
		BranchID,
		max(cast(Date as datetime)) as 'Last_Order_Date',
		count(distinct InvoiceNumber) as 'Invoice_Count',
		sum(CAST(TotalAmount as decimal(18,2))) as 'Total_Price'
	from PaymentDetails
	group by TraineeID,BranchID
),

rfm as(
	select 
		TraineeID,
		BranchID,
		DATEDIFF(DAY, Last_Order_Date, GETDATE()) as 'Recency',
		Invoice_Count,
		Total_Price
	from rfm_base
),

-- STEP 1: Get distinct values only
freq_raw as (
    select distinct Invoice_Count
    from rfm
),

-- STEP 2: Rank values from highest to lowest
freq_ranked as (
    select
        Invoice_Count,
        DENSE_RANK() over (order by Invoice_Count asc) as rank_desc
    from freq_raw
),

-- STEP 3: Convert rank → 5 buckets (exactly like NTILE but correct)
frequency_levels as (
    select
        invoice_count,
        dense_rank() over (order by invoice_count desc) as freq_rank,

        -- final frequency score from 1 to 5
        ceiling(6 - dense_rank() over (order by invoice_count desc)) as frequency_score
    from rfm
    group by invoice_count
),

customer_segemnt_score as (
	select
		rfm.TraineeID,
		rfm.BranchID,
		rfm.Recency,
		rfm.Invoice_Count,
		rfm.Total_Price,
		NTILE(5) over (order by Recency asc) as 'Recency_Score',
		fl.Frequency_Score,
		NTILE(5) over (order by Total_Price desc) as 'Monetary_Score'
	from rfm
	join frequency_levels fl
	on rfm.Invoice_Count = fl.Invoice_Count
)

select css.TraineeID,
	   css.BranchID,
	   b.location,
	   css.Recency_Score,
	   css.Frequency_Score,
	   css.Monetary_Score,
	   (css.Recency_Score + css.Frequency_Score + css.Monetary_Score) as 'Total_Score',
	    case
			when (css.Recency_Score + css.Frequency_Score + css.Monetary_Score) >= 13 then 'Elite Members'
			when (css.Recency_Score + css.Frequency_Score + css.Monetary_Score) >= 11 then 'Highly Active'
			when (css.Recency_Score + css.Frequency_Score + css.Monetary_Score) >= 8 then 'Consistent Members'
			when (css.Recency_Score + css.Frequency_Score + css.Monetary_Score) >= 6 then 'At-Risk Members'
			when (css.Recency_Score + css.Frequency_Score + css.Monetary_Score) >= 4 then 'Inactive / Hibernating'
			else 'Lost Members'
		end as Member_Segment
from customer_segemnt_score css
join Branch b 
on css.BranchID = b.ID
--order by Total_Score desc
end

go

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



