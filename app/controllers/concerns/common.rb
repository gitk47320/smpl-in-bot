module Common
  require 'net/http'
  require 'uri'
  require 'json'

  $clientid  = 'dj00aiZpPVhMajZLNzNxdUhabyZzPWNvbnN1bWVyc2VjcmV0Jng9OGM-'
  $secret    = 'hCwVoyAW  Cu9hVcgf3OTX2Jwe1Ge8WEmwA7pbCYlX'

  def getlatlon(place)
    # p place
    reqlatlonprm  = URI.encode_www_form(
      {
        appid: $clientid, 
        query: place, 
        recursive: true,
        sort: 'address2',
        output: 'json'
      }
    )
    reqlatlonuri  = URI.parse("https://map.yahooapis.jp/geocode/cont/V1/contentsGeoCoder?#{reqlatlonprm}")
    # p uri
    reslatlon     = Net::HTTP.get(reqlatlonuri)
    reslatlon_j   = JSON.parse(reslatlon)
    # p result
    latloninfo    = reslatlon_j["Feature"][0]["Geometry"]["Coordinates"].split(",")
    p latloninfo
    return latloninfo
  end

  def getlatlonimage(lat, lon)
    # p latlon
    reqlatlonimgprm = URI.encode_www_form(
      {
        appid: $clientid, 
        lat: lat, 
        lon: lon, 
        z:15, 
        mode: 'map'
      }
    )
    reqlatlonimguri = URI.parse("https://map.yahooapis.jp/map/V1/static?#{reqlatlonimgprm}")
  end

  def getAddress(lat, lon)
    reqAddressprm  = URI.encode_www_form(
      {
        appid: $clientid,
        lat: lat,
        lon: lon,
        output: 'json'
      }
    )
    reqAddressuri  = URI.parse("https://map.yahooapis.jp/geoapi/V1/reverseGeoCoder?#{reqAddressprm}")
    p reqAddressuri
    resAddress     = Net::HTTP.get(reqAddressuri)
    resAddress_j   = JSON.parse(resAddress)
    addressinfo    = resAddress_j["Feature"][0]["Property"]["Address"]
  end
end

#latlon = [11,12]

#print URI.parse("https://www.google.co.jp/maps/@"+"#{latlon[1]},#{latlon[0]},15z")

