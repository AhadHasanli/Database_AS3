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