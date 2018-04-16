# ステータスマスタ
ApplicationRecord.connection.execute("TRUNCATE #{Status.table_name}")
CSV.foreach(Rails.root.join('db/seed/mst_statuses.csv'), headers: true, skip_blanks: true) do |row|
  Status.create(status_cd: row[0], status_nm: row[1])
end

# 優先度マスタ
ApplicationRecord.connection.execute("TRUNCATE #{Priority.table_name}")
CSV.foreach(Rails.root.join('db/seed/mst_priorities.csv'), headers: true, skip_blanks: true) do |row|
  Priority.create(priority_cd: row[0], priority_nm: row[1])
end
