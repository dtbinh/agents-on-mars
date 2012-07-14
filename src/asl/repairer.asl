// Agent Repairer

/* Initial beliefs and rules */
is_not_help_goal		:-	need_help(Ag) & not_need_help(Ag).
is_help_goal				:-	need_help(Ag) & not help_target(_).
is_help_target_goal	:-	help_target(Ag) & jia.agent_position(Ag,Pos) & not position(Pos) & not has_saboteur_at(Pos).
is_repair_goal			:-	help_target(Ag) & jia.agent_position(Ag,Pos) & position(Pos).

/* Initial goals */

+!repairer_goal
	<-	.print("Starting repairer_goal"); 
			!select_repairer_goal.


+!select_repairer_goal
	:	is_call_help_goal
		<-	!init_goal(call_help);
				!!select_repairer_goal.

+!select_repairer_goal
	:	is_not_need_help_goal
	<-	!init_goal(not_need_help);
			!!select_repairer_goal.

+!select_repairer_goal
	:	is_energy_goal
	<-	!init_goal(be_at_full_charge);
			!!select_repairer_goal.

+!select_repairer_goal
	:	is_not_help_goal
	<-	!init_goal(not_help);
			!!select_repairer_goal.

+!select_repairer_goal
	:	is_repair_goal & help_target(Ag)
	<-	jia.agent_server_id(Ag,Id);
			!do_and_wait_next_step(repair(Id));
			!!select_repairer_goal.

+!select_repairer_goal
	:	need_help(Ag) & jia.agent_position(Ag,Pos) & position(Pos)
	<-	jia.agent_server_id(Ag,Id);
			!do_and_wait_next_step(repair(Id));
			!!select_repairer_goal.

+!select_repairer_goal
	:	is_parry_goal
	<-	!init_goal(parry);
			!!select_repairer_goal.

+!select_repairer_goal
	:	is_help_goal
	<-	.findall(X, need_help(X), Agents);
			jia.closer_agent(Agents,Ag,Pos);
			+help_target(Ag);
			!!select_repairer_goal.

+!select_repairer_goal
	:	is_help_target_goal & help_target(Ag) & position(X)
	<-	jia.agent_position(Ag,Pos);
			jia.move_to_target(X,Pos,NextPos);
			!do_and_wait_next_step(goto(NextPos));
			!!select_repairer_goal.

+!select_repairer_goal
	:	is_disabled_goal
	<-	!init_goal(go_to_repairer);
			!!select_repairer_goal.

+!select_repairer_goal
	:	is_move_goal
	<-	!init_goal(move_to_target);
			!!select_repairer_goal.

+!select_repairer_goal
	:	is_wait_goal
	<-	!init_goal(wait);
			!!select_repairer_goal.

+!select_repairer_goal
	<- 	!init_goal(random_walk);
			!!select_repairer_goal.

+!not_help
	: need_help(Ag) & not_need_help(Ag)
	<-	.abolish(need_help(Ag));
			.abolish(not_need_help(Ag));
			!remove_help_target.

+!remove_help_target
	:	help_target(Ag) & not need_help(Ag)
	<-	.abolish(help_target(Ag)).
+!remove_help_target.