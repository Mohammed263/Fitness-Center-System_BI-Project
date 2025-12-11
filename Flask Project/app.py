from flask import Flask, render_template, request, redirect, url_for, flash
import pyodbc
from config import DATABASE_CONFIG, SECRET_KEY

app = Flask(__name__)
app.secret_key = SECRET_KEY

# Database connection function
def get_db_connection():
    conn = pyodbc.connect(
        f"DRIVER={DATABASE_CONFIG['driver']};"
        f"SERVER={DATABASE_CONFIG['server']};"
        f"DATABASE={DATABASE_CONFIG['database']};"
        f"Trusted_Connection={DATABASE_CONFIG['trusted_connection']};"
    )
    return conn

# Home route
@app.route('/')
def home():
    return render_template('home.html')



# -----------------------------
# Route for attendance registration
# -----------------------------
from datetime import datetime

@app.route('/attendance', methods=['GET', 'POST'])
def register_attendance():
    
    conn = get_db_connection()
    cursor = conn.cursor()

    # Fetch TraineeIDs for dropdown
    cursor.execute("SELECT ID, Name FROM Trainee")
    trainees = cursor.fetchall()

    # Fetch Branch Locations for dropdown
    cursor.execute("SELECT Location FROM Branch")
    branches = cursor.fetchall()

    # Get current date and time formatted for datetime-local input
    now = datetime.now().strftime("%Y-%m-%dT%H:%M")

    if request.method == 'POST':
        trainee_id = request.form['trainee_id']
        branch_id = request.form['branch_id']
        attendance_datetime = request.form['datetime']

        try:
            cursor.execute("""
                INSERT INTO TraineeAttendance (TraineeID, BranchID, DateTime)
                VALUES (?, ?, ?)
            """, (trainee_id, branch_id, attendance_datetime))
            conn.commit()
            flash("Attendance registered successfully!", "success")
            return redirect(url_for('register_attendance'))

        except Exception as e:
            flash(f"Error: {str(e)}", "danger")
        finally:
            conn.close()

    return render_template(
        'attendance_form.html',
        trainees=trainees,
        branches=branches,
        now=now   # pass current datetime to template
    )


# Route for trainee registration
@app.route('/register', methods=['GET', 'POST'])
def register_trainee():
    conn = get_db_connection()
    cursor = conn.cursor()

    # Fetch dynamic dropdown values
    cursor.execute("SELECT DISTINCT Gender FROM Trainee")
    genders = [row[0] for row in cursor.fetchall()]

    cursor.execute("SELECT DISTINCT PaymentMethod FROM PaymentDetails")
    payment_methods = [row[0] for row in cursor.fetchall()]

    # Get next trainee ID → MAX(ID) + 1
    cursor.execute("SELECT ISNULL(MAX(ID), 0) FROM Trainee")
    max_id = cursor.fetchone()[0]
    next_id = max_id + 1

    if request.method == 'POST':
        # Trainee info
        trainee_id = request.form['trainee_id']
        name = request.form['name']
        gender = request.form['gender']
        birthdate = request.form['birthdate']
        phone = request.form['phone']
        email = request.form['email']
        branch_id = request.form['branch_id']

        # Subscription info
        membership_id = request.form['membership_id']
        status = request.form['status']
        start_date = request.form['start_date']
        expiry_date = request.form['expiry_date']

        # Payment info
        payment_date = request.form['payment_date']
        invoice_number = request.form['invoice_number']
        payment_method = request.form['payment_method']
        total_amount = request.form['total_amount']

        try:
            # Insert trainee info
            cursor.execute("""
                INSERT INTO Trainee (ID, Name, Gender, BirthDate, PhoneNumber, EmailAddress, BranchID)
                VALUES (?, ?, ?, ?, ?, ?, ?)
            """, (trainee_id, name, gender, birthdate, phone, email, branch_id))

            # Insert subscription info
            cursor.execute("""
                INSERT INTO TraineeSubscription (TraineeID, MembershipID, Status, StartDate, ExpiryDate)
                VALUES (?, ?, ?, ?, ?)
            """, (trainee_id, membership_id, status, start_date, expiry_date))

            # Insert payment info
            cursor.execute("""
                INSERT INTO PaymentDetails (TraineeID, MembershipID, BranchID, Date, InvoiceNumber, PaymentMethod, TotalAmount)
                VALUES (?, ?, ?, ?, ?, ?, ?)
            """, (trainee_id, membership_id, branch_id, payment_date, invoice_number, payment_method, total_amount))

            conn.commit()
            flash("Trainee registered successfully!", "success")
            return redirect(url_for('register_trainee'))

        except Exception as e:
            flash(f"Error: {str(e)}", "danger")

        finally:
            conn.close()

    # GET request
    return render_template(
        'trainee_form.html',
        genders=genders,
        payment_methods=payment_methods,
        next_id=next_id
    )



# -----------------------------
# Run App
# -----------------------------
if __name__ == "__main__":
    app.run(debug=True)




