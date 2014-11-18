class GameplayController < ApplicationController
  protect_from_forgery :except => [:findNearbyPortals, :getObjectsInCells]

  def collectItemsFromPortal
    render json: {
        'error' => 'TOO_OFTEN'
    }
  end

  def findNearbyPortals
    render json: {
        'result' => [
            [
                # guid
                '901d258ba2b94c58ae39d3585a8ff287',
                # timestamp
                1412819501000,
                {
                    'locationE6' => {
                        'latE6' => 40.42511 * 1E6,
                        'lngE6' => -86.914969 * 1E6
                    },
                    'controllingTeam' => {
                        'team' => 'RESISTANCE'
                    },
                    'imageByUrl' => {
                        'imageUrl' => 'http://www.sanjoseca.gov/images/pages/N2326/Station%202.jpg'
                    },
                    'portalV2' => {
                        'descriptiveText' => {
                            'TITLE' => 'Police Station',
                            'ADDRESS' => '123 fake street'
                        }
                    }
                }
            ]
        ]
    }
  end

  def getObjectsInCells
    entities = [];

    # Parse the location.
    location = params['params']['location'];
    location = location.split(',')
    location.each_index do |index|
      location[index] = Integer(location[index]) / 1E6
    end

    # Find the nearest portals first.
    nearestPortals = Portal.findNearestPortals(location[0], location[1])

    # Check if there are any portals
    if nearestPortals.any?
      nearestPortals.each do |nearestPortal|
        entities.push(Portal.fromPortal(nearestPortal))
      end

      render json: {
          'gameBasket' => {
              'gameEntities' => entities
          }
      }
      return
    end

    # Find the portals from Google Places API.
    client = GooglePlaces::Client.new('AIzaSyB9LpJo5WMXorrPYRjHBwEtyN4ddTwQqrQ')
    spots = client.spots(location[0], location[1], :radius => 200, :types => [
        'church',
        'cemetery',
        'city_hall',
        'courthouse',
        'embassy',
        'fire_station',
        'funeral_home',
        'hindu_temple',
        'hospital',
        'library',
        'museum',
        'park',
        'place_of_worship',
        'police',
        'post_office',
        'school',
        'stadium',
        'university',
        'zoo'
    ])

    # Check if there are any places
    if spots.any?
      spots.each do |spot|
        entities.push(Portal.fromGooglePlace(spot))
      end

      render json: {
          'gameBasket' => {
              'gameEntities' => entities
          }
      }
      return
    end

    render json: {
        'gameBasket' => {
            'gameEntities' => entities
        }
    }
  end
end
