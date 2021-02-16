module ApplicantEvaluationHelper
    # input args: arrays of IDs
    # returns: applicant to teams hashes 
    def getEvaluatedTeams(beginI, endI, teamIDs)
        if endI < beginI
            teamsBack = teamIDs.slice(beginI, teamsIDs.length())
            teamsFront = teamIDs.slice(0, endI)
            teams = teamsFront + teamsBack
        else
            teams = teamIDs.slice(beginI, endI)
        end
        return teams
    end
    def applicant_to_team_matching(teamIDs, size)
        matching = Hash.new
        teamIDs = teamIDs.shuffle
        teamIDs.each_with_index do |teamID, i|
            members = get_team_members
            member1 = members[0].id
            member2 = members[1].id
            member1Begin = (i + 1) % teamIDs.length()
            member1End = (i + size) % teamIDs.length()
            member2Begin = (i + size + 1) % teamIDs.length()
            member2End = (i + size + size) % teamIDs.length()
            teamsBy1 = getEvaluatedTeams(member1Begin, member1End, teamIDs)
            teamsBy2 = getEvaluatedTeams(member2Begin, member2End, teamIDs)
            matching[:member1] = teamsBy1
            matching[:member2] = teamsBy2
        end
        return matching
    end
end