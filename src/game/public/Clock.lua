
local Clock = {}
setmetatable(Clock,{__index = _G})
setfenv(1,Clock)


local timeDelta      = 0  --与服务器时间偏移量
local timeZoneSec    = 0  --服务器时区对应的秒数
local serverOpenTime      --开服时间
local playerCreateTime    --获取玩家角色创建时间
local m_collatedFlag = 0  --是否同步过时间


--获取服务器当前时间(时区为0), 即UTC时间
--asTable：是否以table格式返回
function getCurServerTime(asTable)
  local utcTime = os.time() + timeDelta
  if asTable then 
    return os.date("!*t", utcTime)
  end 

  return utcTime 
end 

--获取服务器当前时间(考虑时区)
--asTable：是否以table格式返回
function getCurServerTimeWithTimezone(utcTime, asTable)
  local time = utcTime or getCurServerTime()
  time = time + timeZoneSec 
  if asTable then 
    return os.date("!*t", time)
  end 

  return time 
end 

-- 同步服务器时间, 计算时间的差值
function ntpServerTime()
  local ret = false
  local function onRecv(result, msgData)
    if result then
      timeDelta = tonumber(msgData.Time) - os.time()
      timeZoneSec = msgData.Time_Zone       
      m_collatedFlag = 1 
      ret = true
    end
  end

  g_http.postData("common/ntpdate",{}, onRecv)
  m_lastCollateTime = os.time()

  return ret
end


-- 同步服务器时间, 异步
function ntpServerTime_Async()
  local function onRecv(result, msgData)
    if result then
      timeDelta = tonumber(msgData.Time) - os.time()
      timeZoneSec = msgData.Time_Zone 
      m_collatedFlag = 1 
    end
  end
  g_http.postData("common/ntpdate", {}, onRecv, true)
  m_lastCollateTime = os.time() 
end


--获取开服时间
function getServerOpenTime()
  return serverOpenTime
end 

--设置开服时间
function setServerOpenTime(openTime)
  serverOpenTime = openTime 
end 

--获取玩家角色创建时间
function getPlayerCreateTime()
  return playerCreateTime 
end 

--设置角色创建时间
function setPlayerCreateTime(createTime)
  playerCreateTime = createTime 
end 


--将日期转换为标准时间秒：如 20141011 --->utc second
function getUtcTimeByDate(date)
  local yy = math.floor(date/10000)
  local mm = math.floor((date-yy*10000)/100)
  local dd = date - yy*10000 - mm*100
  local utcTime = os.time({year=yy, month=mm, day=dd, hour=0,min=0, sec=0})

  return utcTime 
end 

--时间段转换为时分秒
function formatTimeHMS(time)
  if time < 0 then time = 0 end
  local hour = math.floor(time/3600)
  local min = math.floor((time%3600)/60)
  local sec = math.floor(time%60)
  return hour,min,sec
end

--是否为同一天
function isSameDay(utcTime1, utcTime2)
  local day1 = os.date("!%d" , utcTime1 + timeZoneSec)
  local day2 = os.date("!%d" , utcTime2 + timeZoneSec)

  return day1==day2
end 

--是否同步过
function isTimeCollated()
  return m_collatedFlag 
end 

return Clock
