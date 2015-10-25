defmodule DataParserTest do

  use ExUnit.Case

  import Forecast.DataParser, only: [
    parse_response: 1,
    step_func: 2,
  ]

  def sample_response do
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
      title: "Yahoo! Weather - Amsterdam, NL",

      #[{'temperature', 'C'}, {'speed', 'km/h'}, {'pressure', 'mb'},
      units: [ temperature: "C",  speed: "km/h", pressure: "mb", distance: "km" ],

      #{'wind', [{'speed', '20.92'}, {'direction', '200'}, {'chill', '11'}],
      wind: "↓ 21km/h",

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

      week: [
        [ text: "Cloudy",        day: "Wed", low: "11", high: "13", date: "21 Oct 2015" ],
        [ text: "AM Showers",    day: "Thu", low: "9",  high: "14", date: "22 Oct 2015" ],
        [ text: "Mostly Sunny",  day: "Fri", low: "8",  high: "14", date: "23 Oct 2015" ],
        [ text: "Mostly Cloudy", day: "Sat", low: "10", high: "13", date: "24 Oct 2015" ],
        [ text: "AM Light Rain", day: "Sun", low: "7",  high: "12", date: "25 Oct 2015" ],
      ],
    }

    assert parse_response(sample_response()) == expected_res
  end

  test "step_func" do
    steps = [
      0, 45, 90, 135, 180, 225, 270, 315, 360
    ]

    assert( step_func( steps, 0 ) == 0 )
    assert( step_func( steps, 25 ) == 45 )
    assert( step_func( steps, 46 ) == 90 )
    
  end



end

