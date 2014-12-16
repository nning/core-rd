class CreateTypedLinks < ActiveRecord::Migration
  def change
    create_table :typed_links do |t|
      t.string :path

      t.timestamps
    end
  end
end
