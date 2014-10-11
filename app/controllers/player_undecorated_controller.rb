class PlayerUndecoratedController < ApplicationController
  protect_from_forgery :except => [:getInventory, :getPaginatedPlexts]

  def getInventory
    render json: {
        'result' => 1412819501
    }
  end

  def getPaginatedPlexts
    render json: {
        'gameBasket' => {
            'playerEntity' => [
                # guid
                '1648d89413394f9f9b1889c4c4b44a47',
                # timestamp
                1412819501000,
                {
                    'controllingTeam' => {
                        'team' => 'ALIENS'
                    },
                    'playerPersonal' => {
                        'ap' => 133700,
                        'energy' => 1000,
                        'allowNicknameEdit' => false,
                        'allowFactionChoice' => false,
                        'notificationSettings' => {
                            'shouldSendEmail' => false,
                            'shouldPushNotifyForAtPlayer' => false,
                            'shouldPushNotifyForPortalAttacks' => false
                        }
                    }
                }
            ]
        },
        'result' => [
            [
                # guid
                'ad69bafce8ed4a5e88f62a25a6f87b85',
                # timestamp
                1412819501000,
                {
                    'plext' => {
                        'text' => 'TODO',
                        'markup' => [

                        ]
                    }
                }
            ]
        ]
    }
  end
end
