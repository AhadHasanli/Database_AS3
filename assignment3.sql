-- Step 1: The query of unnormalized table creation
CREATE TABLE unnormalized_form (
    CRN INTEGER,
    ISBN BIGINT,
    Title TEXT,
    Authors TEXT,
    Edition INTEGER,
    Publisher TEXT,
    PublisherAddress TEXT,
    Pages INTEGER,
    Year INTEGER,
    CourseName TEXT,
    PRIMARY KEY (CRN, ISBN)
);



-- Step 2: Import datas from Unnormalized.csv to our unnormalized_form table
COPY unnormalized_form (CRN, ISBN, Title, Authors, Edition, Publisher, PublisherAddress, Pages, Year, CourseName)
FROM 'Unnormalized.csv'
DELIMITER ';'
CSV HEADER;



-- Step 3: Transition from unnormalized_form to new table which is in 1NF, and insert datas from unnormalized_form
CREATE TABLE firstNF_table (
    CRN INTEGER,
    ISBN BIGINT,
    Title TEXT,
    Author TEXT,
    Edition INTEGER,
    Publisher TEXT,
    PublisherAddress TEXT,
    Pages INTEGER,
    Year INTEGER,
    CourseName TEXT
);

INSERT INTO firstNF_table (CRN, ISBN, Title, Author, Edition, Publisher, PublisherAddress, Pages, Year, CourseName)
SELECT 
    CRN,
    ISBN,
    Title,
	unnest(string_to_array(trim(both ' ' from REGEXP_REPLACE(Authors, '\s+', ' ', 'g')), ', ')) AS Author,
    Edition,
    Publisher,
    PublisherAddress,
    Pages,
    Year,
    CourseName
FROM unnormalized_form;

-- Step 4: Transition from 1NF to new table which is in 2NF, and insert datas from 1NF table
CREATE TABLE course_details (
    CRN INTEGER PRIMARY KEY,
    CourseName TEXT
);

INSERT INTO course_details (CRN, CourseName)
SELECT DISTINCT CRN, CourseName
FROM firstNF_table;



CREATE TABLE books (
    ISBN BIGINT PRIMARY KEY,
    Title TEXT,
    Edition INTEGER,
    Publisher TEXT,
    PublisherAddress TEXT,
    Pages INTEGER,
    Year INTEGER
);

INSERT INTO books (ISBN, Title, Edition, Publisher, PublisherAddress, Pages, Year)
SELECT DISTINCT ISBN, Title, Edition, Publisher, PublisherAddress, Pages, Year
FROM firstNF_table;



CREATE TABLE author_details (
    ISBN BIGINT,
    Author TEXT,
    FOREIGN KEY (ISBN) REFERENCES books(ISBN)
);

INSERT INTO author_details (ISBN, Author)
SELECT DISTINCT ISBN, Author
FROM firstNF_table;



CREATE TABLE coursebook (
    CRN INTEGER,
    ISBN BIGINT,
    PRIMARY KEY (CRN, ISBN),
    FOREIGN KEY (CRN) REFERENCES course_details(CRN),
    FOREIGN KEY (ISBN) REFERENCES books(ISBN)
);

INSERT INTO coursebook (CRN, ISBN)
SELECT DISTINCT CRN, ISBN
FROM firstNF_table;


-- Step 5: Transition from 2NF to new table which is in 3NF, and insert datas from 1NF table
CREATE TABLE publishers (
    Publisher TEXT PRIMARY KEY,
    PublisherAddress TEXT
);

INSERT INTO publishers (Publisher, PublisherAddress)
SELECT DISTINCT Publisher, PublisherAddress
FROM books;



CREATE TABLE books_ThirdNF (
    ISBN BIGINT PRIMARY KEY,
    Title TEXT,
    Edition INTEGER,
    Publisher TEXT,
    Pages INTEGER,
    Year INTEGER,
    FOREIGN KEY (Publisher) REFERENCES publishers(Publisher)
);

INSERT INTO books_ThirdNF (ISBN, Title, Edition, Publisher, Pages, Year)
SELECT DISTINCT ISBN, Title, Edition, Publisher, Pages, Year
FROM books;

-- Step 6: To verify if the code is working properly or not. I joined all tables which are in 3NF and see if it is the same with the table that is in 1NF.
SELECT 
    course_details.CRN,
    books_thirdnf.ISBN,
    books_thirdnf.Title,
    author_details.Author,
    books_thirdnf.Edition,
    books_thirdnf.Publisher,
    publishers.PublisherAddress,
    books_thirdnf.Pages,
    books_thirdnf.Year,
    course_details.CourseName
FROM 
    course_details
JOIN 
    coursebook ON course_details.CRN = coursebook.CRN
JOIN 
    books_thirdnf ON coursebook.ISBN = books_thirdnf.ISBN
JOIN 
    author_details ON books_thirdnf.ISBN = author_details.ISBN
JOIN 
    publishers ON books_thirdnf.Publisher = publishers.Publisher
ORDER BY 
    course_details.CRN, books_thirdnf.ISBN, author_details.Author;