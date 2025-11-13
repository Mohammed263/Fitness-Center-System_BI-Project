-- Fact Table (PaymentDetails,TraineeSubscription)
select * from PaymentDetails join TraineeSubscription
on PaymentDetails.TraineeID=TraineeSubscription.TraineeID


-- Fact Table (Trainer,TrainerSchedule)
select * from Trainer join TrainerSchedule
on Trainer.ID=TrainerSchedule.TrainerID

