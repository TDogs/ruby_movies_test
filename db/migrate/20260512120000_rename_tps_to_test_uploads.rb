class RenameTpsToTestUploads < ActiveRecord::Migration[8.1]
  def up
    if table_exists?(:tps) && !table_exists?(:test_uploads)
      rename_table :tps, :test_uploads
    end
    execute <<-SQL.squish
      UPDATE active_storage_attachments
      SET record_type = 'TestUpload'
      WHERE record_type = 'Tp'
    SQL
  end

  def down
    execute <<-SQL.squish
      UPDATE active_storage_attachments
      SET record_type = 'Tp'
      WHERE record_type = 'TestUpload'
    SQL
    if table_exists?(:test_uploads) && !table_exists?(:tps)
      rename_table :test_uploads, :tps
    end
  end
end
