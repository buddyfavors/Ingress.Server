class PortalDTO
  attr_accessor :id
  attr_accessor :name
  attr_accessor :latitude
  attr_accessor :longitude
  attr_accessor :imageUrl
  attr_accessor :googlePlaceId

  def initialize(portal)
    @id = portal.id
    @name = portal.name
    @latitude = portal.latitude
    @longitude = portal.longitude
    @imageUrl = portal.imageUrl
    @googlePlaceId = portal.googlePlaceId
  end
end