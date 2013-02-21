#run once to migrate existing user's profile photos from the playdate photos table to the profile photos table
task :migrate_profile_photos => :environment do
  User.all.each do |user|
    puts "Migrating profile photo for user #{user.displayName}..."
    p = user.profile_photos.new
    p.photo = user.playdate_photos.first.photo
    p.save
  end
end