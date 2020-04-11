#!/usr/bin/env ruby

require 'rubygems'
require 'roo'

FILENAME = 'Orbital Registration (Responses).xlsx'
SQLFILE = 'sql.txt'
$studid = 20
$teamid = 2500

def parseExcel()
    # open spreadsheet with extension .xlxs
    workbook = Roo::Spreadsheet.open(FILENAME, extension: :xlsx)
    workbook = Roo::Excelx.new(FILENAME)

    mainSheet = workbook.sheet(0)

    # parsing method for unique headers
    #mainSheet = mainSheet.parse(Matric1: "Matric No of Team Member 1", Matric2: "Matric No of Team Member 2", Member1: "Your name? (As shown in your student card)", Member2: "Name of Team Member 2", Level: "Desired Level of Achievement", clean: true);

    teamInfo = {}

    counter = 2
    mainSheet.each_row_streaming(offset: 1) do |row|
        userName1 = mainSheet.cell('D',counter)
        userName2 = mainSheet.cell('I',counter)
        nusnetId1 = mainSheet.cell('H',counter)
        nusnetId2 = mainSheet.cell('M',counter)
        studentNo1 = mainSheet.cell('E',counter)
        studentNo2 = mainSheet.cell('J',counter)
        teamName = mainSheet.cell('N',counter)
        cohort = mainSheet.cell('G',counter)
        info = Array.new
        info << userName1
        info << nusnetId1
        info << studentNo1
        info << userName2
        info << nusnetId2
        info << studentNo2
        info << cohort
        teamInfo[teamName] = info
        counter += 1 
    end
    return teamInfo
end

def sqlCreator(teamInfo)

    allSqlStmts = Array.new

    teamInfo.each do |teamName, values|
    # create sql for table users
	allSqlStmts << (createInsertIntoUsers(values[0], values[1], values[2]))
	allSqlStmts << (createInsertIntoUsers(values[3],  values[4], values[5]))
	
	# create sql for table teams
	allSqlStmts << (createInsertIntoTeams(teamName, values[6]))    	
	
	# create sql for table students
	allSqlStmts << (createInsertIntoStudent values[2])
	allSqlStmts << (createInsertIntoStudent values[5])
	$teamid += 1
    end
    return allSqlStmts
end

def createInsertIntoUsers(userName, nusnetId, matricNo)
 stmt = "INSERT INTO users (uid, email, user_name, matric_number, provider) VALUES (\'https://openid.nus.edu.sg/"+ nusnetId +"\', \'"+nusnetId+"@u.nus.edu', \'"+userName+"\', \'"+matricNo+"\', 1);"
    return stmt
end

def createInsertIntoTeams(teamName, cohort)
    stmt = "INSERT INTO teams (id, created_at, updated_at, cohort, team_name) VALUES (#{$teamid}, current_timestamp, current_timestamp, #{cohort}, \"" + teamName + "\");"
    return stmt
end

def createInsertIntoStudent(matricNo)
    stmt = "INSERT INTO students (user_id, created_at, updated_at, team_id) SELECT cast(id as integer), current_timestamp, current_timestamp," + $teamid.to_s + " FROM users WHERE matric_number = \'"
    stmt2 = "\';"
    finalStmt = ""
    finalStmt += stmt + matricNo + stmt2
    return finalStmt
end

def writeSqlToFile(stmts)
    File.open(SQLFILE, "w+") do |f|
	stmts.each { |element| f.puts(element) }
    end
end

def printSqlStmts(stmts)
    stmts.each do |sql|
	puts sql
    end
end

# MAIN PROGRAM
# extract data from excel sheet
puts "|| Extraction in progress ... ||"
extracted = parseExcel

# create insertion sql statements
puts "|| Crunching SQL Statements ... ||"
allSqlStmts = Array.new
allSqlStmts = sqlCreator extracted

# print sql statements
#printSqlStmts allSqlStmts

# write sql to file 'sql.txt'
puts "|| Writing SQL to sql.txt ... ||"
writeSqlToFile allSqlStmts
