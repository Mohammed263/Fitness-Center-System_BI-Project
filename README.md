# 🏋️‍♂️ Fitness Center Business Intelligence System  
### ITI Graduation Project

## 📌 Project Overview
This project is a **complete end-to-end Business Intelligence (BI solution)** designed for a **multi-branch fitness center**.  
It addresses the challenge of scattered operational data and transforms it into **structured, reliable, and actionable insights** to support data-driven decision-making.

---

## ❗ Problem Statement
Fitness centers generate large volumes of data related to:
- Members & subscriptions  
- Attendance  
- Staff & trainers  
- Branches & facilities  
- Financial performance  

When this data is unorganized, it becomes difficult to track trends, evaluate performance, and make informed strategic decisions.

---

## 💡 Solution
We designed and implemented a full BI ecosystem that:
- Centralizes all operational data
- Enforces business rules & data integrity
- Provides analytical insights through reports & dashboards
- Supports operational workflows via a web application

---

## 🔄 Project Workflow
1. System Analysis  
2. ERD Design & Data Mapping  
3. Database Creation & Data Generation  
4. Data Modeling  
5. Stored Procedures & Triggers  
6. SSRS Reports  
7. Power BI Dashboards  
8. Web Application Development  

---

## 🗂 Database Design & Development
- **20 tables** mapped from ERD (3rd Normal Form)
- Constraints, rules, defaults & indexes
- Bulk data generation & insertion
- Optimized queries and indexing

### Key Database Features
- Stored Procedures for full **CRUD operations**
- Advanced **Triggers** to enforce business logic:
  - Prevent attendance after subscription expiry
  - Handle subscription freeze logic
  - Enforce one manager per branch
  - Prevent unsafe branch deletion
  - Auto-update equipment maintenance status

---

## 📊 Advanced Analytics
### RFM Analysis (Recency, Frequency, Monetary)
Used to analyze member behavior and segment customers into:
- Elite Members  
- Highly Active Members  
- Consistent Members  
- At-Risk Members  
- Hibernating Members  
- Lost Members  

This helps identify loyalty patterns and early signs of inactivity.

---

## 📑 SSRS Reports
Developed dynamic and branch-filtered reports powered by stored procedures:
- Trainer Salaries Report  
- Staff Salaries Report  
- Equipment Maintenance Report  
- Supplies Details Report  
- Financial Performance Report (YoY analysis)  
- Branch Feedback Report  

---

## 📈 Power BI Dashboards
- **20+ interactive dashboards**
- Fact & dimension data model
- Advanced **DAX measures**
- Clean, user-friendly UI
- Slicers & filters for deep data exploration

### Key Insights Covered
- Profit & loss analysis  
- Cost drivers by branch  
- Subscription trends  
- Workforce analytics  
- Membership behavior & demographics  

---

## 🌐 Web Application (Flask)
A lightweight web application connected directly to SQL Server:
- Trainee registration
- Attendance tracking
- Payment management

### Tech Stack
- Backend: **Flask**
- Frontend: **HTML, CSS, Bootstrap**
- Database: **SQL Server**

---

## 🔗 API Integration
- Integrated **Facebook Graph API**
- Dynamically displays profile images inside Power BI
- Ensures real-time synchronization

---

## 🛠 Tools & Technologies
- SQL Server & T-SQL  
- Power BI & DAX  
- SSRS  
- Flask  
- GitHub  
- Trello  

---

## 👥 Team Members
- Maryam Salah  
- Ahmed Khaled  
- Mohamed Ghazal  
- Mohammad Anwar  
- Youssef Radwan  
- Sherif Khaled  

---

## 🚀 Key Takeaways
- Hands-on experience with **end-to-end BI solutions**
- Strong focus on **data modeling, analytics, and visualization**
- Real-world application of **business rules & automation**
- Effective teamwork and version control

---

📌 *This project demonstrates how Business Intelligence can turn raw data into meaningful insights that drive smarter decisions.*


