#a helper script that helps the admin rank applicant teams
#input: google form csv, students.csv
#output: a new csv file called "applicant rank.csv", with
#applicant teams ranked according to average ranking from google form responses
#the logic of this script is not straightforward. advice is to rewrite if you want to modify something
import csv
from collections import defaultdict

teamToEvaluatorEmails = defaultdict(list)
emailToFeedbacks = {}
emailTeamToSeq = {}
emailToEvaluatedTeams = defaultdict(list)
emailToEvaluatedLinks = {}
emailToTeam = {}
teamToLink = {}
noEval = defaultdict(bool)
noEvalPerson = defaultdict(bool)
evaluatedTeamsSize = 4

with open('students.csv') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    line_count = 0
    for row in csv_reader:
        if line_count > 0 and len(row) == 10 and row[8] != '':
            name = row[0]
            email = row[2]
            teamID = row[7]
            evaluatedTeamIDs = row[8].split(', ')
            evaluatedLinks = row[9].split(', ')
            emailToEvaluatedLinks[email] = evaluatedLinks
            emailToTeam[email] = teamID
            for seq, teamID in enumerate(evaluatedTeamIDs):
                teamID = teamID.strip()
                emailToEvaluatedTeams[email].append(teamID)
                teamToEvaluatorEmails[teamID].append(email)
                emailTeam = email + ' ' + teamID
                emailTeamToSeq[emailTeam] = seq
        
        line_count += 1
        
#match each team and its project links
for email in emailToEvaluatedTeams.keys():
    evaluatedTeams = emailToEvaluatedTeams[email]
    evalutedLinks = emailToEvaluatedLinks[email]
    for i in range(len(evaluatedTeams)):
        teamToLink[evaluatedTeams[i]] = evalutedLinks[i]

with open('2021 Orbital Peer Evaluation for Project Proposals.csv') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    line_count = 0
    evaluatedTeamsSize = 4
    for row in csv_reader:
        if line_count > 0:
            #to change if there is a change in size
            teamScores = []
            for i in range(1, evaluatedTeamsSize + 1):
                teamScores.append(int(row[i][0]))
            email = row[-1]
            emailToFeedbacks[email] = teamScores
        else:
            evaluatedTeamsSize = (len(row) - 2) // 2
            
        line_count += 1

for email in emailToTeam.keys():
    if email not in emailToFeedbacks.keys():
        team = emailToTeam[email]
        noEval[team] = True
        noEvalPerson[email] = True

csv_header = ['rank', 'teamID', 'average rank', 'project links', 'application status']
teamsInfo = []
for teamID in teamToEvaluatorEmails.keys():
    teamInfo = []
    # teamID
    teamInfo.append(teamID)
    
    #average rank
    evalEmails = teamToEvaluatorEmails[teamID]
    totalScore = 0
    effectiveEvals = len(evalEmails)
    #evaluator email
    for email in evalEmails:
        # assigned evaluator didn't submit feedback
        if email not in emailToFeedbacks.keys():
            effectiveEvals -= 1
            continue
        else:
            scores = emailToFeedbacks[email]
            seq = emailTeamToSeq[email + ' ' + teamID]
            score = scores[seq]
            totalScore += score
  
    avgScore = totalScore / effectiveEvals
    teamInfo.append(round(avgScore, 2))
    
    #project links
    teamInfo.append(teamToLink[teamID])
    
    #selected?
    #the team never submit peer evaluation
    if noEval[teamID]:
        teamInfo.append('cf-never submit peer evaluation')
    else:
        teamInfo.append('d-pending selection')
    teamsInfo.append(teamInfo)

teamsInfo.sort(key = lambda x:x[1])
    
#write csv
with open('applicants rank.csv', mode='w', newline='') as applicant_rank:
    rank_writer = csv.writer(applicant_rank, delimiter=',')

    rank_writer.writerow(csv_header)
    
    for rank, teamInfo in enumerate(teamsInfo):
        row = [rank + 1]
        row.extend(teamInfo)
        rank_writer.writerow(row)