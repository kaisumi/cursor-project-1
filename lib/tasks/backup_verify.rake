namespace :backup do
  desc "Verify database backup"
  task verify_database: :environment do
    backup_dir = Rails.root.join("backups")
    latest_backup = Dir.glob(File.join(backup_dir, "*.sql")).max_by { |f| File.mtime(f) }
    
    if latest_backup.nil?
      puts "No database backups found locally"
      
      # Check S3 if configured
      if defined?(S3_BUCKET) && S3_BUCKET
        s3_backups = S3_BUCKET.objects(prefix: "database_backups/").sort_by(&:last_modified).last
        if s3_backups
          puts "Found backup on S3: #{s3_backups.key}"
          latest_backup = File.join(backup_dir, File.basename(s3_backups.key))
          s3_backups.download_file(latest_backup)
          puts "Downloaded S3 backup to #{latest_backup}"
        else
          puts "No database backups found on S3"
          exit 1
        end
      else
        exit 1
      end
    end
    
    # Test restore to temporary database
    test_db = "backup_test_#{Time.now.to_i}"
    begin
      system "createdb #{test_db}"
      system "pg_restore -d #{test_db} #{latest_backup}"
      
      # Count rows in a table to verify data
      conn = PG.connect(dbname: test_db)
      user_count = conn.exec("SELECT COUNT(*) FROM users").getvalue(0, 0)
      
      puts "Backup verification successful. Found #{user_count} users in backup."
    ensure
      conn&.close
      system "dropdb #{test_db}"
    end
  end
  
  desc "Verify S3 backups"
  task verify_s3: :environment do
    unless defined?(S3_BUCKET) && S3_BUCKET
      puts "S3 not configured"
      exit 1
    end
    
    # Check database backups
    db_backups = S3_BUCKET.objects(prefix: "database_backups/").sort_by(&:last_modified)
    puts "Found #{db_backups.count} database backups on S3"
    
    # Check uploads backups
    upload_backups = S3_BUCKET.objects(prefix: "uploads_backups/").sort_by(&:last_modified)
    puts "Found #{upload_backups.count} uploads backups on S3"
    
    if db_backups.empty? && upload_backups.empty?
      puts "No backups found on S3"
      exit 1
    else
      puts "S3 backup verification successful"
    end
  end
end
