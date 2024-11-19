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

