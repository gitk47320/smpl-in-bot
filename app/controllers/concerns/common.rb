module Common
  require 'net/http'
  require 'uri'
  require 'json'

  $clientid  = 'dj00aiZpPVhMajZLNzNxdUhabyZzPWNvbnN1bWVyc2VjcmV0Jng9OGM-'
  $secret    = 'hCwVoyAW  Cu9hVcgf3OTX2Jwe1Ge8WEmwA7pbCYlX'

  def getlatlon(place)
    # place         = '六本木'
    reqlatlonprm  = URI.encode_www_form(
      {
        appid: $clientid, 
        query: place, 
        output: 'json'
      }
    )
    reqlatlonuri  = URI.parse("https://map.yahooapis.jp/geocode/V1/geoCoder?#{reqlatlonprm}")
    # p uri
    reslatlon     = Net::HTTP.get(reqlatlonuri)
    reslatlon_j   = JSON.parse(reslatlon)
    # p result
    latloninfo    = reslatlon_j["Feature"][0]["Geometry"]["Coordinates"].split(",")
    # p latloninfo
    return latloninfo
  end

  def getlatlonimage(lat, lon)
    # p latlon
    reqlatlonimgprm = URI.encode_www_form(
      {
        appid: clientid, 
        lat: lat, 
        lon: lon, 
        z:15, 
        mode: 'map'
      }
    )
    reqlatlonimguri = URI.parse("https://map.yahooapis.jp/map/V1/static?#{reqlatlonimgprm}")
  end
end