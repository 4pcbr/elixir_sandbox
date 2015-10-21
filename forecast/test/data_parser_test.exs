defmodule DataParserTest do

  use ExUnit.Case

  import DataParser, only: [
    parse_response: 1,
  ]

  def test_response do
    {'query',
     [{'lang', 'en-US'}, {'created', '2015-10-21T19:41:58Z'}, {'count', '1'}],
     [{'results', [],
       [{'channel', [],
         [{'title', [], ['Yahoo! Weather - Amsterdam, NL']},
          {'link', [],
           ['http://us.rd.yahoo.com/dailynews/rss/weather/Amsterdam__NL/*http://weather.yahoo.com/forecast/NLXX0002_c.html']},
          {'description', [], ['Yahoo! Weather for Amsterdam, NL']},
          {'language', [], ['en-us']},
          {'lastBuildDate', [], ['Wed, 21 Oct 2015 9:25 pm CEST']},
          {'ttl', [], ['60']},
          {'location',
           [{'region', 'NH'}, {'country', 'Netherlands'}, {'city', 'Amsterdam'}],
           []},
          {'units',
           [{'temperature', 'C'}, {'speed', 'km/h'}, {'pressure', 'mb'},
            {'distance', 'km'}], []},
          {'wind', [{'speed', '20.92'}, {'direction', '200'}, {'chill', '11'}],
           []},
          {'atmosphere',
           [{'visibility', '2.3'}, {'rising', '2'}, {'pressure', '982.05'},
            {'humidity', '100'}], []},
          {'astronomy', [{'sunset', '6:32 pm'}, {'sunrise', '8:13 am'}], []},
          {'image', [],
           [{'title', [], ['Yahoo! Weather']}, {'width', [], ['142']},
            {'height', [], ['18']}, {'link', [], ['http://weather.yahoo.com']},
            {'url', [],
             ['http://l.yimg.com/a/i/brand/purplelogo//uh/us/news-wea.gif']}]},
          {'item', [],
           [{'title', [], ['Conditions for Amsterdam, NL at 9:25 pm CEST']},
            {'lat', [], ['52.37']}, {'long', [], ['4.89']},
            {'link', [],
             ['http://us.rd.yahoo.com/dailynews/rss/weather/Amsterdam__NL/*http://weather.yahoo.com/forecast/NLXX0002_c.html']},
            {'pubDate', [], ['Wed, 21 Oct 2015 9:25 pm CEST']},
            {'condition',
             [{'text', 'Light Drizzle'}, {'temp', '11'},
              {'date', 'Wed, 21 Oct 2015 9:25 pm CEST'}, {'code', '9'}], []},
            {'description', [],
             ['\n<img src="http://l.yimg.com/a/i/us/we/52/9.gif"/><br />\n<b>Current Conditions:</b><br />\nLight Drizzle, 11 C<BR />\n<BR /><b>Forecast:</b><BR />\nWed - Cloudy. High: 13 Low: 11<br />\nThu - AM Showers. High: 14 Low: 9<br />\nFri - Mostly Sunny. High: 14 Low: 8<br />\nSat - Mostly Cloudy. High: 13 Low: 10<br />\nSun - AM Light Rain. High: 12 Low: 7<br />\n<br />\n<a href="http://us.rd.yahoo.com/dailynews/rss/weather/Amsterdam__NL/*http://weather.yahoo.com/forecast/NLXX0002_c.html">Full Forecast at Yahoo! Weather</a><BR/><BR/>\n(provided by <a href="http://www.weather.com" >The Weather Channel</a>)<br/>\n']},
            {'forecast',
             [{'text', 'Cloudy'}, {'low', '11'}, {'high', '13'}, {'day', 'Wed'},
              {'date', '21 Oct 2015'}, {'code', '26'}], []},
            {'forecast',
             [{'text', 'AM Showers'}, {'low', '9'}, {'high', '14'}, {'day', 'Thu'},
              {'date', '22 Oct 2015'}, {'code', '39'}], []},
            {'forecast',
             [{'text', 'Mostly Sunny'}, {'low', '8'}, {'high', '14'},
              {'day', 'Fri'}, {'date', '23 Oct 2015'}, {'code', '34'}], []},
            {'forecast',
             [{'text', 'Mostly Cloudy'}, {'low', '10'}, {'high', '13'},
              {'day', 'Sat'}, {'date', '24 Oct 2015'}, {'code', '28'}], []},
            {'forecast',
             [{'text', 'AM Light Rain'}, {'low', '7'}, {'high', '12'},
              {'day', 'Sun'}, {'date', '25 Oct 2015'}, {'code', '11'}], []},
            {'guid', [{'isPermaLink', 'false'}],
             ['NLXX0002_2015_10_25_7_00_CEST']}]}]}]}]}
  end


  test "parse_response" do
    expected_res = %{
      #[{'title', [], ['Yahoo! Weather - Amsterdam, NL']},
      title: 'Yahoo! Weather - Amsterdam, NL',

      #[{'temperature', 'C'}, {'speed', 'km/h'}, {'pressure', 'mb'},
      units: [ temperature: "C",  speed: "km/h", pressure: "mb" ],

      #{'wind', [{'speed', '20.92'}, {'direction', '200'}, {'chill', '11'}],
      wind: "↖ 21km/h",

      #{'atmosphere',
      #     [{'visibility', '2.3'}, {'rising', '2'}, {'pressure', '982.05'},
      #      {'humidity', '100'}], []},
      visibility: "2.3",
      pressure: "982mb",
      humidity: "100%",

      #{'astronomy', [{'sunset', '6:32 pm'}, {'sunrise', '8:13 am'}], []},
      astronomy: [ sunset: "6:32 pm", sunrise: "8:13 am" ],

      #[{'text', 'Light Drizzle'}, {'temp', '11'},
      conditions: "Light Drizzle",
      temperature: "+11 °C",

      #[{'region', 'NH'}, {'country', 'Netherlands'}, {'city', 'Amsterdam'}],
      location: "Amsterdam, NH",

      #      {'forecast',
      #       [{'text', 'Cloudy'}, {'low', '11'}, {'high', '13'}, {'day', 'Wed'},
      #        {'date', '21 Oct 2015'}, {'code', '26'}], []},
      #      {'forecast',
      #       [{'text', 'AM Showers'}, {'low', '9'}, {'high', '14'}, {'day', 'Thu'},
      #        {'date', '22 Oct 2015'}, {'code', '39'}], []},
      #      {'forecast',
      #       [{'text', 'Mostly Sunny'}, {'low', '8'}, {'high', '14'},
      #        {'day', 'Fri'}, {'date', '23 Oct 2015'}, {'code', '34'}], []},
      #      {'forecast',
      #       [{'text', 'Mostly Cloudy'}, {'low', '10'}, {'high', '13'},
      #        {'day', 'Sat'}, {'date', '24 Oct 2015'}, {'code', '28'}], []},
      #      {'forecast',
      #       [{'text', 'AM Light Rain'}, {'low', '7'}, {'high', '12'},
      #        {'day', 'Sun'}, {'date', '25 Oct 2015'}, {'code', '11'}], []},
      week: [
        [ conditions: "Cloudy", day: "Wed", tmp_low: "11", tmp_hight: "13" ],
        [ conditions: "AM Showers", day: "Thu", tmp_low: "9", tmp_hight: "14" ],
        [ conditions: "Mostly Sunny", day: "Fri", tmp_low: "8", tmp_hight: "14" ],
        [ conditions: "Mostly Cloudy", day: "Sat", tmp_low: "10", tmp_hight: "13" ],
        [ conditions: "AM Light Rain", day: "Sun", tmp_low: "7", tmp_hight: "12" ],
      ],
    }
  end


end

