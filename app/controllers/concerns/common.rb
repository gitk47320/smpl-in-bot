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
        output: 'json'
      }
    )
    reqlatlonuri  = URI.parse("https://map.yahooapis.jp/search/local/V1/localSearch?#{reqlatlonprm}")
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
    p resAddress_j
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
    p reqShopsuri
    resShops    = Net::HTTP.get(reqShopsuri)
    resShops_j   = JSON.parse(resShops)
    #p resShops_j
    # shopsinfo    = resShops_j["Feature"][0]["Property"]["Address"]
  end
end

#latlon = [11,12]

# getShops('カフェ',35.718586,139.927235)
