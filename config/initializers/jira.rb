require 'jira-ruby'
require 'dotenv'

# Load environment variables from .env file
Dotenv.load

# Get the API token from environment variables
api_token = ENV['JIRA_API_TOKEN']

@options = {
  :site               => ENV['JIRA_URL'],
  :context_path       => '',
  :username           => ENV['JIRA_USERNAME'],
  :password           => api_token,
  :auth_type          => :basic
}

client = JIRA::Client.new(@options)

project = client.Project.find('PII')

project.issues.each do |issue|
  puts "#{issue.id} - #{issue.summary}"
end
