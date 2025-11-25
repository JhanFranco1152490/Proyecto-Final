from cs50 import SQL
from flask import Flask, flash, redirect, render_template, request, session
from flask_session import Session
from werkzeug.security import check_password_hash, generate_password_hash

from datetime import datetime
from helpers import apology, login_required, admin_required, usd

# Configure application
app = Flask(__name__)

# Custom filter
app.jinja_env.filters["usd"] = usd

# Configure session to use filesystem (instead of signed cookies)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///library.db")


@app.after_request
def after_request(response):
    """Ensure responses aren't cached"""
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Expires"] = 0
    response.headers["Pragma"] = "no-cache"
    return response


@app.route("/")
@login_required
def index():
    """Show list of owned books """
    # Get user's data
    id = session["user_id"]
    funds = get_funds(id)

    # Get the books
    books = db.execute("""SELECT * FROM books as b JOIN purchases as p 
                            ON p.book_id = b.id
                            WHERE user_id = ?
                            ORDER BY title DESC""", session["user_id"])

    return render_template("index.html", funds=funds, books=books)

@app.route("/add", methods=["GET", "POST"])
@admin_required
def add():
    """Add a new book to the store"""
    if request.method == "POST":
        try:
            title = get_variable("title")
            author = get_variable("author")
            pusblished_year = get_int("published_year")
            genre = get_variable("genre")
            price = get_float("price")
        except ValueError as e:
            return apology(str(e))
        
        # Insert the book
        db.execute("INSERT INTO books (title, author, published_year, genre, price) VALUES (?,?,?,?,?)",
                title, author, pusblished_year, genre, price)
        
        flash("Book Added")

    return render_template("add.html",funds=get_funds(session["user_id"]))


