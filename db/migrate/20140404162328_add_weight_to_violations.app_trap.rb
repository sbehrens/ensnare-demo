# This migration comes from app_trap (originally 20131121163305)
class AddWeightToViolations < ActiveRecord::Migration
  def change
    add_column :app_trap_violations, :weight, :integer
  end
end
