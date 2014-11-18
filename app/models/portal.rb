class Portal < ActiveRecord::Base
  def self.findNearestPortals(playerLatitude, playerLongitude)
    # Distance algorithm: http://andrew.hedges.name/experiments/haversine

    #   a = (sin((lat2 - lat1)/2))^2 + cos(lat1) * cos(lat2) * (sin((lon2 - lon1)/2))^2
    #   c = 2 * atan2( sqrt(a), sqrt(1-a) )
    #   d = R * c (where R is the radius of the Earth)

    #   lat1 = 38.898556
    #   lon1 = -77.037852
    #   lat2 = 38.897147
    #   long2 = -77.043934
    #   d = 0.341 miles
    #   d = 0.549 kilometers

    earthRadiusMiles = '3961'
    degreesToRadians = '57.2958'
    portalRange = '0.1'

    distanceSubquery = '((sin(((%{playerLatitude} / %{degreesToRadians}) - (latitude / 1E6 / %{degreesToRadians})) / 2))^2 + cos(latitude / 1E6 / %{degreesToRadians}) * cos((%{playerLatitude} / %{degreesToRadians})) * (sin(((%{playerLongitude} / %{degreesToRadians}) - (longitude / 1E6 / %{degreesToRadians})) / 2))^2))'
    distanceSubquery = '(2 * atan2(sqrt(%{distanceSubquery}, sqrt(1 - %{distanceSubquery})) * %{earthRadiusMiles}' % {
        :distanceSubquery => distanceSubquery,
        :earthRadiusMiles => earthRadiusMiles
    }
    distanceSubquery = distanceSubquery % {
        :degreesToRadians => degreesToRadians,
        :playerLatitude => playerLatitude,
        :playerLongitude => playerLongitude
    }
    return Portal.select(distanceSubquery + ' as distance, *').order('distance ASC').where(distanceSubquery + ' <= ' + portalRange)
  end

  def self.fromPortal(portal)
    return [
        # guid
        portal.googlePlaceId,
        # timestamp
        1412819501000,
        {
            'locationE6' => {
                'latE6' => portal.latitude * 1E6,
                'lngE6' => portal.longitude * 1E6
            },
            'resourceWithLevels' => {
                'resourceType' => nil
            },
            'modResource' => {
                'resourceType' => nil
            },
            'controllingTeam' => {
                'team' => ''
            },
            'imageByUrl' => {
                'imageUrl' => portal.imageUrl
            },
            'portalV2' => {
                'descriptiveText' => {
                    'TITLE' => portal.name,
                    'ADDRESS' => nil # TODO: Not tested, might throw an error.
                },
                'linkedModArray' => [
                    nil,
                    nil,
                    nil,
                    nil
                ]
            },
            'captured' => {
                'capturingPlayerId' => '40e2a146907e493fa1902705c46eba78',
                'nickname' => 'uncaptured'
            },
            'resonatorArray' => {
                'resonators' => [
                    nil,
                    nil,
                    nil,
                    nil,
                    nil,
                    nil,
                    nil,
                    nil
                ]
            }
        }
    ]
  end

  def self.fromGooglePlace(spot)
    if !Portal.find_by_googlePlaceId(spot.place_id)
      portal = Portal.new
      portal.name = spot.name.truncate(50)
      portal.latitude = spot.lat * 1E6
      portal.longitude = spot.lng * 1E6
      portal.imageUrl = spot.icon
      portal.googlePlaceId = spot.place_id
      portal.save
    end

    return [
        # guid
        spot.place_id,
        # timestamp
        1412819501000,
        {
            'locationE6' => {
                'latE6' => spot.lat * 1E6,
                'lngE6' => spot.lng * 1E6
            },
            'resourceWithLevels' => {
                'resourceType' => nil
            },
            'modResource' => {
                'resourceType' => nil
            },
            'controllingTeam' => {
                'team' => ''
            },
            'imageByUrl' => {
                'imageUrl' => spot.icon
            },
            'portalV2' => {
                'descriptiveText' => {
                    'TITLE' => spot.name,
                    'ADDRESS' => nil # TODO: Not tested, might throw an error.
                },
                'linkedModArray' => [
                    nil,
                    nil,
                    nil,
                    nil
                ]
            },
            'captured' => {
                'capturingPlayerId' => '40e2a146907e493fa1902705c46eba78',
                'nickname' => 'uncaptured'
            },
            'resonatorArray' => {
                'resonators' => [
                    nil,
                    nil,
                    nil,
                    nil,
                    nil,
                    nil,
                    nil,
                    nil
                ]
            }
        }
    ]
  end
end
