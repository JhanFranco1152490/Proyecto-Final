-- SQL script to create tables and insert initial data
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    username VARCHAR(30) NOT NULL UNIQUE,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    birth_date DATE,
    password_hash TEXT NOT NULL,
    funds NUMERIC NOT NULL DEFAULT 100.00
);

CREATE UNIQUE INDEX users_username ON users(username);

CREATE TABLE roles (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    role_name VARCHAR(100) NOT NULL
);

CREATE TABLE user_roles (
    user_id INTEGER NOT NULL,
    role_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (role_id) REFERENCES roles(id)
);
CREATE UNIQUE INDEX user_role ON user_roles(user_id, role_id);

INSERT INTO roles (role_name) VALUES
    ('Admin'),
    ('User');

CREATE TABLE books (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    published_year INTEGER NOT NULL,
    genre VARCHAR(100) NOT NULL,
    price NUMERIC NOT NULL
);

CREATE INDEX books_title ON books(title);

INSERT INTO books (title, author, published_year, genre, price) VALUES
    ('To Kill a Mockingbird', 'Harper Lee', 1960, 'Fiction', 12.99),
    ('1984', 'George Orwell', 1949, 'Dystopian', 10.50),
    ('Pride and Prejudice', 'Jane Austen', 1813, 'Romance', 9.99),
    ('The Great Gatsby', 'F. Scott Fitzgerald', 1925, 'Fiction', 11.49),
    ('Moby Dick', 'Herman Melville', 1851, 'Adventure', 14.99),
    ('War and Peace', 'Leo Tolstoy', 1869, 'Historical', 13.50),
    ('Crime and Punishment', 'Fyodor Dostoevsky', 1866, 'Psychological', 12.75),
    ('The Catcher in the Rye', 'J.D. Salinger', 1951, 'Fiction', 8.99),
    ('The Hobbit', 'J.R.R. Tolkien', 1937, 'Fantasy', 10.99),
    ('Brave New World', 'Aldous Huxley', 1932, 'Dystopian', 11.25),
    ('The Lord of the Rings', 'J.R.R. Tolkien', 1954, 'Fantasy', 15.99),
    ('Fahrenheit 451', 'Ray Bradbury', 1953, 'Dystopian', 9.49),
    ('Jane Eyre', 'Charlotte Brontë', 1847, 'Romance', 12.25),
    ('Wuthering Heights', 'Emily Brontë', 1847, 'Romance', 10.75),
    ('The Alchemist', 'Paulo Coelho', 1988, 'Fiction', 9.99),
    ('The Kite Runner', 'Khaled Hosseini', 2003, 'Drama', 12.99),
    ('The Book Thief', 'Markus Zusak', 2005, 'Historical', 11.50),
    ('The Da Vinci Code', 'Dan Brown', 2003, 'Thriller', 10.99),
    ('The Hunger Games', 'Suzanne Collins', 2008, 'Dystopian', 9.50),
    ('Catching Fire', 'Suzanne Collins', 2009, 'Dystopian', 9.75),
    ('Mockingjay', 'Suzanne Collins', 2010, 'Dystopian', 9.85),
    ('Harry Potter and the Sorcerer''s Stone', 'J.K. Rowling', 1997, 'Fantasy', 12.99),
    ('Harry Potter and the Chamber of Secrets', 'J.K. Rowling', 1998, 'Fantasy', 13.25),
    ('Harry Potter and the Prisoner of Azkaban', 'J.K. Rowling', 1999, 'Fantasy', 13.50),
    ('Harry Potter and the Goblet of Fire', 'J.K. Rowling', 2000, 'Fantasy', 14.25),
    ('Harry Potter and the Order of the Phoenix', 'J.K. Rowling', 2003, 'Fantasy', 14.99),
    ('Harry Potter and the Half-Blood Prince', 'J.K. Rowling', 2005, 'Fantasy', 15.25),
    ('Harry Potter and the Deathly Hallows', 'J.K. Rowling', 2007, 'Fantasy', 15.99),
    ('The Girl with the Dragon Tattoo', 'Stieg Larsson', 2005, 'Thriller', 11.99),
    ('The Girl Who Played with Fire', 'Stieg Larsson', 2006, 'Thriller', 12.50),
    ('The Girl Who Kicked the Hornet''s Nest', 'Stieg Larsson', 2007, 'Thriller', 12.75),
    ('The Fault in Our Stars', 'John Green', 2012, 'Romance', 9.49),
    ('Looking for Alaska', 'John Green', 2005, 'Young Adult', 8.99),
    ('Paper Towns', 'John Green', 2008, 'Young Adult', 9.25),
    ('The Maze Runner', 'James Dashner', 2009, 'Dystopian', 9.50),
    ('The Scorch Trials', 'James Dashner', 2010, 'Dystopian', 9.75),
    ('The Death Cure', 'James Dashner', 2011, 'Dystopian', 9.85),
    ('Dune', 'Frank Herbert', 1965, 'Science Fiction', 13.99),
    ('Ender''s Game', 'Orson Scott Card', 1985, 'Science Fiction', 10.50),
    ('Foundation', 'Isaac Asimov', 1951, 'Science Fiction', 11.49),
    ('The Shining', 'Stephen King', 1977, 'Horror', 10.99),
    ('It', 'Stephen King', 1986, 'Horror', 13.50),
    ('Pet Sematary', 'Stephen King', 1983, 'Horror', 11.25),
    ('The Stand', 'Stephen King', 1978, 'Horror', 14.99),
    ('Dracula', 'Bram Stoker', 1897, 'Horror', 8.99),
    ('Frankenstein', 'Mary Shelley', 1818, 'Horror', 8.75),
    ('The Picture of Dorian Gray', 'Oscar Wilde', 1890, 'Fiction', 9.25),
    ('The Outsiders', 'S.E. Hinton', 1967, 'Young Adult', 8.99),
    ('The Giver', 'Lois Lowry', 1993, 'Dystopian', 8.50),
    ('A Game of Thrones', 'George R.R. Martin', 1996, 'Fantasy', 14.99),
    ('A Clash of Kings', 'George R.R. Martin', 1998, 'Fantasy', 15.50),
    ('A Storm of Swords', 'George R.R. Martin', 2000, 'Fantasy', 15.99),
    ('A Feast for Crows', 'George R.R. Martin', 2005, 'Fantasy', 14.50),
    ('A Dance with Dragons', 'George R.R. Martin', 2011, 'Fantasy', 16.25),
    ('The Name of the Wind', 'Patrick Rothfuss', 2007, 'Fantasy', 13.50),
    ('The Wise Man''s Fear', 'Patrick Rothfuss', 2011, 'Fantasy', 14.25),
    ('The Silent Patient', 'Alex Michaelides', 2019, 'Thriller', 11.50),
    ('Gone Girl', 'Gillian Flynn', 2012, 'Thriller', 12.25),
    ('Sharp Objects', 'Gillian Flynn', 2006, 'Thriller', 11.75),
    ('The Subtle Art of Not Giving a F*ck', 'Mark Manson', 2016, 'Self-Help', 10.99),
    ('Atomic Habits', 'James Clear', 2018, 'Self-Help', 11.99),
    ('Thinking, Fast and Slow', 'Daniel Kahneman', 2011, 'Psychology', 12.99),
    ('Sapiens', 'Yuval Noah Harari', 2011, 'History', 14.50),
    ('Homo Deus', 'Yuval Noah Harari', 2015, 'History', 15.25),
    ('21 Lessons for the 21st Century', 'Yuval Noah Harari', 2018, 'History', 13.99),
    ('The Power of Habit', 'Charles Duhigg', 2012, 'Self-Help', 11.50),
    ('Becoming', 'Michelle Obama', 2018, 'Memoir', 12.99),
    ('Educated', 'Tara Westover', 2018, 'Memoir', 11.99),
    ('The Diary of a Young Girl', 'Anne Frank', 1947, 'Memoir', 9.99),
    ('Steve Jobs', 'Walter Isaacson', 2011, 'Biography', 14.25),
    ('The Wright Brothers', 'David McCullough', 2015, 'Biography', 13.99),
    ('Long Walk to Freedom', 'Nelson Mandela', 1994, 'Autobiography', 14.75),
    ('The Road', 'Cormac McCarthy', 2006, 'Post-Apocalyptic', 11.50),
    ('Blood Meridian', 'Cormac McCarthy', 1985, 'Western', 12.25),
    ('No Country for Old Men', 'Cormac McCarthy', 2005, 'Thriller', 11.99),
    ('The Old Man and the Sea', 'Ernest Hemingway', 1952, 'Fiction', 8.50),
    ('For Whom the Bell Tolls', 'Ernest Hemingway', 1940, 'Fiction', 10.75),
    ('The Sun Also Rises', 'Ernest Hemingway', 1926, 'Fiction', 10.25),
    ('Don Quixote', 'Miguel de Cervantes', 1605, 'Classic', 12.99),
    ('One Hundred Years of Solitude', 'Gabriel García Márquez', 1967, 'Magic Realism', 13.99),
    ('Love in the Time of Cholera', 'Gabriel García Márquez', 1985, 'Romance', 12.50),
    ('The Stranger', 'Albert Camus', 1942, 'Philosophical', 9.99),
    ('The Plague', 'Albert Camus', 1947, 'Philosophical', 10.25),
    ('The Little Prince', 'Antoine de Saint-Exupéry', 1943, 'Children', 8.99),
    ('Les Misérables', 'Victor Hugo', 1862, 'Classic', 14.99),
    ('The Hunchback of Notre-Dame', 'Victor Hugo', 1831, 'Classic', 12.75),
    ('The Count of Monte Cristo', 'Alexandre Dumas', 1844, 'Adventure', 13.50),
    ('The Three Musketeers', 'Alexandre Dumas', 1844, 'Adventure', 12.99),
    ('The Call of the Wild', 'Jack London', 1903, 'Adventure', 8.99),
    ('The Grapes of Wrath', 'John Steinbeck', 1939, 'Drama', 10.99),
    ('Of Mice and Men', 'John Steinbeck', 1937, 'Drama', 8.75),
    ('East of Eden', 'John Steinbeck', 1952, 'Drama', 12.25),
    ('The Hitchhiker''s Guide to the Galaxy', 'Douglas Adams', 1979, 'Science Fiction', 10.75),
    ('The Martian', 'Andy Weir', 2011, 'Science Fiction', 11.25),
    ('Ready Player One', 'Ernest Cline', 2011, 'Science Fiction', 10.50),
    ('Life of Pi', 'Yann Martel', 2001, 'Adventure', 9.99),
    ('The Shadow of the Wind', 'Carlos Ruiz Zafón', 2001, 'Mystery', 12.50),
    ('Angels & Demons', 'Dan Brown', 2000, 'Thriller', 10.99),
    ('Inferno', 'Dan Brown', 2013, 'Thriller', 12.25),
    ('The Pillars of the Earth', 'Ken Follett', 1989, 'Historical', 13.99),
    ('The Stand', 'Stephen King', 1978, 'Horror', 14.99);


CREATE TABLE purchases (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    user_id INTEGER NOT NULL,
    book_id INTEGER NOT NULL,
    price NUMERIC NOT NULL,
    purchase_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (book_id) REFERENCES books(id)
);

CREATE INDEX purchases_user_id ON purchases(user_id);