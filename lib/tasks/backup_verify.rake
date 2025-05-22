namespace :backup do
  desc "Verify database backup"
  task verify_database: :environment do
    backup_dir = Rails.root.join("backups")
    latest_backup = Dir.glob(File.join(backup_dir, "*.sql")).max_by { |f| File.mtime(f) }
    
    if latest_backup.nil?
      puts "No database backups found"
      exit 1
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
end
