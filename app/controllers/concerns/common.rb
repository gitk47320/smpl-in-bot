module Common
  require 'net/http'
  require 'uri'
  require 'json'

  $clientid  = 'dj00aiZpPVhMajZLNzNxdUhabyZzPWNvbnN1bWVyc2VjcmV0Jng9OGM-'
  $secret    = 'hCwVoyAW  Cu9hVcgf3OTX2Jwe1Ge8WEmwA7pbCYlX'

  def getlatlon(place)
    reqlatlonprm  = URI.encode_www_form(
      {
        appid: $clientid, 
        query: place, 
        output: 'json'
      }
    )
    reqlatlonuri  = URI.parse("https://map.yahooapis.jp/search/local/V1/localSearch?#{reqlatlonprm}")
    reslatlon     = Net::HTTP.get(reqlatlonuri)
    reslatlon_j   = JSON.parse(reslatlon)
    latloninfo    = reslatlon_j["Feature"][0]["Geometry"]["Coordinates"].split(",")
    return latloninfo
  end

  def getlatlonimage(lat, lon)
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
    resAddress     = Net::HTTP.get(reqAddressuri)
    resAddress_j   = JSON.parse(resAddress)
    addressinfo    = resAddress_j["Feature"][0]["Property"]["Address"]
  end

  def getShops(lat, lon)
    reqShopsprm  = URI.encode_www_form(
      {
        appid: $clientid,
        query: 'ラーメン',
        lat: lat,
        lon: lon,
        results: 3,
        output: 'json',
        sort: 'dist',
        dist: 1
      }
    )
    reqShopsuri  = URI.parse("https://map.yahooapis.jp/search/local/V1/localSearch?#{reqShopsprm}")
    resShops    = Net::HTTP.get(reqShopsuri)
    resShops_j   = JSON.parse(resShops)
  end
end
