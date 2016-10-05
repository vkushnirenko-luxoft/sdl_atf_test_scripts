config.defaultProtocolVersion = 2
config.deviceMAC = "12ca17b49af2289436f303e0166030a21e525d266e209267433801a8fd4071a0"
config.SDLStoragePath = config.pathToSDL .. "storage/"
---------------------------------------------------------------------------------------------
---------------------------- Required Shared libraries --------------------------------------
---------------------------------------------------------------------------------------------

	local commonFunctions = require('user_modules/shared_testcases/commonFunctions')
	local commonSteps = require('user_modules/shared_testcases/commonSteps')
	local commonTestCases = require('user_modules/shared_testcases/commonTestCases')
	local testCasesForPolicyTable = require('user_modules/shared_testcases/testCasesForPolicyTable')

		
	DefaultTimeout = 3
	local iTimeout = 2000
	--local commonPreconditions = require ('/user_modules/shared_testcases/commonPreconditions')


---------------------------------------------------------------------------------------------
------------------------- General Precondition before ATF start -----------------------------
---------------------------------------------------------------------------------------------
	-- Precondition: remove policy table and log files
	commonSteps:DeleteLogsFileAndPolicyTable()

---------------------------------------------------------------------------------------------
---------------------------- General Settings for configuration----------------------------
---------------------------------------------------------------------------------------------
	Test = require('connecttest')

	require('cardinalities')
	local events = require('events')  
	local mobile_session = require('mobile_session')
	require('user_modules/AppTypes')
	local isReady = require('user_modules/IsReady_Template/isReady')

---------------------------------------------------------------------------------------------
------------------------------------ Common variables ---------------------------------------
---------------------------------------------------------------------------------------------
	local RPCs = commonFunctions:cloneTable(isReady.RPCs)
	local mobile_request = commonFunctions:cloneTable(isReady.mobile_request)
	local NotTestedInterfaces = commonFunctions:cloneTable(isReady.NotTestedInterfaces)
---------------------------------------------------------------------------------------------
-------------------------------------------Preconditions-------------------------------------
---------------------------------------------------------------------------------------------

--Not applicable

-----------------------------------------------------------------------------------------------
-------------------------------------------TEST BLOCK I----------------------------------------
--------------------------------Check normal cases of Mobile request---------------------------
-----------------------------------------------------------------------------------------------
-- Not applicable 

----------------------------------------------------------------------------------------------
----------------------------------------TEST BLOCK II-----------------------------------------
-----------------------------Check special cases of Mobile request----------------------------
----------------------------------------------------------------------------------------------

-- Not applicable

-----------------------------------------------------------------------------------------------
-------------------------------------------TEST BLOCK III--------------------------------------
----------------------------------Check normal cases of HMI response---------------------------
-----------------------------------------------------------------------------------------------

--List of CRQs:
	-- VR:          APPLINK-20918: [GENIVI] VR interface: SDL behavior in case HMI does not respond to IsReady_request or respond with "available" = false
	-- UI:          APPLINK-25085: [GENIVI] UI interface: SDL behavior in case HMI does not respond to IsReady_request or respond with "available" = false
	-- TTS:         APPLINK-25117: [GENIVI] TTS interface: SDL behavior in case HMI does not respond to IsReady_request or respond with "available" = false
	-- Navigation:  APPLINK-25169: [GENIVI] Navigation interface: SDL behavior in case HMI does not respond to IsReady_request or respond with "available" = false
	-- VehicleInfo: APPLINK-25200: [GENIVI] VehicleInfo interface: SDL behavior in case HMI does not respond to IsReady_request or respond with "available" = false

