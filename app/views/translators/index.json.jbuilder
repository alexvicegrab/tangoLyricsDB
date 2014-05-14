json.array!(@translators) do |translator|
  json.extract! translator, :id, :name, :site_name, :site_link, :translations_count
  json.url translator_url(translator, format: :json)
end
