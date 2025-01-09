-- SQL Script for Creating Tables from the Provided ERD

-- Table: geographical_location
CREATE TABLE geographical_location (
    Location_ID INT PRIMARY KEY,
    Village VARCHAR(100),
    Parish VARCHAR(100),
    Sub_County VARCHAR(100),
    County VARCHAR(100),
    Region VARCHAR(50),
    Coordinates VARCHAR(100),
    Population INT,
    Malaria_Risk_Level VARCHAR(50),
    Health_Facilities_Count INT,
    ITN_Coverage DECIMAL(5, 2),
    Reported_Cases INT
);

-- Table: supply_chain
CREATE TABLE supply_chain (
    Supply_ID INT PRIMARY KEY,
    Resource_ID INT,
    Facility_ID INT,
    Quantity_Shipped INT,
    Shipment_Date DATE,
    Expected_Arrival_Date DATE,
    Shipped_By VARCHAR(50),
    Status VARCHAR(50),
    Update_Date DATE,
    FOREIGN KEY (Resource_ID) REFERENCES resource(Resource_ID) ON DELETE CASCADE,
    FOREIGN KEY (Facility_ID) REFERENCES health_facility(Facility_ID) ON DELETE CASCADE
);

-- Table: epidemiological_data
CREATE TABLE epidemiological_data (
    Data_ID INT PRIMARY KEY,
    Location_ID INT,
    Cases_Per_Thousand_People INT,
    Rainfall INT,
    Average_Temperature DECIMAL(5, 2),
    Update_Date DATE,
    Added_By INT,
    FOREIGN KEY (Location_ID) REFERENCES geographical_location(Location_ID) ON DELETE CASCADE
);

-- Table: patient_data
CREATE TABLE patient_data (
    Patient_ID INT PRIMARY KEY,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Date_Of_Birth DATE,
    Gender VARCHAR(10),
    Phone_Number VARCHAR(15),
    Next_Of_Kin VARCHAR(100),
    Location_ID INT,
    Date_Added DATE,
    Update_Date DATE,
    FOREIGN KEY (Location_ID) REFERENCES geographical_location(Location_ID) ON DELETE CASCADE
);

-- Table: health_facility
CREATE TABLE health_facility (
    Facility_ID INT PRIMARY KEY,
    Facility_Name VARCHAR(100),
    Location_ID INT,
    Facility_Type_ID INT,
    Capacity INT,
    Contact_Details VARCHAR(50),
    Date_Added DATE,
    Date_Updated DATE,
    FOREIGN KEY (Location_ID) REFERENCES geographical_location(Location_ID) ON DELETE CASCADE,
    FOREIGN KEY (Facility_Type_ID) REFERENCES facility_type(Facility_Type_ID) ON DELETE CASCADE
);

-- Table: resource
CREATE TABLE resource (
    Resource_ID INT PRIMARY KEY,
    Facility_ID INT,
    Resource_Name VARCHAR(50),
    Quantity INT,
    Last_Updated DATE,
    Description TEXT,
    Date_Added DATE,
    FOREIGN KEY (Facility_ID) REFERENCES health_facility(Facility_ID) ON DELETE CASCADE
);

-- Table: treatment
CREATE TABLE treatment (
    Treatment_ID INT PRIMARY KEY,
    Treatment_Name VARCHAR(50),
    Dosage VARCHAR(50),
    Treatment_Description TEXT,
    Date_Added DATE,
    Update_Date DATE
);

-- Table: visit_record
CREATE TABLE visit_record (
    Visit_ID INT PRIMARY KEY,
    Patient_ID INT,
    Visit_Date DATE,
    Notes TEXT,
    Facility_ID INT,
    FOREIGN KEY (Patient_ID) REFERENCES patient_data(Patient_ID) ON DELETE CASCADE,
    FOREIGN KEY (Facility_ID) REFERENCES health_facility(Facility_ID) ON DELETE CASCADE
);

-- Table: user
CREATE TABLE user (
    User_ID INT PRIMARY KEY,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Preferred_Name VARCHAR(50),
    Role_ID INT,
    Username VARCHAR(50) UNIQUE,
    Password VARCHAR(100),
    Facility_ID INT,
    FOREIGN KEY (Role_ID) REFERENCES user_role(Role_ID) ON DELETE CASCADE,
    FOREIGN KEY (Facility_ID) REFERENCES health_facility(Facility_ID) ON DELETE CASCADE
);

-- Table: user_role
CREATE TABLE user_role (
    Role_ID INT PRIMARY KEY,
    Role_Name VARCHAR(50),
    Role_Description TEXT,
    Date_Added DATE,
    Update_Date DATE
);

-- Table: interventions
CREATE TABLE interventions (
    Intervention_ID INT PRIMARY KEY,
    Type VARCHAR(50),
    Location_ID INT,
    Start_Date DATE,
    End_Date DATE,
    Outcome VARCHAR(50),
    Date_Added DATE,
    FOREIGN KEY (Location_ID) REFERENCES geographical_location(Location_ID) ON DELETE CASCADE
);

-- Table: treatment_outcome
CREATE TABLE treatment_outcome (
    Outcome_ID INT PRIMARY KEY,
    Visit_ID INT,
    Outcome_Name VARCHAR(50),
    Outcome_Description TEXT,
    Date_Added DATE,
    Update_Date DATE,
    FOREIGN KEY (Visit_ID) REFERENCES visit_record(Visit_ID) ON DELETE CASCADE
);

-- Table: laboratory_tests
CREATE TABLE laboratory_tests (
    Test_ID INT PRIMARY KEY,
    Test_Name VARCHAR(50),
    Test_Type VARCHAR(50),
    Test_Result VARCHAR(50),
    Technician_ID INT,
    FOREIGN KEY (Technician_ID) REFERENCES user(User_ID) ON DELETE CASCADE
);

-- Table: malaria_cases
CREATE TABLE malaria_cases (
    Case_ID INT PRIMARY KEY,
    Patient_ID INT,
    Facility_ID INT,
    Date_Of_Diagnosis DATE,
    Type_Of_Malaria VARCHAR(50),
    Treatment_ID INT,
    Outcome_ID INT,
    FOREIGN KEY (Patient_ID) REFERENCES patient_data(Patient_ID) ON DELETE CASCADE,
    FOREIGN KEY (Facility_ID) REFERENCES health_facility(Facility_ID) ON DELETE CASCADE,
    FOREIGN KEY (Treatment_ID) REFERENCES treatment(Treatment_ID) ON DELETE CASCADE,
    FOREIGN KEY (Outcome_ID) REFERENCES treatment_outcome(Outcome_ID) ON DELETE CASCADE
);
