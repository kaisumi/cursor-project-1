namespace :backup do
  desc "Backup database"
  task database: :environment do
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    backup_dir = Rails.root.join("backups")
    FileUtils.mkdir_p(backup_dir)
    
    # Backup database
    db_config = Rails.configuration.database_configuration[Rails.env]
    db_name = db_config["database"]
    backup_file = File.join(backup_dir, "#{db_name}_#{timestamp}.sql")
    
    system "pg_dump -Fc #{db_name} > #{backup_file}"
    
    puts "Database backup created at #{backup_file}"
    
    # Upload to S3 if configured
    if defined?(S3_BUCKET) && S3_BUCKET
      s3_key = "database_backups/#{File.basename(backup_file)}"
      obj = S3_BUCKET.object(s3_key)
      obj.upload_file(backup_file)
      puts "Database backup uploaded to S3: #{s3_key}"
    end
  end
  
  desc "Backup uploads"
  task uploads: :environment do
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    backup_dir = Rails.root.join("backups")
    FileUtils.mkdir_p(backup_dir)
    
    uploads_dir = Rails.root.join("public", "uploads")
    backup_file = File.join(backup_dir, "uploads_#{timestamp}.tar.gz")
    
    if File.directory?(uploads_dir)
      system "tar -czf #{backup_file} #{uploads_dir}"
      puts "Uploads backup created at #{backup_file}"
      
      # Upload to S3 if configured
      if defined?(S3_BUCKET) && S3_BUCKET
        s3_key = "uploads_backups/#{File.basename(backup_file)}"
        obj = S3_BUCKET.object(s3_key)
        obj.upload_file(backup_file)
        puts "Uploads backup uploaded to S3: #{s3_key}"
      end
    else
      puts "No uploads directory found"
    end
  end
  
  desc "Run all backups"
  task all: [:database, :uploads]
end
