
CREATE LOGIN [Admin] WITH PASSWORD = '111';
CREATE LOGIN Manager WITH PASSWORD = '222';
CREATE LOGIN Receptionist WITH PASSWORD = '333';

CREATE USER [Admin] FOR LOGIN [Admin];
CREATE USER Manager FOR LOGIN T_Manager;
CREATE USER Receptionist FOR LOGIN Receptionist;

GRANT CONTROL ON DATABASE::[Examination System] TO [Admin]

-- Manager

GRANT EXECUTE ON add_membership_package TO Manager;
GRANT EXECUTE ON add_staff_member TO Manager;
GRANT EXECUTE ON add_supplier TO Manager;
GRANT EXECUTE ON add_supplies TO Manager;
GRANT EXECUTE ON add_trainer TO Manager;
GRANT EXECUTE ON add_trainer_certificate TO Manager;
GRANT EXECUTE ON add_trainer_schedule TO Manager;
GRANT EXECUTE ON AddBranch TO Manager;
GRANT EXECUTE ON AddEquipment TO Manager;
GRANT EXECUTE ON AddEquipmentMaintenance TO Manager;
GRANT EXECUTE ON AddFacility TO Manager;
GRANT EXECUTE ON AddMaintenance TO Manager;
GRANT EXECUTE ON delete_membership_package TO Manager;
GRANT EXECUTE ON DeleteBranch TO Manager;
GRANT EXECUTE ON DeleteFacility TO Manager;
GRANT EXECUTE ON AddFeedback TO Manager;
GRANT EXECUTE ON DeleteFeedback TO Manager;
GRANT EXECUTE ON DeleteMaintenance TO Manager;
GRANT EXECUTE ON update_membership_package TO Manager;
GRANT EXECUTE ON update_staff_member TO Manager;
GRANT EXECUTE ON update_supplier TO Manager;
GRANT EXECUTE ON update_supplies TO Manager;
GRANT EXECUTE ON update_trainer TO Manager;
GRANT EXECUTE ON update_trainer_certificate TO Manager;
GRANT EXECUTE ON update_trainer_schedule TO Manager;
GRANT EXECUTE ON UpdateBranch TO Manager;
GRANT EXECUTE ON UpdateEquipment TO Manager;
GRANT EXECUTE ON UpdateFacility TO Manager;
GRANT EXECUTE ON UpdateFeedback TO Manager;
GRANT EXECUTE ON UpdateMaintenance TO Manager;

-- Receptionist

GRANT EXECUTE ON Add_Trainee TO Receptionist;
GRANT EXECUTE ON Add_TraineeAttendance TO Receptionist;
GRANT EXECUTE ON AddOrUpdate_Freeze TO Receptionist;
GRANT EXECUTE ON AddOrUpdate_TraineeFeedback TO Receptionist;
GRANT EXECUTE ON Update_Trainee TO Receptionist;


