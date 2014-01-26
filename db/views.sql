--- Web front-end views

-- System view
CREATE OR REPLACE VIEW systems AS
  SELECT en.unique_system_identifier, license_status, radio_service_code,
         en.call_sign, entity_name, attention_line, city, state, zip_code
  FROM   pubacc_en en
  JOIN   pubacc_hd hd
  ON     en.unique_system_identifier = hd.unique_system_identifier
  WHERE  entity_type='L';

-- Sphinx index view for pubacc_en

CREATE OR REPLACE VIEW entity_concatenated AS
  SELECT unique_system_identifier,
         string_agg(distinct lower(entity_name), ' ') idx_entity_name,
         string_agg(distinct lower(attention_line), ' ') idx_attention_line
  FROM pubacc_en
  GROUP BY unique_system_identifier;

CREATE OR REPLACE VIEW entity_sphinx_view AS
  SELECT    l.unique_system_identifier usi,
            l.idx_entity_name entity_name,
            l.idx_attention_line attention_line,
            en.entity_name licensee_name,
            en.attention_line licensee_attn
  FROM      pubacc_en en, entity_concatenated l
  WHERE     l.unique_system_identifier = en.unique_system_identifier
            AND en.entity_type = 'L';
