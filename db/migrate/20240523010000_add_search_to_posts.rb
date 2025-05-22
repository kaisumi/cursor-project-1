class AddSearchToPosts < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      ALTER TABLE posts ADD COLUMN tsv tsvector;
      CREATE INDEX posts_tsv_idx ON posts USING gin(tsv);
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON posts FOR EACH ROW EXECUTE FUNCTION
      tsvector_update_trigger(tsv, 'pg_catalog.english', content);
    SQL
  end
  
  def down
    execute <<-SQL
      DROP TRIGGER tsvectorupdate ON posts;
      DROP INDEX posts_tsv_idx;
      ALTER TABLE posts DROP COLUMN tsv;
    SQL
  end
end
