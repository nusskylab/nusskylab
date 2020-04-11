## New registration process #774

### Quick Outline
The folder consist of a script to parse the data collected from spreadsheet (from google forms in xlxs) and takes a file of xlxs as an input and outputs a text file of the sql queries to be inserted into the database upon successful registration.

### Files
#### extractData.rb
This is the main ruby script to parse data from spreadsheet

#### Orbital Registration (Responses).xlsx
This is the sample response from the given registration form and used as an input tester

#### ouput: sql.txt
This file will only be created when the script has run at least once.

### Notes
A few assumptions was made during the development of the script
* The students do not have an account in skylab and the generation of account and insertion into users, teams, students
* Students are registering orbital for the first time.
* Students are NUS students with a working nusnet account.
* The column headers remain unchanged from the sample as the order of columns matter due to repeated headers.
