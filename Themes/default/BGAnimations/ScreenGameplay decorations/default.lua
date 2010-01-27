local function CreateStops()
	local t = Def.ActorFrame { };
	local bars = Def.ActorFrame{ };
	local bpmFrame = Def.ActorFrame{ Name="BPMFrame"; };
	local stopFrame = Def.ActorFrame{ Name="StopFrame"; };

	local fFrameWidth = 380;
	local fFrameHeight = 8;
	if SSC then
	-- Straight rip off NCRX

		local song = GAMESTATE:GetCurrentSong();
		-- if we're using SSC, might as well use the StepsSeconds, which will
		-- almost always be more proper than a r21'd file.
		if song then
			local songLen = song:MusicLengthSeconds();

			local firstBeatSecs = song:GetElapsedTimeFromBeat(song:GetFirstBeat());
			local lastBeatSecs = song:GetElapsedTimeFromBeat(song:GetLastBeat());

			local bpms = song:GetTimingData():GetBPMs();

			local stops = song:GetTimingData():GetStops();
			for i=1,#stops do
				local data = split("=",stops[i]);
				local beat = data[1];
				local secs = data[2];
				local beatTime = song:GetElapsedTimeFromBeat(beat);

				stopFrame[#stopFrame+1] = Def.Quad {
					InitCommand=function(self)
						--self:diffuse(HSVA(192,1,0.8,0.8));
						self:shadowlength(0);
						self:shadowcolor( color("#FFFFFF77") );
						-- set width
						self:zoomto( math.max((secs/songLen)*fFrameWidth, 1), fFrameHeight );
						-- find location
						self:x( ( scale(beatTime, firstBeatSecs,lastBeatSecs, -fFrameWidth/2,fFrameWidth/2) ) );
					end;
					OnCommand=function(self)
						self:diffuse(Color("White"));
						self:sleep(beatTime-5);
						self:linear(1);
						self:diffuse(Color("Orange"));
						self:sleep(4);
						self:linear(2);
						self:diffusealpha(0);
					end;
					--OnCommand=cmd(diffuse,Color("White");sleep,math.min(0.00001+(secs-5),0.00001);linear,1;diffuse,Color("Orange");sleep,4;linear,2;diffusealpha,0);
					--OnCommand=cmd(diffuse,Color("White");linear,1;diffuse,Color("Orange"););
				};
			end;
		end;
		bars[#bars+1] = stopFrame;
		t[#t+1] = bars;
	end
	return t
end
local t = LoadFallbackB()
for pn in ivalues(PlayerNumber) do
	local MetricsName = "SongMeterDisplay" .. PlayerNumberToString(pn);
	t[#t+1] = Def.ActorFrame {
		InitCommand=function(self) 
			self:player(pn); 
			self:name(MetricsName); 
			ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen"); 
		end;
 		LoadActor( THEME:GetPathG( 'SongMeterDisplay', 'frame ' .. PlayerNumberToString(pn) ) ) .. {
			InitCommand=function(self)
				self:name('Frame'); 
				ActorUtil.LoadAllCommandsAndSetXY(self,MetricsName); 
			end;
		};
		CreateStops();
		Def.SongMeterDisplay {
			StreamWidth=THEME:GetMetric( MetricsName, 'StreamWidth' );
			Stream=LoadActor( THEME:GetPathG( 'SongMeterDisplay', 'stream ' .. PlayerNumberToString(pn) ) )..{
				InitCommand=cmd(diffusealpha,0.5;blend,Blend.Add;);
			};
			Tip=LoadActor( THEME:GetPathG( 'SongMeterDisplay', 'tip ' .. PlayerNumberToString(pn) ) );
		};
	};
end



t[#t+1] = StandardDecorationFromFileOptional("BPMDisplay","BPMDisplay");
t[#t+1] = StandardDecorationFromFileOptional("StageDisplay","StageDisplay");

return t