@app.route("/buy", methods=["POST"])
@login_required
def buy():
    """Buy a book"""
    if request.method == "POST":
        # Get the book id
        id = session["user_id"]
        book_id = get_variable("book_id")
        funds = get_funds(id)

        # Get the book data
        book = db.execute("SELECT * FROM books WHERE id = ?", book_id)
        if len(book) != 1:
            return apology("Book not found")
        
        #Validate if user already owns the book
        owned = db.execute("SELECT * FROM purchases WHERE user_id = ? AND book_id = ?", id, book_id)
        if len(owned) == 1:
            return apology("You already own this book")
        
        # Validate if user has enough funds
        price = book[0]["price"]
        if funds < price:
            return apology("Not enough funds")
        
        # Update user's funds
        funds -= price
        db.execute("UPDATE users SET funds = ? WHERE id = ?", funds, id)
        # Insert the purchase
        db.execute("INSERT INTO purchases (user_id, book_id, price, purchase_date) VALUES (?, ?, ?, ?)",
                id, book_id, price, datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
        flash("Purchase Completed")

    return redirect("/")

@app.route("/delete", methods=["POST"])
@admin_required
def delete_book():
    """Delete a book from the store."""
    if request.method == "POST":
        try:
            book_id = get_int("book_id")
        except ValueError as e:
            return apology(str(e))
        
        # Delete the book
        db.execute("DELETE FROM books WHERE id = ?", book_id)
        
        flash("Book Deleted")
        return redirect("/search")

@app.route("/funds", methods=["GET", "POST"])
@login_required
def funds():
    # Get the funds
    id = session["user_id"]
    funds = get_funds(id)

    if request.method == "POST":
        # Validate the value
        try:
            value = get_float("value")
        except ValueError as e:
            return apology(str(e))

        # Validate the operation
        operation = get_variable("operation")

        # Make the operation
        if operation == "deposit":
            funds += value
        elif operation == "withdraw":
            # Validate if there is enough funds
            if funds < value:
                return apology("Not enough funds")
            funds -= value
        else:
            return apology("Not valid operation")

        # Update the funds
        db.execute("UPDATE users SET funds = ? WHERE id = ?", funds, id)
        flash("Transaction Completed")
        return redirect("/")

    return render_template("funds.html", funds=funds)

@app.route("/history")
@login_required
def history():
    """Show history of transactions"""
    id = session["user_id"]
    purchases = db.execute("""SELECT * FROM purchases as p JOIN books as b
                            ON p.book_id = b.id
                            WHERE user_id = ?
                            ORDER BY purchase_date DESC""", id)
    return render_template("history.html", transactions=purchases, funds=get_funds(id))

@app.route("/login", methods=["GET", "POST"])
def login():
    """Log user in"""

    # Forget any user_id and role_id
    session.clear()

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":
        try:
            username = get_variable("username")
            password = get_variable("password")
        except ValueError as e:
            return apology(str(e))

        # Query database for username
        rows = db.execute("SELECT * FROM users WHERE username = ?",username);

        # Ensure username exists and password is correct
        if len(rows) != 1 or not check_password_hash(
            rows[0]["password_hash"], password):
            return apology("invalid username and/or password", 403)

        # Remember which user has logged in
        session["user_id"] = rows[0]["id"]
        session["role_id"] = db.execute(
            "SELECT role_id FROM user_roles WHERE user_id = ?", rows[0]["id"]
        )[0]["role_id"]

        # Redirect user to home page
        flash("Welcome")
        return redirect("/")

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        return render_template("login.html")

@app.route("/logout")
def logout():
    """Log user out"""

    # Forget any user_id
    session.clear()

    # Redirect user to login form
    flash("Logged Out")
    return redirect("/")

@app.route("/profile", methods=["GET", "POST"])
@login_required
def profile():
    """Show and update profile information""" 
    id = session["user_id"]

    if request.method == "POST":
        try:
            first_name = get_variable("first_name")
            last_name = get_variable("last_name")
            birth_date = get_variable("birth_date")
            password = get_variable("password")
            confirmation = get_variable("confirmation")
        except ValueError as e:
            return apology(str(e))
        
        if password != confirmation:
            return apology("Password and Confirmation are differents")

        # Update the profile
        try:
            db.execute("""UPDATE users 
                        SET first_name = ?, last_name = ?, birth_date = ? , password_hash = ?
                        WHERE id = ?""",
                    first_name, last_name, birth_date, generate_password_hash(password), id)
        except ValueError:
            return apology("Error updating profile")
        
        flash("Profile Updated")

    # Get user's data
    user = db.execute("SELECT * FROM users WHERE id = ?", id)[0]
    role_name = db.execute("""SELECT role_name FROM roles 
                                WHERE id IN (
                                    SELECT role_id FROM user_roles
                                    WHERE user_id = ?)""", id)[0]["role_name"]
    return render_template("profile.html", user=user, role_name=role_name, funds=get_funds(id))

@app.route("/register", methods=["GET", "POST"])
def register():
    """Register user"""
    if request.method == "POST":
        try:
            username = get_variable("username")
            first_name = get_variable("first_name")
            last_name = get_variable("last_name")
            password = get_variable("password")
            confirmation = get_variable("confirmation")
        except ValueError as e:
            return apology(str(e))
        
        if password != confirmation:
            return apology("Password and Confirmation are differents")

        # insert the register
        try:
            db.execute("INSERT INTO users (username,first_name,last_name,password_hash) VALUES (?,?,?,?)",
                    username, first_name, last_name, generate_password_hash(password))
            db.execute("INSERT INTO user_roles (user_id,role_id) VALUES ((SELECT id FROM users WHERE username = ?), ?)",
                    username, 2) # Default role: User
        except ValueError:
            return apology("Duplicated Username")
        
        flash("Register Completed")
        return redirect("/") 
    return render_template("register.html")

@app.route("/search", methods=["GET", "POST"])
@login_required
def search():
    """Search books by name."""
    if request.method == "POST":
        title = request.form.get("title")
        books = db.execute("SELECT * FROM books WHERE title LIKE ?", f"%{title}%")
    
    return render_template("search.html", books=books if request.method == "POST" else None, funds=get_funds(session["user_id"]))

@app.route("/update", methods=["POST"])
@admin_required
def update_books():
    """Update book information."""
    if request.method == "POST":
        try:
            book_id = get_int("book_id")
            title = get_variable("title")
            author = get_variable("author")
            published_year = get_int("published_year")
            genre = get_variable("genre")
            price = get_float("price")
        except ValueError as e:
            return apology(str(e))
        
        # Update the book
        db.execute("""UPDATE books 
                    SET title = ?, author = ?, published_year = ?, genre = ?, price = ? 
                    WHERE id = ?""",
                title, author, published_year, genre, price, book_id)
        
        flash("Book Updated")

    return redirect("/update_search")
    
@app.route("/update_search", methods=["GET", "POST"])
@admin_required
def update_search():    
    """Search books to update."""
    funds = get_funds(session["user_id"])

    if request.method == "POST":
        book_id = get_int("book_id")
        books = db.execute("SELECT * FROM books WHERE id = ?", book_id)
        if len(books) != 1:
            return apology("Book not found")
        return render_template("update.html", book=books[0], funds=funds)
    
    return render_template("update_search.html", funds=funds)

# Helpers
def get_funds(id):
    return db.execute("SELECT funds FROM users WHERE id = ?", id)[0]["funds"]

def get_variable(var):
    # validate var
    variable = request.form.get(var)
    if not variable:
        raise ValueError(f"Missing {var}")
    return variable

def get_number(var, type_func):
    # validate var
    variable = get_variable(var)
    try:
        variable = type_func(variable)
    except ValueError:
        raise ValueError(f"Not numeric value {var}")

    # validate if var is positive
    if variable <= 0:
        raise ValueError(f"Not valid value in {var}")

    return variable

def get_int(var):
    return get_number(var, int)

def get_float(var):
    return get_number(var, float)
