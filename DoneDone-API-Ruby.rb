require "base64"
require 'net/http'

class IssueTracker
    # Provide access to the DoneDone IssueTracker API.

    def initialize(domain, token, username, password=nil, debug=nil)
        @baseURL = "https://#{domain}.mydonedone.com/IssueTracker/API/"
        @auth = calculateAuth(username, token)
        @token = token
        @result = None
        @debug = debug
    end

    def self.curlCallback(result)
        @result = result
    end

    def self.calculateAuth(username, password)
        Base64.encode64 "#{username}:#{password}"
    end

    def API(methodURL, data=nil, attachments=nil, update=false, post=false)
        url = @baseURL + methodURL
        headers = {}
        files = []

        if attachments
            request_method = Net::HTTP.post
            if attachments
                files = []
                attachments.each do |index, attachment|
                    files << 'attachment-#{index}'
        else
            request_method = Net::HTTP.get

        end

        if update
            request_method = Net::HTTP.put
        end

        if post
            request_method = Net::HTTP.post
        end

        headers[ "Authorization" ] = "Basic #{@auth}"
        request_method(url, data=data, files=files, headers=headers)
    end

    def get_projects(loadWithIssues=false)
        url = "Projects/true" if loadWithIssues else "Projects"
        self.API(url)
    end

    def get_priority_levels
        self.API("PriorityLevels")
    end

    def get_all_people_in_project(projectID)
        self.API("PeopleInProject/#{projectID}")
    end

    def get_all_issues_in_project(projectID)
        self.API("IssuesInProject/#{projec}")
    end

    def does_issue_exist(projectID, issueID)
        self.API("DoesIssueExist/#{projectID}/#{issueID}")
    end

    def get_potential_statuses_for_issue(projectID, issueID)
        self.API("PotentialStatusesForIssue/#{projectID.to_s}/#{issueID.to_s}")
    end

    def get_issue_details(projectID, issueID)
        self.API("Issue/#{projectID.to_s}/#{issueID.to_s}")
    end

    def get_people_for_issue_assignment(projectID, issueID)
        self.API("PeopleForIssueAssignment/#{projectID.to_s}/#{issueID.to_s}")
    end

    def create_issue(projectID, title, priorityID, resolverID, testerID, description="", tags="", watcherIDs="", attachments=nil)
        data = [
            ('title', title),
            ('priority_level_id', priorityID.to_s),
            ('resolver_id', resolverID.to_s),
            ('tester_id', testerID.to_s)]
        if description
            data << ('description', description)
        end

        if tags
            data << ('tags', tags)
        end

        if watcherIDs
            data << ('watcherIDs', watcherIDs.to_s)
        end

        self.API("Issue/")
