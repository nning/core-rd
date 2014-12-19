class CreateResourceRegistrations < ActiveRecord::Migration
  def change
    create_table :resource_registrations do |t|
      t.string  :ep, null: false
      t.string  :d
      t.string  :et
      t.integer :lt, default: 86400
      t.string  :con

      t.index   :ep, unique: true

      t.timestamps
    end
  end
end
