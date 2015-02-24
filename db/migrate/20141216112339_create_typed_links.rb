class CreateTypedLinks < ActiveRecord::Migration
  def change
    create_table :typed_links do |t|
      t.string :uri, null: false

      t.references :resource_registration, index: true

      t.timestamps
    end
  end
end
