class Entity < Sequel::Model(:pubacc_en)
  set_primary_key [:unique_system_identifier, :entity_type]
end
