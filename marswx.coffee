
pos_top		= '170px'													
pos_left	= '15px'													


goodColor = '#7dff7d'   # Bright Green
badColor = '#FF0000'   # Red
warningColor = '#00BFFF'	  # Blue

command: "curl -s 'https://api.myjson.com/bins/16jy1q'"

refreshFrequency: '1h' 

style: """
  top:	#{pos_top}
  left:	#{pos_left}
  font-family: Helvetica Neue
  color: #FFF
  
  table
	  display: block;
	  position: relative;

  table:after 
      content: "";
      background: url(Mars/icons/insight_logo.png) no-repeat;
      opacity: 0.5 ; 
      top: 0;
      left: 0;
      bottom: 0;
      right: 0;
      position: absolute;
      z-index: -1;   
 	    
 
  div
    display: block
    border: 2px solid #FFF
    text-align: center;
    vertical-align: middle;
    border-radius 5px
    text-shadow: 0 0 1px #FFF
    background: #000
    font-size: 16px
    font-weight: 400
    opacity: 0.75
    padding: 4px 8px 4px 6px
    
    &:after
      content: 'Mars Weather'
      position: absolute
      left: 0
      top: -14px
      font-size: 10px
      font-weight: 500
      color: #FFF
   
  .low
    font-size: 16px
    font-weight: 500
    color: #00FFFF
    margin: 1px

  .high
    font-size: 16px
    font-weight: 500
    color: #FFF
    margin: 1px
    
   .bgwhite
    background-color: rgb(300, 300, 300)
   
"""

render: -> """
  <div>
  <TABLE border=0>
  <tr><th><img height=20 src="Mars/icons/calendar.png"</th><td class='sol_insight'>--</td></tr>
  <tr><th><img height=20 src="Mars/icons/temperature.png"</th><td class='at_insight'>--</td></tr>
  <tr><th><img height=20 src="Mars/icons/wind.png"</th><td class='wd_insight'>--</td></tr>
  <tr><th><img height=20 src="Mars/icons/barometer.png"</th><td class='pre_insight'>--</td></tr>
  </TABLE>
  </div>
"""

update: (output,domEl) ->
  dataall = JSON.parse(output)
  availsols = dataall.sol_keys.map(Number);
  lastsol = Math.max.apply(null, availsols) 
  lastsolstr = lastsol.toString();
  data = dataall[lastsolstr]
  div			= $(domEl)

  div.find('.sol_insight').html """
  <a>Sol #{lastsolstr}</a></br>
  <a>#{data.Last_UTC.substring(0, 10)}</a>

  """

  div.find('.at_insight').html """
  <a class="low">#{Number.parseFloat(data.AT.mn).toFixed(1)}°C / #{Number.parseFloat((data.AT.mn*9.0/5.0)+32.0).toFixed(1)}°F</a></br>
  <a class="high">#{Number.parseFloat(data.AT.mx).toFixed(1)}°C / #{Number.parseFloat((data.AT.mx*9.0/5.0)+32.0).toFixed(1)}°F</a> 
  """

  div.find('.wd_insight').html """
  <table style="background: None">
  <TR><tr><td width="90%">
  <a>#{Number.parseFloat(data.HWS.av).toFixed(1)}</a> m/s</td>
  <td align="right" width="10%" rowspan=2>#{data.WD.most_common.compass_point}</a></td></tr>
  <tr><td><a>#{Number.parseFloat(data.HWS.av * 2.237).toFixed(1)} mph</a></td></tr>
  </tr></table>
  """


  div.find('.pre_insight').html """
  <a>#{Number.parseFloat(data.PRE.av/100.0).toFixed(1)} hPa</a>"""

