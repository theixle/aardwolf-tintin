#class gmcp kill;
#CLASS {gmcp} OPEN


#format IAC  %a 255
#format DONT %a 254
#format DO   %a 253
#format WONT %a 252
#format WILL %a 251
#format SB   %a 250
#format SE   %a 240

#format GMCP %a 201

#ALIAS {debug {on|off}}
{
	#if {"%1" == "on"}
	{
		#variable debug 1
	};
	#else
	{
		#variable debug 0
	};
	#nop;
}
{5}

#EVENT {IAC SB GMCP char.maxstats IAC SE}
{
	#variable GMCP[CHAR][MAXSTATS] {%0};
	#if {$debug}
	{
		#showme %1
	};
	#nop;
}

#event {IAC SB GMCP group IAC SE}
{
	#var GMCP[GROUP] {%0};
	#sys {echo "" > $dir/log/group};
	#foreach {$GMCP[GROUP][members][]} {gmcp_groupie}
	{
		#if {"gmcp_groupie_list" != ""}
		{
			#var {pregroup} {$gmcp_groupie_list\n}
		}
		{
			#var pregroup {}
		};
		#math {hp_percent_tmp} {1.0*($GMCP[GROUP][members][$gmcp_groupie][info][hp]/$GMCP[GROUP][members][$gmcp_groupie][info][mhp])*100};
		#math {mn_percent_tmp} {1.0*($GMCP[GROUP][members][$gmcp_groupie][info][mn]/$GMCP[GROUP][members][$gmcp_groupie][info][mmn])*100};
		#math {mv_percent_tmp} {1.0*($GMCP[GROUP][members][$gmcp_groupie][info][mv]/$GMCP[GROUP][members][$gmcp_groupie][info][mmv])*100};
		#format {gmcp_groupie_list}
		{
			$pregroup
			%c$GMCP[GROUP][members][$gmcp_groupie][name]	%cLevel%c: %c$GMCP[GROUP][members][$gmcp_groupie][info][lvl]\n
			%cHP%c:%c${hp_percent_tmp}  %cMN%c:%c${mn_percent_tmp}  %cMV%c:%c${mv_percent_tmp}\n
			%cTNL%c:%c$GMCP[GROUP][members][$gmcp_groupie][info][tnl] %cAlign%c:%c$GMCP[GROUP][members][$gmcp_groupie][info][align] <acc>QT<eff>: <afc>$GMCP[GROUP][members][$gmcp_groupie][info][qt]
		} {light red} {cyan} {light black} {blue} {green} {light black} {light green} {blue} {light black} {light blue} {yellow} {light black} {light yellow} {light white} {light black} {green} {light white} {light black} {light cyan}
	};
    #line log {$dir/log/group} {$gmcp_groupie_list};
	#var gmcp_groupie_list {};
}

#EVENT {IAC SB GMCP char.status IAC SE}
{
	#variable GMCP[CHAR][STATUS] {%0};
	#if {$debug}
	{
		#showme %1
	};
	||gmcp_prompt_statmon;
	#nop;
}

#EVENT {IAC SB GMCP char.vitals IAC SE}
{
	#variable GMCP[CHAR][VITALS] {%0};
	#if {$debug}
	{
		#showme %1
	};
	||gmcp_prompt_statmon;
	#nop;
}

#EVENT {IAC SB GMCP char.worth IAC SE}
{
	#variable GMCP[CHAR][WORTH] {%0};
	#if {$debug}
	{
		#showme %1
	};
	#nop
}

#alias {afk {on|off}}
{
	#if {"%1" == "on"}
	{
		#var afk 1;
		#var prewarning 0;
	}
	{
		#var afk 0;
		#var tellsent {};
	}
}



#EVENT {IAC SB GMCP comm.channel IAC SE}
{
	#var {GMCP[COMM][CHATLOGGER]} {%0};
	#var {chanrec} {$GMCP[COMM][CHATLOGGER][chan]};
	#var {player} {$GMCP[COMM][CHATLOGGER][player]};
	#if {"$GMCP[COMM][CHATLOGGER][chan]" != "mobsay"}
	{
		#line log {$dir/log/Aardwolf-chats} {$GMCP[COMM][CHATLOGGER][msg]};
	};
	#if {$debug}
	{
		#showme %1
	};
	#if {"$GMCP[COMM][CHATLOGGER][chan]" == "tell"}
	{
		#if {$afk}
		{
			#if {!$tellsent[$GMCP[COMM][CHATLOGGER][player]]}
			{
				#if {"$GMCP[COMM][CHATLOGGER][player]" != "Cheezburger"}
				{
					#var {tellsent[$GMCP[COMM][CHATLOGGER][player]]} {1};
					reply Sorry, but I'm afk: @Y[@R$afk_reason@Y]@c;
				}
			}
		}
	};
}


#EVENT {IAC SB GMCP char.stats IAC SE}
{
	#variable GMCP[CHAR][STATS] {%0};
	#if {$debug}
	{
		#showme %1
	};
	#nop;
}

#EVENT {IAC SB GMCP comm.repop IAC SE}
{
	#var {GMCP[COMM][REPOP]} {%0};
	#format {curr_time} {%T};
	#if {$repoptrack}
	{
		#if {$repop}
		{
			#format {last_repop} {%T};
		}
	};
	#format {time} {%t} {%H:%M:%S};
	$repchan @WRepop @w= @r$GMCP[COMM][REPOP][zone]@w @@ @r$time;
	#var time {};
	#nop;
}

