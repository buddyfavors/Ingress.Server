json.array!(@portals) do |portal|
  json.extract! portal, :id
  json.url portal_url(portal, format: :json)
end
