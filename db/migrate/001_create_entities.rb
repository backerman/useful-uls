class CreateEntities < Sequel::Migration
  def up
    create_table :entities do
      primary_key :id
      
    end
  end

  def down
    drop_table :entities
  end
end
