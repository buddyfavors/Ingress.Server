class HandshakeController < ApplicationController
  def index
    cookies[:SACSID] = 'TODO'
    render text: 'TOOOOOODO' + ActiveSupport::JSON.encode({
        'result' => {
            'canPlay' => true,
            'nickname' => 'QAZZY',
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
        }
    })
    response.content_type = 'application/json'
  end
end
