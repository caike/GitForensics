require 'sequel'

DB = Sequel.sqlite('git-forensics.sqlite3')

DB.create_table :projects do
  primary_key :id
  String :url
end

DB.create_table :commits do
  primary_key :id
  Integer :project_id, index: true
  String :sha
end

DB.create_table :commit_files do
  primary_key :id
  Integer :commit_id, index: true
  String :name
end
