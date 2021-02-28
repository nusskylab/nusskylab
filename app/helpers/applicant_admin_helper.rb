module ApplicantAdminHelper
    # input args: arrays of IDs
    # returns: applicant to teams hashes 
    def getEvaluatedTeams(beginI, endI, teamIDs, size)
        if beginI + size - 1 > endI
            teamsBack = teamIDs[beginI..teamIDs.length() - 1]
            teamsFront = teamIDs[0..endI]
            teams = teamsFront + teamsBack
        else
            teams = teamIDs[beginI..endI]
        end
        return teams
    end
    
    def applicant_to_team_matching(teamIDs, size, team_to_persons)
        matching = Hash.new
        teamIDs = teamIDs.shuffle
        teamIDs.each_with_index do |teamID, i|
            members = get_team_members[teamID]
            member1 = members.at(0).id
            member2 = members.at(1).id
            member1Begin = i % teamIDs.length()
            member1End = (i + size - 1) % teamIDs.length()
            member2Begin = (i + size) % teamIDs.length()
            member2End = (i + size + size - 1) % teamIDs.length()
            teamsBy1 = getEvaluatedTeams(member1Begin, member1End, teamIDs, size)
            teamsBy2 = getEvaluatedTeams(member2Begin, member2End, teamIDs, size)
            matching[member1] = teamsBy1
            matching[member2] = teamsBy2
        end
        return matching
    end
end