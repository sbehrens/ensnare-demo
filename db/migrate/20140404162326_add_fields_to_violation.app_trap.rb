# This migration comes from app_trap (originally 20131029010445)
class AddFieldsToViolation < ActiveRecord::Migration
  def change
    add_column :app_trap_violations, :session_id, :string
    add_column :app_trap_violations, :user_id, :string
    add_column :app_trap_violations, :expected, :string
    add_column :app_trap_violations, :observed, :string
  end
end