-----------------------------------------------------------------------------------------------

	--List of CRQs:	
		--CRQ #1) 
			-- VR:  APPLINK-25042: [VR Interface] VR.IsReady(false) -> HMI respond with successfull resultCode to splitted RPC
			-- UI:  APPLINK-25102: [UI Interface] UI.IsReady(false) -> HMI respond with successfull resultCode to splitted RPC
			-- TTS: APPLINK-25133: [TTS Interface] TTS.IsReady(false) -> HMI respond with successfull resultCode to splitted RPC
			-- VehicleInfo: Not applicable
			-- Navigation: Not applicable
		--CRQ #2) 
			-- VR:  APPLINK-25043: [VR Interface] VR.IsReady(false) -> HMI respond with errorCode to splitted RPC
			-- UI:  APPLINK-25100: [UI Interface] UI.IsReady(false) -> HMI respond with errorCode to splitted RPC
			-- TTS: APPLINK-25134: [TTS Interface] TTS.IsReady(false) -> HMI respond with errorCode to splitted RPC
			-- VehicleInfo: Not applicable
			-- Navigation:  Not applicable
		
		

		
	local TestCaseName = TestedInterface .."_IsReady_response_availabe_false"
		
	--Print new line to separate new test cases group
	commonFunctions:newTestCasesGroup(TestCaseName)
		
	isReady:StopStartSDL_HMI_MOBILE(self, 0, TestCaseName)
		
			
	-----------------------------------------------------------------------------------------------
	--CRQ #1) 
			-- VR:  APPLINK-25042: [VR Interface] VR.IsReady(false) -> HMI respond with successfull resultCode to splitted RPC
			-- UI:  APPLINK-25102: [UI Interface] UI.IsReady(false) -> HMI respond with successfull resultCode to splitted RPC
			-- TTS: APPLINK-25133: [TTS Interface] TTS.IsReady(false) -> HMI respond with successfull resultCode to splitted RPC
			-- VehicleInfo: Not applicable
			-- Navigation: Not applicable
	-- Verification criteria:
		-- In case SDL receives TestedInterface.IsReady (available=false) from HMI
		-- and mobile app sends RPC to SDL that must be split to:
		-- -> TestedInterface RPC
		-- -> any other <Interface>.RPC
		-- SDL must:
		-- transfer only <Interface>.RPC to HMI (in case <Interface> is supported by system)
		-- respond with 'UNSUPPORTED_RESOURCE, success:true,' + 'info: TestedInterface is not supported by system' to mobile app IN CASE <Interface>.RPC was successfully processed by HMI (please see list with resultCodes below)
	
	-----------------------------------------------------------------------------------------------	
	commonSteps:RegisterAppInterface("Precondition_RegisterAppInterface_"..TestCaseName)
		
	-- Description: Activation app for precondition
	commonSteps:ActivationApp( nil, "Precondition_ActivationApp_"..TestCaseName)

	commonSteps:PutFile("PutFile_MinLength", "a")
	commonSteps:PutFile("PutFile_icon.png", "icon.png")
	commonSteps:PutFile("PutFile_action.png", "action.png")

	-- For VehicleInfo and Navigation specified requirements are not applicable.
	if( (TestedInterface ~= "VehicleInfo") and (TestedInterface~="Navigation") ) then
		--local function VR_IsReady_response_availabe_false_check_split_RPC_Other_Interfaces_Responds_SUCCESS(TestCaseName)
		local function Interface_IsReady_response_availabe_false_check_split_RPC_Other_Interfaces_Responds_SUCCESS(TestCaseName)

			-- List of successful resultCodes (success:true)
			local TestData = {
								{resultCode = "SUCCESS", 		info = TestedInterface .." is not supported by system"},
								{resultCode = "WARNINGS", 		info = TestedInterface .." is not supported by system"},
								{resultCode = "WRONG_LANGUAGE", info = TestedInterface .." is not supported by system"},
								{resultCode = "RETRY", 			info = TestedInterface .." is not supported by system"},
								{resultCode = "SAVED", 			info = TestedInterface .." is not supported by system"}
							}

			-- All applicable RPCs
			for i = 1, #TestData do
			--for i = 1, 1 do
				for count_RPC = 1, #RPCs do
					local mob_request = mobile_request[count_RPC]
					local hmi_call = RPCs[count_RPC]
					local other_interfaces_call = {}			
					local hmi_method_call = TestedInterface.."."..hmi_call.name
					local vrCmd = ""
					local local_menuparams = ""

					if(mob_request.splitted == true) then
						-- Preconditions should be executed only once.
						if( i == 1) then
							-- Precondition: for RPC DeleteCommand is using AddCommand
							--
							-- if(mob_request.name == "DeleteCommand") then
							-- 	Test["Precondition_AddCommand_1_"..TestCaseName] = function(self)
							-- 		--mobile side: sending AddCommand request
							-- 		local cid = self.mobileSession:SendRPC("AddCommand",
							-- 		{
							-- 			cmdID = 1,
							-- 			vrCommands = {"vrCommands_1"},
							-- 			menuParams = {position = 1, menuName = "Command 1"}
							-- 		})
									
							-- 		--hmi side: expect VR.AddCommand request
							-- 		EXPECT_HMICALL("VR.AddCommand", 
							-- 		{ 
							-- 			cmdID = 1,
							-- 			type = "Command",
							-- 			vrCommands = {"vrCommands_1"}
							-- 		})
							-- 		:Do(function(_,data)
							-- 			--hmi side: sending VR.AddCommand response
							-- 			self.hmiConnection:SendResponse(data.id, data.method, "SUCCESS", {})						
							-- 			grammarID = data.params.grammarID
							-- 		end)
										
							-- 		--hmi side: expect UI.AddCommand request 
							-- 		EXPECT_HMICALL("UI.AddCommand", 
							-- 		{ 
							-- 			cmdID = 1,		
							-- 			menuParams = {position = 1, menuName ="Command 1"}
							-- 		})
							-- 		:Do(function(_,data)
							-- 			--hmi side: sending UI.AddCommand response
							-- 			self.hmiConnection:SendResponse(data.id, data.method, TestData[i].resultCode, {})
							-- 		end)
										
										
							-- 		--mobile side: expect AddCommand response
							-- 		EXPECT_RESPONSE(cid, { success = true, resultCode = "SUCCESS"})

							-- 		--mobile side: expect OnHashChange notification
							-- 		if(mob_request.hashChange == true) then
							-- 			EXPECT_NOTIFICATION("OnHashChange")
							-- 			:Timeout(iTimeout)
							-- 		else
							-- 			EXPECT_NOTIFICATION("OnHashChange")
							-- 			:Times(0)
							-- 		end
							-- 	end
							-- end						
						
							--Precondition: for RPC PerformInteraction: CreateInteractionChoiceSet
							if(mob_request.name == "PerformInteraction") then
								Test["Precondition_PerformInteraction_CreateInteractionChoiceSet_" .. i.."_"..TestCaseName] = function(self)
									--mobile side: sending CreateInteractionChoiceSet request
									local cid = self.mobileSession:SendRPC("CreateInteractionChoiceSet",
																		{
																			interactionChoiceSetID = i + 1,
																			choiceSet = {{ 
																								choiceID = i + 1,
																								menuName ="Choice" .. tostring(i + 1),
																								vrCommands = 
																								{ 
																									"VrChoice" .. tostring(i + 1),
																								}, 
																								image =
																								{ 
																									value ="icon.png",
																									imageType ="STATIC",
																								}
																						}}
																		})
								
									--hmi side: expect VR.AddCommand
									EXPECT_HMICALL("VR.AddCommand", 
											{ 
												cmdID = i + 1,
												type = "Choice",
												vrCommands = {"VrChoice"..tostring(i + 1) }
											})
									:Do(function(_,data)						
										--hmi side: sending VR.AddCommand response
										self.hmiConnection:SendResponse(data.id, data.method, "SUCCESS", {})
										grammarID = data.params.grammarID
									end)		
								
									--mobile side: expect CreateInteractionChoiceSet response
									EXPECT_RESPONSE(cid, { resultCode = "SUCCESS", success = true  })
								end
							end	-- if(mob_request.name == "PerformInteraction")					
						end --if( i == 1)

						Test["TC01_"..TestCaseName .. "_"..mob_request.name.."_UNSUPPORTED_RESOURCE_true_Incase_OtherInterfaces_responds_" .. TestData[i].resultCode] = function(self)
							if(TestData[i].resultCode == "SAVED") then
								 print ("\27[31m ATF defect should be created for HMI result_code SAVED. Please investigate! \27[0m")
							end
							--======================================================================================================
							-- Update of used params
								if ( hmi_call.params.appID ~= nil ) then hmi_call.params.appID = self.applications[config.application1.registerAppInterfaceParams.appName] end
								if ( mob_request.params.cmdID      ~= nil ) then mob_request.params.cmdID = i end
								if ( mob_request.params.vrCommands ~= nil ) then mob_request.params.vrCommands =  {"vrCommands_" .. tostring(i)} end
								if ( mob_request.params.menuParams ~= nil ) then mob_request.params.menuParams =  {position = 1, menuName = "Command " .. tostring(i)} end
							--======================================================================================================
							commonTestCases:DelayedExp(iTimeout)
					
							--mobile side: sending RPC request
							local cid = self.mobileSession:SendRPC(mob_request.name, mob_request.params)
								
							--hmi side: expect Interface.RPC request 	
							for cnt = 1, #NotTestedInterfaces do
								for cnt_rpc = 1, #NotTestedInterfaces[cnt].usedRPC do
							
						 			local local_interface = NotTestedInterfaces[cnt].interface
						 			local local_rpc = NotTestedInterfaces[cnt].usedRPC[cnt_rpc].name
						 			local local_params = NotTestedInterfaces[cnt].usedRPC[cnt_rpc].params
						 		
						 			if (local_rpc == hmi_call.name) then
										
										--======================================================================================================
										-- Update of verified params
											if ( local_params.cmdID ~= nil )      then local_params.cmdID = i end
											if ( local_params.vrCommands ~= nil ) then local_params.vrCommands = {"vrCommands_" .. tostring(i)} end
											
											if ( local_params.menuParams ~= nil ) then local_params.menuParams =  {position = 1, menuName ="Command "..tostring(i)} end
				 							if ( local_params.appID ~= nil )      then local_params.appID = self.applications[config.application1.registerAppInterfaceParams.appName] end
				 							if ( local_params.grammarID ~= nil ) then 
										  		if (mob_request.name == "DeleteCommand") then
										  			local_params.grammarID =  grammarID  
												else
										  			local_params.grammarID[1] =  grammarID  
										  		end
										  	end
										--======================================================================================================

						 				EXPECT_HMICALL(local_interface.."."..local_rpc, local_params)
										:Do(function(_,data)
											--hmi side: sending Interface.RPC response 
											self.hmiConnection:SendResponse(data.id, data.method, TestData[i].resultCode, {})
										end)	
						 			end --if (local_rpc == hmi_call.name) then
						 		end--for cnt_rpc = 1, #NotTestedInterfaces[cnt].usedRPC do
							end--for cnt = 1, #NotTestedInterfaces do

							if(mob_request.name == "Alert" or mob_request.name == "PerformAudioPassThru") then
								--hmi side: TTS.Speak request 
								EXPECT_HMICALL("TTS.Speak", {})
								:Do(function(_,data)
									self.hmiConnection:SendNotification("TTS.Started")
							
									local function speakResponse()
										self.hmiConnection:SendResponse(SpeakId, "TTS.Speak", "SUCCESS", { })
										self.hmiConnection:SendNotification("TTS.Stopped")
									end
										RUN_AFTER(speakResponse, 2000)

									end)
							end
							
							--hmi side: expect there is no request is sent to the testing interface.
							EXPECT_HMICALL(hmi_method_call, {})
							:Times(0)
							
							--mobile side: expect RPC response
							EXPECT_RESPONSE(cid, {success = true, resultCode = "UNSUPPORTED_RESOURCE", info = TestData[i].info})
							:Timeout(iTimeout)

							--mobile side: expect OnHashChange notification
							if(mob_request.hashChange == true) then
								EXPECT_NOTIFICATION("OnHashChange")
								:Timeout(iTimeout)
							else
								EXPECT_NOTIFICATION("OnHashChange")
								:Times(0)
							end
						end
					end --if(mob_request.splitted == true) then
				end --for count_RPC = 1, #RPCs do
			end --for i = 1, #TestData do
		end

		--VR_IsReady_response_availabe_false_check_split_RPC_Other_Interfaces_Responds_SUCCESS("VR_IsReady_availabe_false_split_RPC_SUCCESS")
		Interface_IsReady_response_availabe_false_check_split_RPC_Other_Interfaces_Responds_SUCCESS(TestedInterface .."_IsReady_availabe_false_split_RPC_SUCCESS")
	else
		print("\27[31m This case is not applicable for "..TestedInterface .." \27[0m")
	end -- if( (TestedInterface ~= "VehicleInfo") and (TestedInterface~="Navigation") ) then
		
		
	-----------------------------------------------------------------------------------------------	
	--CRQ #2) 
			-- VR:  APPLINK-25043: [VR Interface] VR.IsReady(false) -> HMI respond with errorCode to splitted RPC
			-- UI:  APPLINK-25100: [UI Interface] UI.IsReady(false) -> HMI respond with errorCode to splitted RPC
			-- TTS: APPLINK-25134: [TTS Interface] TTS.IsReady(false) -> HMI respond with errorCode to splitted RPC
			-- VehicleInfo: Not applicable
			-- Navigation:  Not applicable
	--Verification criteria:
		-- In case SDL receives TestedInterface.IsReady (available=false) from HMI
		-- and mobile app sends RPC to SDL that must be split to:
		-- -> TestedInterface RPC
		-- -> any other <Interface>.RPC 
		-- SDL must:
		-- transfer only <Interface>.RPC to HMI (in case <Interface> is supported by system)
		-- respond with '<received_errorCode_from_HMI>' to mobile app IN CASE <Interface>.RPC got any erroneous resultCode from HMI (please see list with resultCodes below)
	-----------------------------------------------------------------------------------------------	
	--ToDo: Update according to question APPLINK-26900
	-- For VehicleInfo and Navigation specified requirements are not applicable.
	if( (TestedInterface ~= "VehicleInfo") and (TestedInterface~="Navigation") ) then	

			--local function VR_IsReady_response_availabe_false_check_split_RPC_Other_Interfaces_Responds_Error(TestCaseName)
			local function Interface_IsReady_response_availabe_false_check_split_RPC_Other_Interfaces_Responds_Error(TestCaseName)
				
				-- List of erroneous resultCodes (success:false)
				local TestData = {
				
									{resultCode = "UNSUPPORTED_REQUEST", 		info = TestedInterface .." is not supported by system"},
									{resultCode = "DISALLOWED", 				info = TestedInterface .." is not supported by system"},
									{resultCode = "USER_DISALLOWED", 			info = TestedInterface .." is not supported by system"},
									{resultCode = "REJECTED", 					info = TestedInterface .." is not supported by system"},
									{resultCode = "ABORTED", 					info = TestedInterface .." is not supported by system"},
									{resultCode = "IGNORED", 					info = TestedInterface .." is not supported by system"},
									{resultCode = "IN_USE", 					info = TestedInterface .." is not supported by system"},
									{resultCode = "VEHICLE_DATA_NOT_AVAILABLE", info = TestedInterface .." is not supported by system"},
									{resultCode = "TIMED_OUT", 					info = TestedInterface .." is not supported by system"},
									{resultCode = "INVALID_DATA", 				info = TestedInterface .." is not supported by system"},
									{resultCode = "CHAR_LIMIT_EXCEEDED", 		info = TestedInterface .." is not supported by system"},
									{resultCode = "INVALID_ID", 				info = TestedInterface .." is not supported by system"},
									{resultCode = "DUPLICATE_NAME", 			info = TestedInterface .." is not supported by system"},
									{resultCode = "APPLICATION_NOT_REGISTERED", info = TestedInterface .." is not supported by system"},
									{resultCode = "OUT_OF_MEMORY", 				info = TestedInterface .." is not supported by system"},
									{resultCode = "TOO_MANY_PENDING_REQUESTS", 	info = TestedInterface .." is not supported by system"},
									{resultCode = "GENERIC_ERROR", 				info = TestedInterface .." is not supported by system"},
									{resultCode = "TRUNCATED_DATA", 			info = TestedInterface .." is not supported by system"},
									{resultCode = "UNSUPPORTED_RESOURCE", 		info = TestedInterface .." is not supported by system"},
									{resultCode = "NOT_RESPOND", 				info = TestedInterface .." is not supported by system"}
								}		
			
				-- All RPCs		
				for i = 1, #TestData do
				--for i = 1, 1 do
					for count_RPC = 1, #RPCs do
						local mob_request = mobile_request[count_RPC]
						local hmi_call = RPCs[count_RPC]
						local other_interfaces_call = {}			
						local hmi_method_call = TestedInterface.."."..hmi_call.name
						
						if(mob_request.splitted == true) then
							if( i == 1) then
								-- Precondition: for RPC DeleteCommand
								if(mob_request.name == "DeleteCommand") then
									Test["Precondition_AddCommand_1_"..TestCaseName] = function(self)
										--mobile side: sending AddCommand request
										local cid
										if(TestedInterface == "UI") then
											cid = self.mobileSession:SendRPC("AddCommand",
																							{
																								cmdID = 1,
																								vrCommands = {"vrCommands_1"},
																								--menuParams = {position = 1, menuName = "Command 1"}
																							})
											--hmi side: expect VR.AddCommand request
											EXPECT_HMICALL("VR.AddCommand", 
											{ 
												cmdID = 1,
												type = "Command",
												vrCommands = {"vrCommands_1"}
											})
											:Do(function(_,data)
												--hmi side: sending VR.AddCommand response
												self.hmiConnection:SendResponse(data.id, data.method, "SUCCESS", {})						
												grammarID = data.params.grammarID
											end)
										else
											cid = self.mobileSession:SendRPC("AddCommand",
																							{
																								cmdID = 1,
																								--vrCommands = {"vrCommands_1"},
																								menuParams = {position = 1, menuName = "Command 1"}
																							})
											--hmi side: expect UI.AddCommand request 
											EXPECT_HMICALL("UI.AddCommand", 
											{ 
												cmdID = 1,		
												menuParams = {position = 1, menuName ="Command 1"}
											})
											:Do(function(_,data)
												--hmi side: sending UI.AddCommand response
												--self.hmiConnection:SendResponse(data.id, data.method, TestData[i].resultCode, {})
												self.hmiConnection:SendError(data.id, data.method, TestData[i].resultCode, "Error Messages")
											end)
										end
											
										--mobile side: expect AddCommand response
										EXPECT_RESPONSE(cid, { success = true, resultCode = "SUCCESS"})

										--mobile side: expect OnHashChange notification
										if(mob_request.hashChange == true) then
											EXPECT_NOTIFICATION("OnHashChange")
											:Timeout(iTimeout)
										else
											EXPECT_NOTIFICATION("OnHashChange")
											:Times(0)
										end
									end
								end						
							
								--Precondition: for RPC PerformInteraction: CreateInteractionChoiceSet
								if(mob_request.name == "PerformInteraction") then
									Test["Precondition_PerformInteraction_CreateInteractionChoiceSet_" .. i.."_"..TestCaseName] = function(self)
										--mobile side: sending CreateInteractionChoiceSet request
										local cid = self.mobileSession:SendRPC("CreateInteractionChoiceSet",
																			{
																				interactionChoiceSetID = i + 1,
																				choiceSet = {{ 
																									choiceID = i + 1,
																									menuName ="Choice" .. tostring(i + 1),
																									vrCommands = 
																									{ 
																										"VrChoice" .. tostring(i + 1),
																									}, 
																									image =
																									{ 
																										value ="icon.png",
																										imageType ="STATIC",
																									}
																							}}
																			})
									
										--hmi side: expect VR.AddCommand
										EXPECT_HMICALL("VR.AddCommand", 
												{ 
													cmdID = i + 1,
													type = "Choice",
													vrCommands = {"VrChoice"..tostring(i + 1) }
												})
										:Do(function(_,data)						
											--hmi side: sending VR.AddCommand response
											self.hmiConnection:SendResponse(data.id, data.method, "SUCCESS", {})
											grammarID = data.params.grammarID
										end)		
									
										--mobile side: expect CreateInteractionChoiceSet response
										EXPECT_RESPONSE(cid, { resultCode = "SUCCESS", success = true  })
									end
								end	-- if(mob_request.name == "PerformInteraction")					
							end --if( i == 1)

						
							Test["TC02_"..TestCaseName .. "_"..mob_request.name.."_UNSUPPORTED_RESOURCE_true_Incase_UI_responds_" .. TestData[i].resultCode] = function(self)
								--Test[TestCaseName .. "_AddCommand_UNSUPPORTED_RESOURCE_true_Incase_UI_responds_" .. TestData[i].resultCode] = function(self)
								--======================================================================================================
								-- Update of used params
									if ( hmi_call.params.appID ~= nil ) then hmi_call.params.appID = self.applications[config.application1.registerAppInterfaceParams.appName] end

									if ( mob_request.params.cmdID      ~= nil ) then mob_request.params.cmdID = i end
									if ( mob_request.params.vrCommands ~= nil ) then mob_request.params.vrCommands =  {"vrCommands_" .. tostring(i)} end
									if ( mob_request.params.menuParams ~= nil ) then mob_request.params.menuParams =  {position = 1, menuName = "Command " .. tostring(i)} end
								--======================================================================================================
								
								commonTestCases:DelayedExp(iTimeout)
						
								--mobile side: sending RPC request
								local cid = self.mobileSession:SendRPC(mob_request.name, mob_request.params)
									
								--hmi side: expect UI.AddCommand request 
								for cnt = 1, #NotTestedInterfaces do
									
									for cnt_rpc = 1, #NotTestedInterfaces[cnt].usedRPC do
								 		local local_interface = NotTestedInterfaces[cnt].interface
								 		local local_rpc = NotTestedInterfaces[cnt].usedRPC[cnt_rpc].name
								 		local local_params = NotTestedInterfaces[cnt].usedRPC[cnt_rpc].params
								 		
								 		if (local_rpc == hmi_call.name) then
								 			--======================================================================================================
											-- Update of verified params
												if ( local_params.cmdID ~= nil )      then local_params.cmdID = i end
												if ( local_params.vrCommands ~= nil ) then local_params.vrCommands = {"vrCommands_" .. tostring(i)} end
												
												if ( local_params.menuParams ~= nil ) then local_params.menuParams =  {position = 1, menuName ="Command "..tostring(i)} end
				 								if ( local_params.appID ~= nil )      then local_params.appID = self.applications[config.application1.registerAppInterfaceParams.appName] end
				 								if ( local_params.grammarID ~= nil ) then 
											  		if (mob_request.name == "DeleteCommand") then
											  			local_params.grammarID =  grammarID  
													else
											  			local_params.grammarID[1] =  grammarID  
											  		end
											  	end
											--======================================================================================================

								 			EXPECT_HMICALL(local_interface.."."..local_rpc, local_params)
											:Do(function(_,data)
												--hmi side: sending Interface.RPC response 
												if TestData[i].resultCode == "NOT_RESPOND" then
													--HMI does not respond
												else
													self.hmiConnection:SendError(data.id, data.method, TestData[i].resultCode, {})
												end
											end)	
								 		end
								 	end --for cnt_rpc = 1, #NotTestedInterfaces[cnt].usedRPC do
								end --for cnt = 1, #NotTestedInterfaces do
								
								
								--hmi side: expect there is no request is sent to the testing interface.
								EXPECT_HMICALL(hmi_method_call, {})
								:Times(0)
								
								--mobile side: expect RPC response
								if TestData[i].resultCode == "NOT_RESPOND" then
									EXPECT_RESPONSE(cid, {success = false, resultCode = "GENERIC_ERROR"})
									:Timeout(12000)
								else
									EXPECT_RESPONSE(cid, {success = false, resultCode = TestData[i].resultCode, info = TestData[i].info})
								end
								
								--mobile side: expect OnHashChange notification is not sent
								EXPECT_NOTIFICATION("OnHashChange")
								:Times(0)
							end
						end --if(mob_request.splitted == true) then
					end --for count_RPC = 1, #RPCs do
				end -- for i = 1, #TestData do
			end
			
			--VR_IsReady_response_availabe_false_check_split_RPC_Other_Interfaces_Responds_Error("VR_IsReady_availabe_false_split_RPC_Unsuccess")
			Interface_IsReady_response_availabe_false_check_split_RPC_Other_Interfaces_Responds_Error(TestedInterface .."_IsReady_availabe_false_split_RPC_Unsuccess")
			--end
	else
		print("\27[31m This case is not applicable for "..TestedInterface .." \27[0m")
	end --if( (TestedInterface ~= "VehicleInfo") and (TestedInterface~="Navigation") ) then	
	


----------------------------------------------------------------------------------------------
-----------------------------------------TEST BLOCK IV----------------------------------------
------------------------------Check special cases of HMI response-----------------------------
----------------------------------------------------------------------------------------------

-- These cases are merged into TEST BLOCK III


	
-----------------------------------------------------------------------------------------------
-------------------------------------------TEST BLOCK V----------------------------------------
-------------------------------------Checks All Result Codes-----------------------------------
-----------------------------------------------------------------------------------------------

--Not applicable



----------------------------------------------------------------------------------------------
-----------------------------------------TEST BLOCK VI----------------------------------------
-------------------------Sequence with emulating of user's action(s)--------------------------
----------------------------------------------------------------------------------------------

--Not applicable



----------------------------------------------------------------------------------------------
-----------------------------------------TEST BLOCK VII---------------------------------------
--------------------------------------Different HMIStatus-------------------------------------
----------------------------------------------------------------------------------------------
-- Not applicable

function Test:Postcondition_RestorePreloadedFile()
	commonPreconditions:RestoreFile("sdl_preloaded_pt.json")
end

return Test