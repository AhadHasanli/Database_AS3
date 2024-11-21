# Database Normalization Assignment

## Table of Contents
1. [Introduction](#introduction)
2. [Normalization Steps](#normalization-steps)
   - [1NF: First Normal Form](#1nf-first-normal-form)
   - [2NF: Second Normal Form](#2nf-second-normal-form)
   - [3NF: Third Normal Form](#3nf-third-normal-form)
3. [Final Tables Overview](#final-tables-overview)
4. [Conclusion](#conclusion)

---

## Introduction
The goal of this assignment is to demonstrate the process of normalizing a relational database from an unnormalized state to the Third Normal Form (3NF) using SQL in a PostgreSQL environment. This project illustrates step-by-step transformations from an unnormalized dataset to fully normalized tables through 1NF, 2NF, and 3NF.

---

## Normalization Steps

### 1NF: First Normal Form
**Objective**: Eliminate multivalued attributes by ensuring each field contains only atomic values.

**Tables Created**:
- **`firstNF_table`**
  - **Primary Key**: `CRN`, `ISBN`
  - **Attributes**: `CRN`, `ISBN`, `Title`, `Author`, `Edition`, `Publisher`, `PublisherAddress`, `Pages`, `Year`, `CourseName`
  
In this step, the `Authors` column from the unnormalized table, which contained a list of comma-separated values, was transformed into individual rows to ensure atomicity.

### 2NF: Second Normal Form
**Objective**: Remove partial dependencies by creating separate tables for distinct entities, linking them through appropriate relationships.

**Tables Created**:
- **`course_details`**
  - **Primary Key**: `CRN`
  - **Attributes**: `CRN`, `CourseName`
- **`books`**
  - **Primary Key**: `ISBN`
  - **Attributes**: `ISBN`, `Title`, `Edition`, `Publisher`, `PublisherAddress`, `Pages`, `Year`
- **`author_details`**
  - **Primary Key**: `AuthorID`
  - **Attributes**: `AuthorID`, `AuthorName`
- **Relationship Table**:
  - **`coursebook`**
    - **Primary Key**: `CRN`, `ISBN`
  
By creating separate tables for books, courses, and authors, partial dependencies were removed, leading to a more structured data model.

### 3NF: Third Normal Form
**Objective**: Remove transitive dependencies by further decomposing tables, ensuring all non-key attributes depend only on the primary key.

**Tables Created**:
- **`publishers`**
  - **Attributes**: `Publisher`, `PublisherAddress`
- **`books_ThirdNF`**
  - **Primary Key**: `ISBN`
  - **Attributes**: `ISBN`, `Title`, `Edition`, `Publisher`, `Pages`, `Year`
  
The final transformation addressed transitive dependencies by creating a separate table for publishers, decoupling publisher information from the `books` table.

---

## Final Tables Overview
After completing the normalization steps, the database schema was composed of the following fully normalized tables:
- **`books_ThirdNF`**
- **`publishers`**
- **`author_details`**
- **`course_details`**
- **`coursebook`**

---

## Verification: Joining All 3NF Tables

In Step 6 of the SQL file, the 3NF tables are joined to recreate the original 1NF data structure, serving as a validation step to ensure data consistency and accuracy.

### Explanation
- **Purpose**: This join operation combines data from normalized tables (`course_details`, `coursebook`, `books_thirdnf`, `author_details`, and `publishers`) to confirm that the normalization process retained all data and relationships accurately.
- **Outcome**: Successful reconstruction verifies that all dependencies were properly addressed, resulting in an optimized schema.


## Conclusion
The normalization process from unnormalized data through 1NF, 2NF, and 3NF ensures a structured and efficient database design that minimizes redundancy and improves data integrity. Each step progressively eliminates potential anomalies and dependencies, resulting in a clean and robust relational database schema. This project demonstrates practical SQL skills in transforming data for optimal storage and retrieval.
