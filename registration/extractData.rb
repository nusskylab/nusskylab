#!/usr/bin/env ruby

require 'rubygems'
require 'roo'

REGFILE = 'Orbital Registration (Responses).xlsx'
PROCESSEDFILE = 'PROCESSED.xlsx'
SQLFILE = 'sql.txt'
$teamid = 2500
$advisersList = Array.new

def parseExcelUsers()
    # open spreadsheet with extension .xlxs
    workbook = Roo::Spreadsheet.open(PROCESSEDFILE, extension: :xlsx)
    workbook = Roo::Excelx.new(PROCESSEDFILE)
    mainSheet = workbook.sheet(0)
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
        adviserName = mainSheet.cell('X',counter)
	achievementLevel = mainSheet.cell('P', counter)
        info = Array.new
        info << userName1
        info << nusnetId1
        info << studentNo1
        info << userName2
        info << nusnetId2
        info << studentNo2
        info << cohort
	info << adviserName
	info << achievementLevel
        teamInfo[teamName] = info
	if not $advisersList.include?(adviserName) then $advisersList << adviserName end
        counter += 1 
    end
    return teamInfo
end

def sqlCreator(teamInfo)

    allSqlStmts = Array.new
    puts "...Generating user sqls..."

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

    #puts "...generating advisers sql..."
    #$advisersList.each do |adviserName|
	#allSqlStmts << (createInsertIntoAdvisers adviserName)
    #end

    puts "...generating updates to teams..."
    teamInfo.each do |teamName, values|
	allSqlStmts << (createUpdateTeamWithAdvisor(teamName, values[7], values[8]))
    end
    return allSqlStmts
end

def createInsertIntoUsers(userName, nusnetId, matricNo)
    stmt = "INSERT INTO users (uid, email, user_name, matric_number, provider) VALUES (\'https://openid.nus.edu.sg/"
    stmt += nusnetId.to_s
    stmt += ("\', \'" + nusnetId.to_s + "@u.nus.edu', \'" + userName.to_s + "\', \'" + matricNo.to_s + "\', 1);")
    return stmt
end

def createInsertIntoTeams(teamName, cohort)
    stmt = "INSERT INTO teams (id, created_at, updated_at, cohort, team_name) VALUES (#{$teamid}, current_timestamp, current_timestamp, #{cohort}, \'"
    stmt += teamName.to_s.gsub(/'/){ "\''" }
    stmt += "\');"
    return stmt
end

def createInsertIntoStudent(matricNo)
    stmt = "INSERT INTO students (user_id, created_at, updated_at, team_id) SELECT cast(id as integer), current_timestamp, current_timestamp," + $teamid.to_s + " FROM users WHERE matric_number = \'"
    stmt2 = "\';"
    finalStmt = ""
    finalStmt += stmt
    finalStmt += matricNo.to_s
    finalStmt += stmt2
    return finalStmt
end

def createInsertIntoAdvisers(adviserName)
    stmt = "INSERT INTO advisers (user_id, created_at, updated_at) SELECT id, current_timestamp, current_timestamp FROM users where user_name LIKE '%"
    stmt += adviserName
    stmt += "%';"
end

def createUpdateTeamWithAdvisor(teamName, adviserName, achievementLevel)
    levelNum = findTypeOfAchievement achievementLevel
    stmt = "UPDATE teams SET adviser_id = (SELECT advisers.id FROM users INNER JOIN advisers ON users.id=advisers.user_id WHERE users.user_name LIKE '%"
    stmt += adviserName
    stmt += "%'), project_level = "
    stmt += levelNum.to_s
    stmt += " WHERE team_name = '"
    stmt += teamName.to_s.gsub(/'/){ "\''" }
    stmt += "';" 
end

def findTypeOfAchievement(achievementLevel)
    if achievementLevel.downcase.include? "beginner"
	return 1
    elsif achievementLevel.downcase.include? "intermediate"
	return 2
    elsif achievementLevel.downcase.include? "advanced"
	return 3
    else
	return 4
    end
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
puts "|| Extraction in progress ... ||\n"
extracted = parseExcelUsers

# create insertion sql statements
puts "\n|| Crunching SQL Statements .. ||\n"
allSqlStmts = Array.new
allSqlStmts = sqlCreator extracted

# print sql statements
# printSqlStmts $advisersList

# write sql to file 'sql.txt'
puts "\n|| Writing SQL to sql.txt ... ||"
writeSqlToFile allSqlStmts
