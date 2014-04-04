# This migration comes from app_trap (originally 20131007210137)
class RenameViolationTypeField < ActiveRecord::Migration
  def change
	rename_column :app_trap_violations, :type, :violation_type
  end

end
