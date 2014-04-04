# This migration comes from app_trap (originally 20131031001835)
class AddNameToAppTrapViolation < ActiveRecord::Migration
  def change
    add_column :app_trap_violations, :name, :string
  end
end
