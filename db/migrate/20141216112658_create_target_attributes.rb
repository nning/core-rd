class CreateTargetAttributes < ActiveRecord::Migration
  def change
    create_table :target_attributes do |t|
      t.string :type
      t.string :value

      t.references :typed_link, index: true

      t.timestamps
    end
  end
end
