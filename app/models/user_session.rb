class UserSession < Authlogic::Session::Base
  def self.oauth_consumer
    OAuth::Consumer.new("P5QrZaAhjYe7UEMiOtTPw", "H2CUMMfmvcjBtnaOG3Jt4kkRqA9sv0izrI7LZ52k", {
      :site=>"http://twitter.com",
      :authorize_url => "http://twitter.com/oauth/authenticate"
    })
  end
end