#alias {^repopwatch {on|off}$}
{
	#if {"%1" == on"}
	{
		#var repoptrack 1;
	}
	{
		#var repoptrack 0;
	}
}

#alias {^check repop$}
{
	#format curr_time {%T};
	#math {time_till_pop} {($last_repop+606)-$curr_time};
	#send {$repchan @CNext repop@w: @R$time_till_pop @Wseconds.};
};

#EVENT {IAC SB GMCP char.base IAC SE}
{
	#variable GMCP[CHAR][BASE] {%0};
	#nop;
}

#event {IAC SB GMCP room.info IAC SE}
{
    #var GMCP[ROOM][INFO] {%0};
	#if {$mapping}
	{
		#if {"$GMCP[ROOM][INFO][details]" != "%*maze%*" && $GMCP[ROOM][INFO][num] != -1}
		{
		    #map goto {$GMCP[ROOM][INFO][num]} {dig};
		    #map get roomname {mapresult};
			#if {"$mapresult" == "{\d+}"}
			{
				    #map set roomname $GMCP[ROOM][INFO][name];
				    #map set roomvnum $GMCP[ROOM][INFO][num];
				    #map set roomarea $GMCP[ROOM][INFO][zone];
				    #map set roomterrain $GMCP[ROOM][INFO][terrain];
				    #map set roomcolor <178>
			};

			#foreach {$GMCP[ROOM][INFO][exits][]} {exit}
			{
				    #map get {roomexit} {mapresult};

				    #if {&mapresult[$exit] == 0}
				    {
				            #map get {roomvnum} {mapresult} {$GMCP[ROOM][INFO][exits][$exit]};

				            #map dig {$exit} {$GMCP[ROOM][INFO][exits][$exit]};

				            #if {$mapresult == 0}
				            {
				                    #map set {roomcolor} {<fca>} {$GMCP[ROOM][INFO][exits][$exit]}
				            }
				    }
			}
		};
	};
	#if {$GMCP[ROOM][INFO][num] != -1}
        {
                #MAP GOTO {$GMCP[ROOM][INFO][num]}
        }
}

#event {IAC SB GMCP comm.tick IAC SE}{#var ticks 30};
#var repop 0;
#var ticks 30;
#tic TICKING
{
    #if {$ticks > 0}
    {
        #math ticks {$ticks - 1};
    };

    #if {$ticks < 10}
    {#show {<139>  $ticks<099> secs to tick     QUEST<099>: <139>$timer} 3}
    {#show {<139> $ticks<099> secs to tick     QUEST<099>: <139>$timer} 3}
}
{1};
#EVENT {IAC WILL GMCP}
{
	#send {$IAC$DO$GMCP\};
	#send {$IAC$SB$GMCP Core.Hello { "client": "$CLIENT_NAME", "version": "$CLIENT_VERSION" } $IAC$SE\};
	#send {$IAC$SB$GMCP Core.Supports.Set [ "Room 1", "Char 1", "Core 1", "Comm 1", "Debug 1", "Group 1" ] $IAC$SE\}
}

#EVENT {MAP ENTER ROOM}
{
        #if $mapping
	{
		#map get roomarea oldarea;
        	#if {"$oldarea"==""}
        	{
                	#map set roomarea $GMCP[ROOM][INFO][zone]
        	};
        	#map get roomterrain oldterrain;
        	#if {"$oldterrain"==""}
        	{
                	#map set roomterrain $GMCP[ROOM][INFO][terrain]
        	};
		#map get roomname oldname;
                #if {"$oldname"==""}
                {
                        #map set roomname $GMCP[ROOM][INFO][name]
                }

	}
}


#EVENT {PROGRAM START}
{
	#variable CLIENT_NAME %0;
	#variable CLIENT_VERSION %1;
}

#EVENT  {SESSION DISCONNECTED}
{
	#map write {$dir/log/map-discon.txt};
	#history write {$dir/log/history-discon.txt};
	#class variables write {$dir/conf/variables.tin}
}

#EVENT	{SESSION CONNECTED}
{
	$name;
    #nop If a password variable is set, send it on connect;
	#if {&{password}} {$password};
	#history read {$dir/log/history-discon.txt}
}

#ACTION {^############# Reconnecting to Game #############$}
{
        #delay 2
        {
            slist spellup;
            spup resume;
            #NOP bug: For some reason have to do this twice?;
            slist spellup;
            #NOP Turn the tags on for them;
            tags map on;
            tags mapnames on;
            tags mapexits on;
            tags channels on;
            tags roomchars on;
            tags spellups on;
        };
        protocol gmcp sendchar;
        #NOP Put the Tintin map in the right room;
        #send {look}
}

#ACTION {^Welcome to Aardwolf. May your adventures be mystical, challenging and rewarding.}
{
        #delay 2
        {
            slist spellup;
            spup resume;
            #NOP bug: For some reason have to do this twice?;
            slist spellup;
            #NOP Turn the tags on for them;
            tags map on;
            tags mapnames on;
            tags mapexits on;
            tags channels on;
            tags roomchars on;
            tags spellups on;
        };
        protocol gmcp sendchar;
        #NOP Put the Tintin map in the right room;
        #send {look}
}

#CLASS {gmcp} CLOSE
