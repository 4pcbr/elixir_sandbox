defmodule Forecast.Formatter.Widgets.TodayWidget do

  import Forecast.Formatter, only: [
    concat: 2,
    join_glyphs: 4,
    str_to_glyph: 1,
  ]

  def render_data(data) when is_map(data) do
    unknown     = "---"
    temperature = Map.get(data, :temperature, unknown)
    humidity    = Map.get(data, :humidity, unknown)
    wind        = Map.get(data, :wind, unknown)
    location    = Map.get(data, :location, unknown)
    conditions  = Map.get(data, :conditions, unknown)
    temp_glyph  = temperature
                    |> String.split("")
                    |> Enum.join(" ")
                    |> String.split("")
                    |> Enum.map(&String.to_char_list/1)
                    |> _char_list_to_glyphs
    join_glyphs(template, 41, 2, temp_glyph)
      |> join_glyphs( 56, 11, [ String.to_char_list( location ) ] )
      |> join_glyphs( 13, 11, [ String.to_char_list( humidity ) ] )
      |> join_glyphs( 9, 12,  [ String.to_char_list( wind ) ] )
      |> join_glyphs( 3, 2,   [ String.to_char_list( conditions ) ] )
  end

  defp _char_list_to_glyphs(['']), do: []
  defp _char_list_to_glyphs([ch]), do: glyph(ch)
  defp _char_list_to_glyphs([ch | rest]) do
    concat( glyph(ch), _char_list_to_glyphs(rest) )
  end

  def render_data(_), do: raise "The argument should be a map"

  def template do
    str_to_glyph """
    ┌---------------------------------------------------------------------------┐
    |                                                                           |
    |                                                                           |
    |                                                                           |
    |                                                                           |
    |                                                                           |
    |                                                                           |
    |                                                                           |
    |                                                                           |
    |                                                                           |
    |                                                                           |
    |  Humidity:                                                                |
    |  Wind:                                                                    |
    ├---------------------------------------------------------------------------┤
    """
  end

  def glyph(gl) do
    str_to_glyph(_str_glyph(gl))
  end

  defp _str_glyph('1') do
    """
      ## 
     ### 
    #### 
      ## 
      ## 
     ####
    """
  end

  defp _str_glyph('2') do
    """
    .###.
    #  .#
      .# 
    .#   
    #    
    #####
    """
  end

  defp _str_glyph('3') do
    """
    .###.
    *  .#
      *# 
        #
    *  .#
     ### 
    """
  end

  defp _str_glyph('4') do
    """
      .# 
     .#  
    .#  #
    #####
        #
        #
    """
  end

  defp _str_glyph('5') do
    """
    #####
    #    
    ####.
        #
        #
    #### 
    """
  end

  defp _str_glyph('6') do
    """
    .###.
    #    
    ####.
    #   #
    #   #
     ### 
    """
  end

  defp _str_glyph('7') do
    """
    #####
        #
       # 
      #  
     #   
    #    
    """
  end

  defp _str_glyph('8') do
    """
    .###.
    #   #
    .###.
    #   #
    #   #
     ### 
    """
  end

  defp _str_glyph('9') do
    """
    .###.
    #   #
     ####
        #
    .   #
     ### 
    """
  end

  defp _str_glyph('0') do
    """
    .###.
    #   #
    #   #
    #   #
    #   #
     ### 
    """
  end

  defp _str_glyph('+') do
    """
         
         
      #  
    #####
      #  
         
    """
  end

  defp _str_glyph('-') do
    """
         
         
         
    ##### 
         
         
    """
  end

  defp _str_glyph('C') do
    """
    .###.
    #   #
    #    
    #    
    #   #
     ### 
    """
  end

  defp _str_glyph('F') do
    """
    #####
    #    
    #    
    ###  
    #    
    #    
    """
  end



  defp _str_glyph(' ') do
    """
      
      
      
      
      
      
    """
  end

  defp _str_glyph('°') do
    """
    O
     
     
     
     
     
    """
  end

  defp _str_glyph(unknown) do
    raise "Unknown glyph: #{unknown}"
  end

end

