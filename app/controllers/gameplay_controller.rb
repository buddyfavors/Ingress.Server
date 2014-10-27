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
    location = params['params']['location'];
    location = location.split(',')
    location.each_index do |index|
      location[index] = Integer(location[index]) / 1E6
    end
    client = GooglePlaces::Client.new('AIzaSyA9eiiu-ZcQPlRcYiz-XFIt5C2ZfHvaieM')
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
    entities = [];

    spots.each do |spot|
      entity = [
          # guid
          spot.id,
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
                      'ADDRESS' => spot.vicinity
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
      entities.push(entity)
    end

    render json: {
        'gameBasket' => {
            'gameEntities' => entities
        }
    }
  end
end
