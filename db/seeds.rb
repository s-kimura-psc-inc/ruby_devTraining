# ユーザ

SYSTEM_USER = 'system'.freeze

ApplicationRecord.connection.execute("TRUNCATE #{User.table_name}")
User.create(login: "user-1", password: 'password', password_confirmation: 'password', user_nm: "ユーザー1", authority_level: Constants::AUTHORITY_LEVEL_GENERAL[:value], created_by: SYSTEM_USER, updated_by: SYSTEM_USER)
User.create(login: "admin-1", password: 'password', password_confirmation: 'password', user_nm: "システム管理者1", authority_level: Constants::AUTHORITY_LEVEL_ADMIN[:value], created_by: SYSTEM_USER, updated_by: SYSTEM_USER)

