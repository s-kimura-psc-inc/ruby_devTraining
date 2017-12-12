# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

SYSTEM_USER = 'system'.freeze

# ユーザ

ApplicationRecord.connection.execute("TRUNCATE #{User.table_name}")
User.create(login: "user-1", password: 'password', password_confirmation: 'password', user_nm: "ユーザー1", authority_level: 1, created_by: SYSTEM_USER, updated_by: SYSTEM_USER)
User.create(login: "admin-1", password: 'password', password_confirmation: 'password', user_nm: "システム管理者1", authority_level: 2, created_by: SYSTEM_USER, updated_by: SYSTEM_USER)

