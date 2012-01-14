desc "This task stores a backup of the production DB in S3"
task :backupDB => :environment do
  puts "Backing up db..."
  HerokuS3Backup.backup
  puts "...done backing up db."
end