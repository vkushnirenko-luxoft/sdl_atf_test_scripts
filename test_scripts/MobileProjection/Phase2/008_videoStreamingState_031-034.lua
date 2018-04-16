---------------------------------------------------------------------------------------------------
-- Issue:
---------------------------------------------------------------------------------------------------
--[[ Required Shared libraries ]]
local common = require('test_scripts/MobileProjection/Phase2/common')
local runner = require('user_modules/script_runner')

--[[ Test Configuration ]]
runner.testSettings.isSelfIncluded = false

--[[ Local Variables ]]
local testCases = {
  [1] = { t = "NAVIGATION", m = true,  s = "NOT_STREAMABLE", e = "DEACTIVATE_HMI" },
  [2] = { t = "NAVIGATION", m = false, s = "NOT_STREAMABLE", e = "DEACTIVATE_HMI" },
  [3] = { t = "PROJECTION", m = true,  s = "NOT_STREAMABLE", e = "DEACTIVATE_HMI" },
  [4] = { t = "PROJECTION", m = false, s = "NOT_STREAMABLE", e = "DEACTIVATE_HMI" }
}

--[[ Local Functions ]]
local function sendEvent(pTC, pEvent, pVideoSS)
  common.getHMIConnection():SendNotification("BasicCommunication.OnEventChanged", {
    eventName = pEvent,
    isActive = true })
  common.getMobileSession():ExpectNotification("OnHMIStatus")
  :ValidIf(function(_, data)
      return common.checkVideoSS(pTC, "App1", pVideoSS, data.payload.videoStreamingState)
    end)
end

--[[ Scenario ]]
for n, tc in common.spairs(testCases) do
  runner.Title("TC[" .. common.getTCNum(testCases, n) .. "]: "
    .. "[hmiType:" .. tc.t .. ", isMedia:" .. tostring(tc.m) .. ", event:" .. tc.e .. "]")
  runner.Step("Clean environment", common.preconditions)
  runner.Step("Start SDL, HMI, connect Mobile, start Session", common.start)
  runner.Step("Set App Config", common.setAppConfig, { 1, tc.t, tc.m })
  runner.Step("Register App", common.registerApp)
  runner.Step("Activate App", common.activateApp)
  runner.Step("Send event from HMI: " .. tc.e, sendEvent, { n, tc.e, tc.s })
  runner.Step("Clean sessions", common.cleanSessions)
  runner.Step("Stop SDL", common.postconditions)
end
runner.Step("Print failed TCs", common.printFailedTCs)
