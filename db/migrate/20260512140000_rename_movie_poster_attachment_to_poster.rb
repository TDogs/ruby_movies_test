class RenameMoviePosterAttachmentToPoster < ActiveRecord::Migration[8.1]
  def up
    return unless table_exists?(:active_storage_attachments)

    execute <<-SQL.squish
      UPDATE active_storage_attachments
      SET name = 'poster'
      WHERE record_type = 'Movie' AND name = 'poster_url'
    SQL
  end

  def down
    return unless table_exists?(:active_storage_attachments)

    execute <<-SQL.squish
      UPDATE active_storage_attachments
      SET name = 'poster_url'
      WHERE record_type = 'Movie' AND name = 'poster'
    SQL
  end
end
