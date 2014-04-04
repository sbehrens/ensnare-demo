# This migration comes from app_trap (originally 20131007205246)
class CreateAppTrapViolations < ActiveRecord::Migration
  def change
    create_table :app_trap_violations do |t|
      t.string :ip_address
      t.string :type

      t.timestamps
    end
  end
end
