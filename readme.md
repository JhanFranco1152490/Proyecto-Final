# JHAN & YULIAN'S LIBRARY
#### Video Demo: https://www.youtube.com/watch?v=bMxu9IBe4uk
#### Description:
Our project is a web application for a bookstore, in which there are two roles: **USER** and **ADMIN**.

The **USER** can search for books, buy books, view their purchase history, and manage their account funds. They can also log in to view their account details and modify them if they wish.

The **ADMIN** can also manage the store's inventory: add books, update their information, or delete them if desired.

To access the application, we have a **registration** and **login** process; there is also a **logout** option to exit the current account.

All of this was implemented with **Flask, Python, SQL, HTML, CSS, JavaScript, and Bootstrap**, using **flask_sessions (cookies)** and **password hashing** for added security.

The **query.sql** file is used to illustrate the important queries we use to create tables and indexes, and to insert default roles into an empty .db file.

The **library.db** file is our database, which has:
.	The **users** table (to store user data).
.	The unique index **users_username** (to avoid repeated usernames).
.	The **roles** table (to store roles with their IDs).
.	The **user_roles** table (to link the roles that users have).
.	The unique **user_role** index (to prevent a user from having the same role twice).
.	The **books** table, with an index for the title.
.	A list of books for the app to start with.
.	The **purchases** table (for each purchase) with its corresponding index.

In **app.py** we handle everything related to **routes**. In this project we handle two cookies: one for the user ID (**“user_id”**) and another for the role ID (**“role_id”**), so we don't have to query the database every time we change pages.

Our first route is **“/”**, which requires us to be logged in; this renders the index, where we can see the list of our purchased books. We can also access all other sections using the navigation bar in the header.

Then there are the following routes:
.	**“/add”**: administrators can add books by entering the necessary data to store them in  the database.
.	**“/buy”**: users can buy a book if they have sufficient funds; when they do so,        everything necessary is updated in the database.
.	**“/delete”**: an admin can delete a book using its ID.
.	**“/funds”**: manages everything related to funds and their operations.
.	**“/history”**: shows all the user's purchases recorded in purchases.
.	**“/login”**: allows you to log in with your username and password, then redirects to “/”.
.	**“/logout”**: deletes everything saved in the session and redirects back to the login.
.	**“/profile”**: displays and allows the user to update their information, except for their username.
.	**“/register”**: allows the user to create an account, assigning the USER role by default.
.	**“/search”**: allows the user to search for books by title.
.	**“/update”**: the admin updates a book based on an ID.
.	**“/update_search”**: allows the admin to search for a book by its ID and then update it.

Each route handles exceptions or errors using the **apology** method, which renders a page showing the reason for the error.

At the end of the file, we also have auxiliary functions that allow us to extract and organize the data entered by the user in a modular way.

In **helper.py**, we have secondary methods for the application, such as the method for encrypting and comparing passwords, the method for verifying administrator permissions (which generates an error when attempting to enter a route without permission), the login method (which redirects to “/login”), and the method for formatting values in USD.

The **templates** folder contains all the **HTML** files. We use a **layout.html** that was extended using **Jinja** in the other templates, some of which have scripts for greater user interaction.
The CSS file and images needed for the project are stored in **static**.

To run the project, you need to **install Flask, Flask-Session, and CS50** in a **virtual environment**.
