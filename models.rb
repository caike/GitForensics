require 'sequel'
require 'grit'

DB = Sequel.sqlite('git-forensics.sqlite3')

class Project < Sequel::Model
  one_to_many :commits

  def self.import_from_path(project_path)
    project = Project.create(url: project_path)
    grit_repo = Grit::Repo.new(project.url)
    grit_commits = grit_repo.log

    grit_commits.each do |grit_commit|
      commit = Commit.create(project_id: project.id, sha: grit_commit.sha)
      grit_commit.show.each do |f|
        CommitFile.create(commit_id: commit.id, name: f.a_path)
      end
    end
  end
end

class Commit < Sequel::Model
  many_to_one :project
  one_to_many :commit_files
end

class CommitFile < Sequel::Model
  many_to_one :commit


  def calculate_change_rate
    commits_with_this = self.commits_with_this_file # same shas!
    all_files_in_commits = []

    files_in_each_commit = commits_with_this.map do |commit|
      # weird bug where commit.commit_files returns
      # a different result than Commit.where(sha: commit.sha).first.commit_files
      commit = Commit.where(sha: commit.sha).first
      file_names = commit.commit_files.map(&:name)

      all_files_in_commits << file_names

      {
        commit_id: commit.id,
        file_names: file_names
      }
    end


    # sanitize
    all_files_in_commits.flatten!.uniq!
    all_files_in_commits.delete(self.name)

    change_rates = all_files_in_commits.map do |file|

      times_in_commits = files_in_each_commit.select { |fc|
        fc[:file_names].include?(file)
      }.size


      {
        file_name: file,
        change_rate: ((times_in_commits.to_f / revisions) * 100)
      }
    end

    change_rates.sort { |a,b| b[:change_rate] <=> a[:change_rate] }
  end

  def commits_with_this_file
    @_commits ||= Commit.association_join(:commit_files).
      where("commit_files.name = '#{self.name}' AND commits.project_id = #{project.id}")
  end

  def project
    commit.project
  end

  def revisions
    commits_with_this_file.count
  end
end
